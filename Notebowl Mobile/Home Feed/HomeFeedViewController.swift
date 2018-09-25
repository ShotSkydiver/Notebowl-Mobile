//
//  HomeFeedViewController.swift
//  Notebowl Mobile
//
//  Created by Conner Owen on 2/7/18.
//  Copyright © 2018 NoteBowl. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
import HGPlaceholders
import QuartzCore
import SocketIO
import ObjectMapper
import Tamamushi
import SwipeCellKit
import DeckTransition
import PKHUD
import Bugsnag
import UserNotifications

class HomeFeedViewController: UIViewController, UpdateVC, CellActionsVC {
    var indexes: Paths = Paths()
    var posts: [Post]!
    @IBOutlet var bulletinTableView: HomeTableView!
    var placeholderTableView: HomeTableView?
    
    var cellHeights: [IndexPath : CGFloat] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bulletinTableView.alpha = 0.0
        navigationController?.setNavigationBarHidden(true, animated: false)
        tabBarController?.tabBar.isHidden = true
        
        let customView = Bundle.main.loadNibNamed("BulletinTableViewHeader", owner: nil, options: nil)!.first as! BulletinTableViewHeader
        customView.initSetup()
        customView.reloadAvatar()

        bulletinTableView.setTableHeaderView(headerView: customView)
        bulletinTableView.updateHeaderViewFrame()
        HomeFeedPostCell.register(in: bulletinTableView)
        bulletinTableView.placeholderDelegate = self as PlaceholderDelegate

        bulletinTableView.separatorColor = bulletinTableView.backgroundColor
        TMGradientNavigationBar().setGradientColorOnNavigationBar(bar: (navigationController?.navigationBar)!, direction: .horizontal, startColor: #colorLiteral(red: 0.04705882353, green: 0.4823529412, blue: 0.7568627451, alpha: 1), endColor: #colorLiteral(red: 0.04705882353, green: 0.5294117647, blue: 0.3607843137, alpha: 1), startPoint: CGPoint(x: 0.0, y: 0.0), endPoint: CGPoint(x: 0.6, y: 0.8))
        self.navigationController?.view.backgroundColor = UIColor.white
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func userProfileButton(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "segueDeck", sender: nil)
    }
    
    func reloadTable() {
        self.posts = (NBClient.shared.storedTypes.has(key: Post.classIdentifier) ? NBClient.shared.storedTypes[Post.classIdentifier]! as! [Post] : [])
        bulletinTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setNeedsStatusBarAppearanceUpdate()
        self.navigationController?.navigationBar.tintColor = UIColor.groupTableViewBackground
        let selectedRowIndexPath = self.bulletinTableView.indexPathForSelectedRow
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func afterFullyLoaded() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.sound,.alert,.badge]) { (granted, error) in
            if granted {
                TTLog.debug("Notification Enabled Successfully")
            } else if error != nil {
                TTLog.error("Some Error Occured, \(error!.localizedDescription)")
            }
        }
        NBSocket.shared.setup()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "postDetailSegue" {
            let destVC = segue.destination as! HomeFeedPostViewController
            if let sourceCell = sender as? HomeFeedPostCell {
                destVC.post = sourceCell.postForCell
            }
        }
        else if segue.identifier == "createPostSegue" {
            let destVC = segue.destination as! CreateNewPostViewController

            var courseForPicker = (NBClient.shared.storedTypes[Course.classIdentifier] as! [Course]).filter({ $0.isAvailable })
            courseForPicker.sort() { $0.fullName < $1.fullName }
            var pickerItems = courseForPicker as [NBModel]

            var groups = (NBClient.shared.storedTypes.has(key: Group.classIdentifier) ? NBClient.shared.storedTypes[Group.classIdentifier]! as! [Group] : [])
            groups.sort() { $0.fullName < $1.fullName }
            pickerItems += groups as [NBModel]

            destVC.objectsForPicker = pickerItems

            if sender is HomeFeedPostCell {
                destVC.editingExisting = true
                destVC.existingObjectToEdit = (sender as! HomeFeedPostCell).postForCell
            }
        }
    }
    
    func handleDeleteAction(objectToDelete: NBModel) {
        self.posts.removeAll(objectToDelete as! Post)
    }
}

extension HomeFeedViewController {
    func handleUpdated(newObject: NBModel) {
        if let newPost = newObject as? Post {
            self.posts = NBClient.shared.storedTypes[Post.classIdentifier]! as! [Post]
            let indexOfPost = self.posts.index(of: newPost)
            let existingPost = bulletinTableView.numberOfRows(inSection: 0) < self.posts.count ? false : true
            
            if self.bulletinTableView.cellForRow(at: IndexPath(row: 0, section: 0)) is PlaceholderTableViewCell {
                self.bulletinTableView.showDefault()
            }
            else if existingPost == false {
                self.bulletinTableView.insertRows(at: [IndexPath(row: indexOfPost!, section: 0)], with: .left)
            }
            else {
                self.posts[indexOfPost!].refresh()
                self.bulletinTableView.reloadRows(at: [IndexPath(row: indexOfPost!, section: 0)], with: .fade)
            }
        }
        else if ["Comment","Like","AttachmentS3"].contains(newObject.itemType) {
            if newObject.parent is Post {
                if let indexOfPost = self.posts.index(of: newObject.parent! as! Post) {
                    self.posts[indexOfPost].refresh()
                    self.bulletinTableView.reloadRows(at: [IndexPath(row: indexOfPost, section: 0)], with: .fade)
                }
            }
        }
        else if let newUser = newObject as? User {
            if newUser == NBClient.shared.getCurrentUser() {
                NBClient.shared.setCurrentUser(user: (newObject as! User))
                let postsForUser = self.posts.filter({ ($0.creator != nil) && ($0.creator == newUser) })
                var indexPaths = [IndexPath]()
                for post in postsForUser {
                    if let index = self.posts.index(of: post) {
                        indexPaths.append(IndexPath(row: index, section: 0))
                    }
                }
                self.bulletinTableView.reloadRows(at: indexPaths, with: .fade)
                (self.bulletinTableView.tableHeaderView as! BulletinTableViewHeader).reloadAvatar()
            }
        }
        else if ["CourseUser","GroupUser"].contains(newObject.itemType) {
            if (newObject as! Enrollment).parent!.firstTimeLoading == nil {
                ((newObject as! Enrollment).parent as! WithName).firstTimeLoaded()
            }
            if !(newObject as! Enrollment).parent!.firstTimeLoading {
                (newObject as! Enrollment).parent!.refresh()
            }
            
            else if (newObject as! Enrollment).parent!.firstTimeLoading {
                guard let tabbarVC = tabBarController as? MainTabBarViewController else { fatalError() }
                
                let loadingViewController = LoadingViewController()
                if tabbarVC.presentedViewController == nil {
                    tabbarVC.present(loadingViewController, animated: true, completion: nil)
                }
                else if tabbarVC.presentedViewController is LoadingViewController {
                    return
                }
                
                DispatchQueue.main.async {
                    NBClient.shared.storedTypes = [ObjectIdentifier: [NBModel]]()
                    NBClient.shared.resolveCurrentUser(true)
                    _ = NBClient.shared.getMappable(Setting.self)!
                    _ = NBClient.shared.getMappable(Notification.self, filters: "[\"text:IS_NULL:false\"]", limit: "110")!
                    let filter = NBClient.shared.doEnrollmentRequests()
                    let retrievedPosts = NBClient.shared.getMappable(Post.self, filters: "[\"_parent:IN:\(filter!)\"]", sortBy: "createdAt:desc", limit: "10")!
                    let postComments = NBClient.shared.requireByReferences(Comment.self, property: "_parent", values: retrievedPosts)!
                    var combinedFilter = (retrievedPosts as [NBModel])
                    combinedFilter.append(contentsOf: (postComments as [NBModel]))
                    _ = NBClient.shared.requireByReferences(Like.self, property: "_parent", values: combinedFilter)
                    _ = NBClient.shared.requireByReferences(Attachment.self, property: "_parent", values: combinedFilter)
                    NBClient.shared.reinitCache()
                    
                    let rootViews: [RootNavigationBarVC] = (tabbarVC.viewControllers as! [RootNavigationBarVC])
                    let courseVC = (rootViews[1].topViewController as! CoursesTableViewController)
                    let notifsVC = (rootViews[2].topViewController as! NotificationsTableViewController)
                    self.reloadTable()
                    courseVC.reloadTable()
                    notifsVC.reloadTable()
                    loadingViewController.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    func handleDeleted(deletedObject: NBModel) {
        if let deletePost = deletedObject as? Post {
            let indexOfPost = self.posts.index(of: deletePost)
            self.posts = NBClient.shared.storedTypes[Post.classIdentifier]! as! [Post]
            if indexOfPost != nil { self.bulletinTableView.deleteRows(at: [IndexPath(row: indexOfPost!, section: 0)], with: .right) }
            if self.bulletinTableView.numberOfRows(inSection: 0) == 0 { self.bulletinTableView.showNoResultsPlaceholder() }
        }
        
        else if ["Comment","Like","AttachmentS3"].contains(deletedObject.itemType) {
            if deletedObject.parent is Post {
                if let indexOfPost = self.posts.index(of: deletedObject.parent! as! Post) {
                    if self.navigationController?.topViewController is HomeFeedViewController || !(deletedObject is Comment) {
                        self.posts[indexOfPost].refresh()
                    }
                    self.bulletinTableView.reloadRows(at: [IndexPath(row: indexOfPost, section: 0)], with: .fade)
                }
            }
        }

        else if ["CourseUser","GroupUser"].contains(deletedObject.itemType) {
            guard let tabbarVC = tabBarController as? MainTabBarViewController else { fatalError() }
            let loadingViewController = LoadingViewController()
            
            if tabbarVC.presentedViewController == nil {
                tabbarVC.present(loadingViewController, animated: true, completion: nil)
            }
            else if tabbarVC.presentedViewController is LoadingViewController {
                return
            }
 
            DispatchQueue.main.async {
                NBClient.shared.storedTypes = [ObjectIdentifier: [NBModel]]()
                NBClient.shared.resolveCurrentUser(true)
                _ = NBClient.shared.getMappable(Setting.self)
                _ = NBClient.shared.getMappable(Notification.self, filters: "[\"text:IS_NULL:false\"]", limit: "110")
                let filter = NBClient.shared.doEnrollmentRequests()
                let retrievedPosts = NBClient.shared.getMappable(Post.self, filters: "[\"_parent:IN:\(filter!)\"]", sortBy: "createdAt:desc", limit: "10")!
                let postComments = NBClient.shared.requireByReferences(Comment.self, property: "_parent", values: retrievedPosts)!
                let combinedFilter = Array(Set((retrievedPosts as [NBModel]) + (postComments as [NBModel])))
                _ = NBClient.shared.requireByReferences(Like.self, property: "_parent", values: combinedFilter)
                _ = NBClient.shared.requireByReferences(Attachment.self, property: "_parent", values: combinedFilter)
                NBClient.shared.reinitCache()
                
                let rootViews: [RootNavigationBarVC] = (tabbarVC.viewControllers as! [RootNavigationBarVC])
                let courseVC = (rootViews[1].topViewController as! CoursesTableViewController)
                let notifsVC = (rootViews[2].topViewController as! NotificationsTableViewController)
                self.reloadTable()
                courseVC.reloadTable()
                notifsVC.reloadTable()
                loadingViewController.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func handleElapsed(elapsedObject: NBModel) { }
    func reloadTableViews() {}
}


extension HomeFeedViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts != nil ? self.posts.count : 0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if let cell = tableView.cellForRow(at: indexPath) as? HomeFeedPostCell {
            self.performSegue(withIdentifier: "postDetailSegue", sender: cell)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellHeights[indexPath] = cell.frame.size.height
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let height = cellHeights[indexPath] else { return 260.0 }
        return height
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = HomeFeedPostCell.dequeue(from: tableView)!
       
        cell.isAccessibilityElement = false
        cell.accessibilityIdentifier = String(format: "HomeFeedPostCell-%d-%d", indexPath.section, indexPath.row)
        cell.accessibilityLabel = cell.accessibilityIdentifier
        cell.contentView.isAccessibilityElement = false
        cell.contentView.accessibilityIdentifier = String(format: "PostCellContentView-%d-%d", indexPath.section, indexPath.row)
        cell.contentView.accessibilityLabel = cell.contentView.accessibilityIdentifier
        
        let post = self.posts[indexPath.row]
        cell.parentController = self
        cell.configure(post: post)
        cell.delegate = self
        cell.setCollectionView(dataSource: cell, delegate: cell, indexPath: indexPath)
        return cell
    }
}

extension HomeFeedViewController: SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        return self.cellActions(isPost: true, vc: self, tableView: tableView, indexPath: indexPath, orientation: orientation)
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        return self.cellActionOptions(isPost: true, vc: self, tableView: tableView, indexPath: indexPath, orientation: orientation)
    }
}

extension HomeFeedViewController: PlaceholderDelegate {
    func view(_ view: Any, actionButtonTappedFor placeholder: HGPlaceholders.Placeholder) {
        self.reloadTable()
    }
}

class NotebowlLogoNavigationItem: UINavigationItem {
    let logoContainer = UIView(frame: CGRect(x: 0, y: 0, width: 118, height: 44))
    private let nbLogo = UIImage(named: "nb-logo-vector-white2")!
    private let logoImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 118, height: 44))
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.image = nbLogo
        logoContainer.addSubview(logoImageView)
        self.titleView = logoContainer
    }
}

class HomeTableView: TableView {
    override func customSetup() {
        placeholdersProvider = .makePlaceholdersProvider(from: .emptyHome)
    }
}

final class DeckNoSwipeSegue: UIStoryboardSegue {
    var transition: UIViewControllerTransitioningDelegate?
    public override func perform() {
        transition = DeckTransitioningDelegate(isSwipeToDismissEnabled: false)
        destination.transitioningDelegate = transition
        destination.modalPresentationStyle = .custom
        source.present(destination, animated: true, completion: nil)
    }
}
