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
    var posts: [Post]!
    @IBOutlet var bulletinTableView: HomeTableView!
    var placeholderTableView: HomeTableView?

    var currentWorkingIndexPath: IndexPath!

    var cellHeights: [IndexPath: CGFloat] = [:]

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
        TMGradientNavigationBar().setGradientColorOnNavigationBar(bar: (navigationController?.navigationBar)!, direction: .horizontal, startColor: #colorLiteral(red: 0.04705882353, green: 0.4823529412, blue: 0.7568627451, alpha: 1), endColor: #colorLiteral(red: 0.04705882353, green: 0.5294117647, blue: 0.3607843137, alpha: 1), startPoint: CGPoint(x: 0.0, y: 0.4), endPoint: CGPoint(x: 0.8, y: 0.7))
        self.navigationController?.view.backgroundColor = UIColor.white

        setupObservers()
    }

    func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(willDeletePost(_:)), name: NSNotification.Name("ModelWillDeletePost"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(finishUpdatingPost(_:)), name: NSNotification.Name("ModelDidFinishUpdatingPost"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(finishUpdatingComment(_:)), name: NSNotification.Name("ModelDidFinishUpdatingComment"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(finishUpdatingLikesAttachments(_:)), name: NSNotification.Name("ModelDidFinishUpdatingLike"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(finishUpdatingLikesAttachments(_:)), name: NSNotification.Name("ModelDidFinishUpdatingAttachment"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(finishDeletingPost(_:)), name: NSNotification.Name("ModelDidFinishDeletingPost"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(finishDeletingComment(_:)), name: NSNotification.Name("ModelDidFinishDeletingComment"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(finishDeletingLikesAttachments(_:)), name: NSNotification.Name("ModelDidFinishDeletingLike"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(finishDeletingLikesAttachments(_:)), name: NSNotification.Name("ModelDidFinishDeletingAttachment"), object: nil)
    }

    @objc func finishUpdatingPost(_ notification: NSNotification) {
        guard let dict = notification.userInfo as NSDictionary?, let newPost = dict["object"] as? Post else {
            return
        }

        if !shouldHandleResponse(object: newPost) {
            return
        }

        if !self.posts.contains(newPost) {
            self.posts.insert(newPost, at: self.posts.startIndex)
        }

        let index = self.posts.index(of: newPost)
        
        if bulletinTableView.numberOfRows(inSection: 0) >= self.posts.count {
            bulletinTableView.reloadRows(at: [IndexPath(row: index!, section: 0)], with: .fade)
        } else {
            bulletinTableView.insertRows(at: [IndexPath(row: index!, section: 0)], with: .left)
        }
    }

    @objc func finishUpdatingComment(_ notification: NSNotification) {
        guard let dict = notification.userInfo as NSDictionary?, let newComment = dict["object"] as? Comment else {
            return
        }

        if !shouldHandleResponse(object: newComment) {
            return
        }

        guard let postIndex = self.posts.index(of: newComment.getParentByType(Post.self)) else {
            return
        }

        bulletinTableView.reloadRows(at: [IndexPath(row: postIndex, section: 0)], with: .fade)
    }

    @objc func finishUpdatingLikesAttachments(_ notification: NSNotification) {
        guard let dict = notification.userInfo as NSDictionary?, let newObject = dict["object"] as? NBModel else {
            return
        }

        if !shouldHandleResponse(object: newObject) {
            return
        }

        guard newObject.parent is Post, let postIndex = self.posts.index(of: newObject.parent as! Post) else {
            return
        }

        bulletinTableView.reloadRows(at: [IndexPath(row: postIndex, section: 0)], with: .fade)
    }

    @objc func willDeletePost(_ notification: NSNotification) {
        guard let dict = notification.userInfo as NSDictionary?, let deletingPost = dict["object"] as? Post else {
            return
        }
        if !shouldHandleResponse(object: deletingPost) {
            return
        }

        guard let index = self.posts.index(of: deletingPost) else {
            return
        }

        currentWorkingIndexPath = IndexPath(row: index, section: 0)
    }

    @objc func finishDeletingPost(_ notification: NSNotification) {
        guard let dict = notification.userInfo as NSDictionary?, let deletedPost = dict["object"] as? Post else {
            return
        }
        if !shouldHandleResponse(object: deletedPost) {
            return
        }

        if let index = currentWorkingIndexPath, !self.posts.contains(deletedPost) {
            bulletinTableView.deleteRows(at: [index], with: .automatic)
        }
        currentWorkingIndexPath = nil
    }

    @objc func finishDeletingComment(_ notification: NSNotification) {
        guard let dict = notification.userInfo as NSDictionary?, let newComment = dict["object"] as? Comment else {
            return
        }

        if !shouldHandleResponse(object: newComment) {
            return
        }

        guard let postIndex = self.posts.index(of: newComment.getParentByType(Post.self)) else {
            return
        }

        bulletinTableView.reloadRows(at: [IndexPath(row: postIndex, section: 0)], with: .fade)
    }

    @objc func finishDeletingLikesAttachments(_ notification: NSNotification) {
        guard let dict = notification.userInfo as NSDictionary?, let newObject = dict["object"] as? NBModel else {
            return
        }

        if !shouldHandleResponse(object: newObject) {
            return
        }

        guard newObject.parent is Post, let postIndex = self.posts.index(of: newObject.parent as! Post) else {
            return
        }

        bulletinTableView.reloadRows(at: [IndexPath(row: postIndex, section: 0)], with: .fade)
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
        _ = self.bulletinTableView.indexPathForSelectedRow
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    func afterFullyLoaded() {
        UIApplication.shared.registerForRemoteNotifications()
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
            if granted {
                log.debug("Notification Enabled Successfully")
            } else if error != nil {
                log.error("Some Error Occured, \(error!.localizedDescription)")
            }
        }
        NBSocket.shared.setup()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "postDetailSegue" {
            let destVC = segue.destination as! HomeFeedPostViewController
            if let sourceCell = sender as? HomeFeedPostCell {
                destVC.displayedPost = sourceCell.postForCell
            }
        } else if segue.identifier == "createPostSegue" {
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
    func shouldHandleResponse(object: NBModel) -> Bool {
        if let postParent = object.getParentByType(Post.self, withSelf: true) {
            if (postParent.parent is Assignment) || (postParent.parent is Submission) {
                return false
            }
        }
        return true
    }

    func handleUpdated(newObject: NBModel) {
        if !shouldHandleResponse(object: newObject) {
            return
        }

        if let newEnrollment = newObject as? Enrollment {
            handleUpdatedEnrollment(newEnrollment: newEnrollment)
        }
    }

    func handleUpdatedEnrollment(newEnrollment: Enrollment) {
        if newEnrollment.parent!.firstTimeLoading == nil {
            (newEnrollment.parent as! WithName).firstTimeLoaded()
        }
        if !newEnrollment.parent!.firstTimeLoading {
            newEnrollment.parent!.refresh()
        } else if newEnrollment.parent!.firstTimeLoading {
            guard let tabbarVC = tabBarController as? MainTabBarViewController else { fatalError() }

            let loadingViewController = LoadingViewController()
            if tabbarVC.presentedViewController == nil {
                tabbarVC.present(loadingViewController, animated: true, completion: nil)
            } else if tabbarVC.presentedViewController is LoadingViewController {
                return
            }

            DispatchQueue.main.async {
                NBClient.shared.storedTypes = [ObjectIdentifier: [NBModel]]()
                NBClient.shared.resolveCurrentUser(true)
                _ = NBClient.shared.getMappable(Setting.self)!
                _ = NBClient.shared.getMappable(Notification.self, filters: "[\"text:IS_NULL:false\"]", sortBy: "createdAt:desc")!
                let filter = NBClient.shared.doEnrollmentRequests()
                let retrievedPosts = NBClient.shared.getMappable(Post.self, filters: "[\"_parent:IN:\(filter)\"]", sortBy: "createdAt:desc", limit: "10")!
                let postComments = NBClient.shared.requireByReferences(Comment.self, property: "_parent", values: retrievedPosts)
                let threadedComments = NBClient.shared.requireByReferences(Comment.self, property: "_parent", values: postComments)
                var combinedFilter = (retrievedPosts as [NBModel])
                combinedFilter.append(contentsOf: (postComments as [NBModel]))
                combinedFilter.append(contentsOf: (threadedComments as [NBModel]))
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

    func handleDeletedEnrollment(deletedEnrollment: Enrollment) {
        guard let tabbarVC = tabBarController as? MainTabBarViewController else { fatalError() }
        let loadingViewController = LoadingViewController()

        if tabbarVC.presentedViewController == nil {
            tabbarVC.present(loadingViewController, animated: true, completion: nil)
        } else if tabbarVC.presentedViewController is LoadingViewController {
            return
        }

        DispatchQueue.main.async {
            NBClient.shared.storedTypes = [ObjectIdentifier: [NBModel]]()
            NBClient.shared.resolveCurrentUser(true)
            _ = NBClient.shared.getMappable(Setting.self)
            _ = NBClient.shared.getMappable(Notification.self, filters: "[\"text:IS_NULL:false\"]", sortBy: "createdAt:desc")!
            let filter = NBClient.shared.doEnrollmentRequests()
            let retrievedPosts = NBClient.shared.getMappable(Post.self, filters: "[\"_parent:IN:\(filter)\"]", sortBy: "createdAt:desc", limit: "10")!
            let postComments = NBClient.shared.requireByReferences(Comment.self, property: "_parent", values: retrievedPosts)
            let threadedComments = NBClient.shared.requireByReferences(Comment.self, property: "_parent", values: postComments)
            var combinedFilter = (retrievedPosts as [NBModel])
            combinedFilter.append(contentsOf: (postComments as [NBModel]))
            combinedFilter.append(contentsOf: (threadedComments as [NBModel]))
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

    func handleDeleted(deletedObject: NBModel) { }
    func handleElapsed(elapsedObject: NBModel) { }
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
