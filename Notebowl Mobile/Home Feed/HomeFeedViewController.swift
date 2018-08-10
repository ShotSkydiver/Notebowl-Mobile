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

class HomeFeedViewController: UIViewController, UpdateVC {
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
        
        setupNavBar()
        TMGradientNavigationBar().setGradientColorOnNavigationBar(bar: (navigationController?.navigationBar)!, direction: .horizontal, startColor: #colorLiteral(red: 0.04705882353, green: 0.4823529412, blue: 0.7568627451, alpha: 1), endColor: #colorLiteral(red: 0.04705882353, green: 0.5294117647, blue: 0.3607843137, alpha: 1))
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
 
    func setupNavBar() {
        navigationController?.navigationBar.shadowImage = UIImage.init()
        navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
        navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        navigationController?.navigationBar.layer.shadowRadius = 7.5
        navigationController?.navigationBar.layer.shadowOpacity = 0.7
        navigationController?.navigationBar.layer.masksToBounds = false
        self.view.layer.masksToBounds = false
    }
    
    @IBAction func userProfileButton(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "segueDeck", sender: nil)
    }
    
    func reloadTable() {
        self.posts = (NBClient.shared.storedTypes.has(key: Post.classIdentifier) ? NBClient.shared.storedTypes[Post.classIdentifier]! as! [Post] : [])
        bulletinTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        TTLog.testing("homeVC willappear")
        self.setNeedsStatusBarAppearanceUpdate()
        self.navigationController?.navigationBar.tintColor = UIColor.groupTableViewBackground
        let selectedRowIndexPath = self.bulletinTableView.indexPathForSelectedRow
        super.viewWillAppear(animated)
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
            if let senderCell = sender as? HomeFeedPostCell {
                destVC.editingExistingPost = true
                destVC.existingPostToEdit = senderCell.postForCell
                destVC.existingCell = senderCell
            }
        }
    }
}

extension HomeFeedViewController {
    func handleUpdated(newObject: NBModel) {
        if newObject.itemType == "Post" {
            self.posts = NBClient.shared.storedTypes[Post.classIdentifier]! as! [Post]
            let indexOfPost = self.posts.index(where: { $0.resourceKey == newObject.resourceKey })
            let existingPost = bulletinTableView.numberOfRows(inSection: 0) < self.posts.count ? false : true
            
            if self.bulletinTableView.cellForRow(at: IndexPath(row: 0, section: 0)) is PlaceholderTableViewCell {
                self.bulletinTableView.showDefault()
            }
            else if existingPost == false {
                self.bulletinTableView.insertRows(at: [IndexPath(row: indexOfPost!, section: 0)], with: .left)
            }
            else {
                self.posts.first(where: { $0.resourceKey == newObject.resourceKey })!.refresh()
                self.bulletinTableView.reloadRows(at: [IndexPath(row: indexOfPost!, section: 0)], with: .fade)
            }
        }
        else if ["Comment","Like","AttachmentS3"].contains(newObject.itemType) {
            if let parentPost = self.posts.first(where: { $0.resourceKey == newObject.parent!.resourceKey }) {
                let indexOfPost = self.posts.index(where: { $0.resourceKey == parentPost.resourceKey })
                parentPost.refresh()
                if indexOfPost != nil  { self.bulletinTableView.reloadRows(at: [IndexPath(row: indexOfPost!, section: 0)], with: .fade)}
            }
        }
        else if newObject.itemType == "User" {
            if newObject.resourceKey == NBClient.shared.getCurrentUser().resourceKey {
                NBClient.shared.setCurrentUser(user: (newObject as! User))
                
                let postsForUser = self.posts.filter({ ($0.creator != nil) && ($0.creator?.resourceKey == newObject.resourceKey) })
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
            if (newObject as! Enrollment).parent!.firstTimeLoading == nil { (newObject as! Enrollment).parent!.refresh() }
            if !(newObject as! Enrollment).parent!.firstTimeLoading { (newObject as! Enrollment).parent!.refresh() }
            
            else if (newObject as! Enrollment).parent!.firstTimeLoading {
                guard let tabbarVC = tabBarController as? MainTabBarViewController else { fatalError() }
                tabbarVC.present(tabbarVC.loadingVC, animated: true, completion: nil)
                DispatchQueue.main.async {
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
                    tabbarVC.loadingVC.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    func handleDeleted(deletedObject: NBModel) {
        if deletedObject.itemType == "Post" {
            let indexOfPost = self.posts.index(where: { $0.resourceKey == deletedObject.resourceKey })
            self.posts = NBClient.shared.storedTypes[Post.classIdentifier]! as! [Post]
            
            if indexOfPost != nil {
                self.bulletinTableView.deleteRows(at: [IndexPath(row: indexOfPost!, section: 0)], with: .right)
            }
            if self.bulletinTableView.numberOfRows(inSection: 0) == 0 {
                self.bulletinTableView.showNoResultsPlaceholder()
            }
        }
        
        else if ["Comment","Like","AttachmentS3"].contains(deletedObject.itemType) {
            if let parentPost = self.posts.first(where: { $0.resourceKey == deletedObject.parent!.resourceKey }) {
                if self.navigationController?.topViewController is HomeFeedViewController {
                    let indexOfPost = self.posts.index(where: { $0.resourceKey == parentPost.resourceKey })
                    parentPost.refresh()
                    if indexOfPost != nil {
                        TTLog.socket("we're on homefeedview")
                        self.bulletinTableView.reloadRows(at: [IndexPath(row: indexOfPost!, section: 0)], with: .fade)
                    }
                }
            }
        }

        else if ["CourseUser","GroupUser"].contains(deletedObject.itemType) {
            guard let tabbarVC = tabBarController as? MainTabBarViewController else { fatalError() }
            tabbarVC.present(tabbarVC.loadingVC, animated: true, completion: nil)
            DispatchQueue.main.async {
                NBClient.shared.storedTypes = [ObjectIdentifier: [NBModel]]()
                NBClient.shared.resolveCurrentUser(true)
                _ = NBClient.shared.getMappable(Setting.self)!
                _ = NBClient.shared.getMappable(Notification.self, filters: "[\"text:IS_NULL:false\"]", limit: "110")!
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
                tabbarVC.loadingVC.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func handleElapsed(elapsedObject: NBModel) {
        if elapsedObject.itemType == "User" {
            TTLog.debug("user elapsed")
        }
    }
    
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
        guard orientation == .right else { return nil }
        let selectedCell = tableView.cellForRow(at: indexPath) as! HomeFeedPostCell
        let edit = SwipeAction(style: .default, title: "Edit") { (action, indexPath) in
            self.performSegue(withIdentifier: "createPostSegue", sender: selectedCell)
        }
        edit.image = UIImage(named: "edit-vector")!.filled(withColor: .groupTableViewBackground).withRenderingMode(.alwaysOriginal)
        edit.textColor = .groupTableViewBackground
        edit.backgroundColor = #colorLiteral(red: 0.04705882353, green: 0.4823529412, blue: 0.7568627451, alpha: 1)
        edit.hidesWhenSelected = true
        edit.fulfill(with: .reset)
        
        let delete = SwipeAction(style: .destructive, title: "Delete") { (action, indexPath) in
            self.posts.remove(at: indexPath.row)
            action.fulfill(with: .delete)
            let deleteReq = NBNetworking.shared.request(.delete, url: selectedCell.postForCell.url.absoluteString)
            let keyPath = (deleteReq.json as AnyObject).value(forKeyPath: "result")! as! [String : AnyObject]
            let data: Any = ["itemType":"\(ItemType.fromURL((keyPath["url"] as! String)))", "updateUrl":"\((keyPath["url"] as! String))", "action":"deleted", "updatedAt":"\((keyPath["updatedAt"] as! String))"]
            let JSON = try? JSONSerialization.data(withJSONObject: data, options: [])
            let JSONString = String(data: JSON!, encoding: String.Encoding.utf8)
            NBSocket.shared.updateHandler(message: JSONString!)
        }
        delete.image = UIImage(named: "trash-vector")!.filled(withColor: .groupTableViewBackground).withRenderingMode(.alwaysOriginal)
        delete.textColor = .groupTableViewBackground
        delete.backgroundColor = #colorLiteral(red: 1, green: 0.2352941176, blue: 0.1882352941, alpha: 1)
        
        let report = SwipeAction(style: .default, title: "Report") { (action, indexPath) in
            let alert = UIAlertController(title: "Report Post", message: "What's wrong with this post?", preferredStyle: .actionSheet)
            let inappropriate = UIAlertAction(title: "It doesn't belong on Notebowl", style: .default, handler: { inappAction in
                let payload: Any? = ["reason": "inappropriate", "_parent": "\(selectedCell.postForCell.url.absoluteString)"]
                _ = NBNetworking.shared.request(.post, url: Abuse.endpoint, json: payload)
                alert.dismiss(animated: true, completion: nil)
                PKHUD.sharedHUD.contentView = PKHUDSuccessView(title: "Report Sent", subtitle: nil)
                PKHUD.sharedHUD.show()
                PKHUD.sharedHUD.hide(afterDelay: 2.0)
            })
            let spam = UIAlertAction(title: "It's spam", style: .default, handler: { spamAction in
                let payload: Any? = ["reason": "spam", "_parent": "\(selectedCell.postForCell.url.absoluteString)"]
                _ = NBNetworking.shared.request(.post, url: Abuse.endpoint, json: payload)
                alert.dismiss(animated: true, completion: nil)
                PKHUD.sharedHUD.contentView = PKHUDSuccessView(title: "Report Sent", subtitle: nil)
                PKHUD.sharedHUD.show()
                PKHUD.sharedHUD.hide(afterDelay: 2.0)
            })
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(inappropriate)
            alert.addAction(spam)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
        }
        report.image = UIImage(named: "report-vector")!.filled(withColor: .groupTableViewBackground).withRenderingMode(.alwaysOriginal)
        report.textColor = .groupTableViewBackground
        report.backgroundColor = #colorLiteral(red: 1, green: 0.5803921569, blue: 0, alpha: 1)
        report.hidesWhenSelected = true
        
        if (selectedCell.postForCell.creator != nil) && (selectedCell.postForCell.creator!.resourceKey == NBClient.shared.getCurrentUser().resourceKey) {
            return [delete, edit]
        }
        else if (selectedCell.postForCell.owner!.enrollmentForUser?.role == .professor) || (selectedCell.postForCell.owner!.enrollmentForUser?.role == .admin) {
            return [delete, report]
        }
        else {
            return [report]
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        let selectedCell = tableView.cellForRow(at: indexPath) as! HomeFeedPostCell
        if (selectedCell.postForCell.creator != nil) {
            if (selectedCell.postForCell.creator!.resourceKey == NBClient.shared.getCurrentUser().resourceKey) || (selectedCell.postForCell.owner!.enrollmentForUser?.role == .professor) || (selectedCell.postForCell.owner!.enrollmentForUser?.role == .admin) {
                options.expansionStyle = SwipeExpansionStyle.destructive(automaticallyDelete: false)
            }
        }
        else {
            options.expansionStyle = SwipeExpansionStyle.fill
        }
        options.transitionStyle = SwipeTransitionStyle.border
        options.buttonSpacing = 11
        return options
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
