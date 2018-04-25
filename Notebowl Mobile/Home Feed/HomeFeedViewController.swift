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
import Newly

class HomeFeedViewController: UIViewController, PlaceholderDelegate {
    var posts: [Post]!
    var courses: [Course]!
    var loadingView: NBLoadingView!
    var bgView: UIView!
    var profileImage: UIImage!
    var newly = Newly()
    
    var viewIsLoaded = false
    var needsUpdate = false
    
    @IBOutlet var bulletinTableView: HomeTableView!
    
    var placeholderTableView: TableView?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()
        
        profileImage = NBClient.shared.currentUserPic
        newly.delegate = self
        
        HomeFeedWritePostCell.register(in: bulletinTableView)
        HomeFeedPostCell.register(in: bulletinTableView)
        
        self.tempLoadingViewSetup()
        placeholderTableView = bulletinTableView
        placeholderTableView?.placeholderDelegate = self
        
        registerSocketHandler()
        setupNavBar()
        TMGradientNavigationBar().setGradientColorOnNavigationBar(bar: (navigationController?.navigationBar)!, direction: .horizontal, startColor: #colorLiteral(red: 0.2310000062, green: 0.6510000229, blue: 0.8859999776, alpha: 1), endColor: #colorLiteral(red: 0.3249999881, green: 0.7139999866, blue: 0.4350000024, alpha: 1))
        //self.automaticallyAdjustsScrollViewInsets = false
        bulletinTableView.contentInset = UIEdgeInsetsMake(-36, 0, 0, 0)
        self.getPosts()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TTLog.info("viewdidappear")
        if self.needsUpdate {
            self.getPosts()
            self.needsUpdate = false
        }
    }
   
    func tempLoadingViewSetup() {
        self.loadingView = NBLoadingView()
        self.bgView = UIView(loadingView: self.loadingView)
        self.view.addSubview(bgView)
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
        // TTLog.warning("socket connection: ", NBSocket.shared.socketManager.status)
        
        self.performSegue(withIdentifier: "segueDeck", sender: nil)
    }
    
    
    func view(_ view: Any, actionButtonTappedFor placeholder: HGPlaceholders.Placeholder) {
        placeholderTableView?.showDefault()
        
        self.getPosts()
    }
    
    func loadOtherTabs() {
        if let viewControllers = tabBarController?.viewControllers {
            for viewController in viewControllers {
                let rootNavController = viewController as! UINavigationController
                
                if rootNavController.topViewController is CoursesTableViewController {
                    TTLog.info("loading courses tab!")
                    let coursesVC = rootNavController.topViewController as! CoursesTableViewController
                    coursesVC.courses = self.courses
                    let _ = coursesVC.view
                }
                else if rootNavController.topViewController is NotificationsTableViewController {
                    TTLog.info("loading notifications tab!")
                    let notifsVC = rootNavController.topViewController as! NotificationsTableViewController
                    notifsVC.notifications = NBClient.shared.storedTypes[Notification.classIdentifier]! as! [Notification]
                    let _ = notifsVC.view
                }
                // let _ = viewController.view
            }
        }
    }
    
    func getPosts() {
        if (self.tabBarController?.tabBar.selectedItem == self.tabBarController?.tabBar.items![0]) && (self.navigationController?.topViewController is HomeFeedViewController) {
            TTLog.debug("home feedview is showing!")
            // self.loadingView.showLoadView(true)
            // self.bgView.showViewAnimated(true)
        }
        self.loadingView.showLoadView(true)
        self.bgView.showViewAnimated(true)
        
        // NBClient.shared.queue.async {
        // DispatchQueue.global(qos: .background).async {
        DispatchQueue.main.async {
            TTLog.error("async homefeed update begin")
            
            
            if (self.courses == nil) || (self.courses.isEmpty) {
                
                let enrollments = NBClient.shared.getMappable(Enrollment.self, filters: "[\"_parent:TYPE:Course\",\"_user:IN:\(NBClient.shared.getCurrentUser().url.absoluteString)\"]", limit: "100")!
                if NBClient.shared.storedTypes[Enrollment.classIdentifier] == nil {
                    NBClient.shared.storedTypes[Enrollment.classIdentifier] = enrollments
                }
                else {
                    for enrollment in enrollments {
                        if NBClient.shared.storedTypes[Enrollment.classIdentifier]!.first(where: {$0.resourceKey == enrollment.resourceKey}) == nil {
                            NBClient.shared.storedTypes[Enrollment.classIdentifier]!.append(enrollment)
                        }
                    }
                }
                var resourceKeys: String = ""

                for enrollment in enrollments {
                    if enrollment.statusIsAccepted {
                        resourceKeys = (resourceKeys + enrollment.parent!.absoluteURL.lastPathComponent + ",")
                    }
                }
                
                self.courses = NBClient.shared.initArray(from: NBClient.shared.getMappable(Course.self, filters: "[\"resourceKey:IN:\(resourceKeys)\"]", limit: "100")!)
                
                if NBClient.shared.storedTypes[Course.classIdentifier] == nil {
                    NBClient.shared.storedTypes[Course.classIdentifier] = self.courses
                }
                else {
                    for course in self.courses {
                        if NBClient.shared.storedTypes[Course.classIdentifier]!.first(where: {$0.resourceKey == course.resourceKey}) == nil {
                            NBClient.shared.storedTypes[Course.classIdentifier]!.append(course)
                        }
                    }
                }
            }

            self.posts = NBClient.shared.getMappable(Post.self, filters: "[\"_owner:TYPE:Course\",\"_parent:TYPE:Course\"]", sortBy: "updatedAt:desc", limit: "10")
            if NBClient.shared.storedTypes[Post.classIdentifier] == nil {
                NBClient.shared.storedTypes[Post.classIdentifier] = self.posts
            }
            else {
                for post in self.posts {
                    if NBClient.shared.storedTypes[Post.classIdentifier]!.first(where: {$0.resourceKey == post.resourceKey}) == nil {
                        NBClient.shared.storedTypes[Post.classIdentifier]!.append(post)
                    }
                }
            }
            
            var comments: [Comment]! = NBClient.shared.getMappable(Comment.self, filters: "[\"_parent:IN:\(NBClient.shared.buildFilterString(from: self.posts))\"]")!
            
            let filterString = (NBClient.shared.buildFilterString(from: self.posts) + (NBClient.shared.buildFilterString(from: comments)))
            
            
            if NBClient.shared.storedTypes[Comment.classIdentifier] == nil {
                NBClient.shared.storedTypes[Comment.classIdentifier] = comments
            }
            else {
                for comment in comments {
                    if NBClient.shared.storedTypes[Comment.classIdentifier]!.first(where: {$0.resourceKey == comment.resourceKey}) == nil {
                        print("comment doesn't exist!")
                        NBClient.shared.storedTypes[Comment.classIdentifier]!.append(comment)
                    }
                }
            }
            
            
            let likes = NBClient.shared.getMappable(Like.self, filters: "[\"_parent:IN:\(filterString)\"]")!
            if NBClient.shared.storedTypes[Like.classIdentifier] == nil {
                NBClient.shared.storedTypes[Like.classIdentifier] = likes
            }
            else {
                for like in likes {
                    if NBClient.shared.storedTypes[Like.classIdentifier]!.first(where: {$0.resourceKey == like.resourceKey}) == nil {
                        NBClient.shared.storedTypes[Like.classIdentifier]!.append(like)
                    }
                }
            }
            
            
            let attachments = NBClient.shared.getMappable(Attachment.self, filters: "[\"_parent:IN:\(filterString)\"]")!
            
            if NBClient.shared.storedTypes[Attachment.classIdentifier] == nil {
                NBClient.shared.storedTypes[Attachment.classIdentifier] = attachments
            }
            else {
                for attachment in attachments {
                    if NBClient.shared.storedTypes[Attachment.classIdentifier]!.first(where: {$0.resourceKey == attachment.resourceKey}) == nil {
                        NBClient.shared.storedTypes[Attachment.classIdentifier]!.append(attachment)
                    }
                }
            }
            
            self.posts = NBClient.shared.initArray(from: self.posts)
            
            self.bulletinTableView.reloadData()
           
            if !self.viewIsLoaded {
                self.viewIsLoaded = true
            }
            
            self.loadOtherTabs()
            
            TTLog.error("async homefeed update end")
            // if (self.tabBarController?.tabBar.selectedItem == self.tabBarController?.tabBar.items![0]) && (self.navigationController?.topViewController is HomeFeedViewController) {
            // DispatchQueue.main.async {
                self.bgView.showViewAnimated(false)
            // }
            // }
        
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let selectedRowIndexPath = self.bulletinTableView.indexPathForSelectedRow
        super.viewWillAppear(animated)
        
        if selectedRowIndexPath != nil {
            TTLog.debug("reloading")
            self.bulletinTableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let senderCell = sender as? HomeFeedPostCell {
            let indexPath = self.bulletinTableView.indexPath(for: senderCell)!
            let destVC = segue.destination as! HomeFeedPostViewController
            destVC.currentIndex = indexPath
            destVC.post = self.posts[indexPath.row]
        }
        else if segue.identifier == "createPostSegue" {
            let destVC = segue.destination as! CreateNewPostViewController
            destVC.currentAvatar = self.profileImage
            destVC.coursesForPicker = self.courses
        }
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        self.performSegue(withIdentifier: "segueDeck", sender: nil)
    }
    
    
    func registerSocketHandler() {
        
        NBSocket.shared.socket.on(NBClient.shared.getCurrentUser().resourceKey) { (data, ackEmitter) in
            TTLog.info("socket: on response: ", data)
            guard let message = data[0] as? String else { return }
            if let data = message.data(using: .utf8) {
                do {
                    let JSON = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String : AnyObject]
                    TTLog.warning("socket: mapping response")
                    let mapped = Mapper<Generic>().map(JSON: JSON)!
                    TTLog.warning("socket: mapped! ", mapped)
                    
                    if (mapped.itemType?.contains("Notification"))! {
                        let mappedNotif = mapped as! Response<Notification>
                        
                        let notifVC = (self.tabBarController?.viewControllers![2] as! UINavigationController).topViewController as! NotificationsTableViewController
                        
                        let indexOfNotification = notifVC.notifications.index(of: mappedNotif.updateUrl!)
                        var sorting = NBClient.shared.storedTypes[Notification.classIdentifier] as! [Notification]
                        sorting.sort() { $0.secondsSinceUpdate > $1.secondsSinceUpdate }
                        NBClient.shared.storedTypes[Notification.classIdentifier] = sorting
                        notifVC.notifications = NBClient.shared.storedTypes[Notification.classIdentifier] as! [Notification]
                        
                        // TODO: GENERALIZE THIS PART
                        if mappedNotif.actionType == .updated {
                            if indexOfNotification == nil {
                                if #available(iOS 11.0, *) {
                                    notifVC.tableView.performBatchUpdates({
                                        notifVC.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .top)
                                    }, completion: { (_) in
                                        TTLog.debug("updates complete")
                                    })
                                }
                                else {
                                    notifVC.tableView.beginUpdates()
                                    notifVC.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .top)
                                    notifVC.tableView.endUpdates()
                                }
                            }
                        }
                        else if mappedNotif.actionType == .deleted {
                            if indexOfNotification != nil {
                                if #available(iOS 11.0, *) {
                                    notifVC.tableView.performBatchUpdates({
                                        notifVC.tableView.deleteRows(at: [IndexPath(row: indexOfNotification!, section: 0)], with: .fade)
                                    }, completion: { (_) in
                                        TTLog.debug("deletes complete")
                                    })
                                }
                                else {
                                    notifVC.tableView.beginUpdates()
                                    notifVC.tableView.deleteRows(at: [IndexPath(row: indexOfNotification!, section: 0)], with: .fade)
                                    notifVC.tableView.endUpdates()
                                }
                            }
                        }
                        
                        let unreadCount = (NBClient.shared.storedTypes[Notification.classIdentifier]! as! [Notification]).filter({ $0.statusBool == false })
                        DispatchQueue.main.async {
                            
                            self.tabBarController?.tabBar.items![2].badgeValue = String(format: "%d", unreadCount.count)
                        }
                    }
                    
                    else {
                        TTLog.info("something else!")
                        // if self.tabBarController?.tabBar.selectedItem == self.tabBarController?.tabBar.items![0] {
                            
                            if (mapped.itemType?.contains("Post"))! {
                                let mappedPost = mapped as! Response<Post>
                                let indexOfPost = self.posts.index(of: mappedPost.updateUrl!)
                                
                                var sorting = NBClient.shared.storedTypes[Post.classIdentifier] as! [Post]
                                sorting.sort() { $0.secondsSinceUpdate > $1.secondsSinceUpdate }
                                NBClient.shared.storedTypes[Post.classIdentifier] = sorting
                                self.posts = NBClient.shared.storedTypes[Post.classIdentifier] as! [Post]

                                if mappedPost.actionType == .updated {
                                    if #available(iOS 11.0, *) {
                                        self.bulletinTableView.performBatchUpdates({
                                            self.bulletinTableView.insertRows(at: [IndexPath(row: 0, section: 1)], with: .top)
                                        }, completion: { (_) in
                                            TTLog.debug("updates complete")
                                        })
                                    }
                                    else {
                                        self.bulletinTableView.beginUpdates()
                                        self.bulletinTableView.insertRows(at: [IndexPath(row: 0, section: 1)], with: .top)
                                        self.bulletinTableView.endUpdates()
                                    }
                                }
                                else if mappedPost.actionType == .deleted {
                                    if let postVC = self.navigationController?.topViewController as? HomeFeedPostViewController {
                                        if mappedPost.updateUrl!.resourceKey == postVC.post.resourceKey {
                                            self.navigationController?.popViewController(animated: true)
                                        }
                                    }
                                    if indexOfPost != nil {
                                        if #available(iOS 11.0, *) {
                                            self.bulletinTableView.performBatchUpdates({
                                                self.bulletinTableView.deleteRows(at: [IndexPath(row: indexOfPost!, section: 1)], with: .fade)
                                            }, completion: { (_) in
                                                TTLog.debug("deletes complete")
                                            })
                                        }
                                        else {
                                            self.bulletinTableView.beginUpdates()
                                            self.bulletinTableView.deleteRows(at: [IndexPath(row: indexOfPost!, section: 1)], with: .fade)
                                            self.bulletinTableView.endUpdates()
                                        }
                                    }
                                }
                            }
                            else if (mapped.itemType?.contains("Comment"))! {
                                let mappedComment = mapped as! Response<Comment>
                                guard let parentPost = self.posts.first(where: { $0.resourceKey == mappedComment.updateUrl!.parent.absoluteURL.lastPathComponent }) else {
                                    TTLog.debug("couldn't find parent post in posts!")
                                    return
                                }
                                let indexOfPost = self.posts.index(of: parentPost)
                                
                                parentPost.refresh()
                                
                                if let postVC = self.navigationController?.topViewController as? HomeFeedPostViewController {
                                    if parentPost.resourceKey == postVC.post.resourceKey {
                                        let indexOfComment = postVC.comments.index(of: mappedComment.updateUrl!)
                                        postVC.comments = postVC.post.postComments
                                        
                                        postVC.tableView.beginUpdates()
                                        postVC.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
                                        if mappedComment.actionType == .deleted {
                                            postVC.tableView.deleteRows(at: [IndexPath(row: indexOfComment!, section: 1)], with: .bottom)
                                        }
                                        else {
                                            postVC.tableView.insertRows(at: [IndexPath(row: postVC.comments.count-1, section: 1)], with: .bottom)
                                        }
                                        
                                        postVC.tableView.endUpdates()
                                    }
                                }
                                
                                if indexOfPost != nil {
                                    if #available(iOS 11.0, *) {
                                        self.bulletinTableView.performBatchUpdates({
                                            self.bulletinTableView.reloadRows(at: [IndexPath(row: indexOfPost!, section: 1)], with: .fade)
                                        }, completion: { (_) in
                                            TTLog.debug("updates complete")
                                        })
                                    }
                                    else {
                                        self.bulletinTableView.beginUpdates()
                                        self.bulletinTableView.reloadRows(at: [IndexPath(row: indexOfPost!, section: 1)], with: .fade)
                                        self.bulletinTableView.endUpdates()
                                    }
                                }
                            }
                            else if (mapped.itemType?.contains("Like"))! {
                                let mappedLike = mapped as! Response<Like>
                                var indexOfPost: Int?
                                
                                if let parentPost = self.posts.first(where: { $0.resourceKey == mappedLike.updateUrl!.parent.absoluteURL.lastPathComponent }) {
                                    TTLog.debug("found parent post in posts!")
                                    
                                    indexOfPost = self.posts.index(of: parentPost)
                                    parentPost.updateLikes()
                                    
                                    if let postVC = self.navigationController?.topViewController as? HomeFeedPostViewController {
                                        if parentPost.resourceKey == postVC.post.resourceKey {
                                            postVC.tableView.beginUpdates()
                                            postVC.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
                                            postVC.tableView.endUpdates()
                                        }
                                    }
                                }
                                else if let parentComment = NBClient.shared.storedTypes[Comment.classIdentifier]!.first(where: { $0.resourceKey == mappedLike.updateUrl!.parent.absoluteURL.lastPathComponent }) {
                                    TTLog.debug("found parent comment in posts!")
                                    /*
                                    guard let parentPost = self.posts.first(where: { $0.resourceKey == (parentComment as! Comment).parent.absoluteURL.lastPathComponent }) else {
                                        return
                                    }
                                    indexOfPost = self.posts.index(of: parentPost)
                                    */
                                    
                                    (parentComment as! Comment).updateLikes()
                                    
                                    if let postVC = self.navigationController?.topViewController as? HomeFeedPostViewController {
                                        if let theComment = postVC.comments.first(where: { $0.resourceKey == parentComment.resourceKey}) {
                                            postVC.tableView.beginUpdates()
                                            postVC.tableView.reloadRows(at: [IndexPath(row: postVC.comments.index(of: theComment)!, section: 1)], with: .fade)
                                            postVC.tableView.endUpdates()
                                        }
                                    }
                                }
                                
                                if indexOfPost != nil {
                                    if #available(iOS 11.0, *) {
                                        self.bulletinTableView.performBatchUpdates({
                                            self.bulletinTableView.reloadRows(at: [IndexPath(row: indexOfPost!, section: 1)], with: .fade)
                                        }, completion: nil)
                                    }
                                    else {
                                        self.bulletinTableView.beginUpdates()
                                        self.bulletinTableView.reloadRows(at: [IndexPath(row: indexOfPost!, section: 1)], with: .fade)
                                        self.bulletinTableView.endUpdates()
                                    }
                                }
                            }
                            else if (mapped.itemType?.contains("CourseUser"))! {
                                // WORK IN PROGRESS
                                
                                let mappedEnrollment = mapped as! Response<Enrollment>
                                // let indexOfPost = self.posts.index(of: mappedPost.updateUrl!)
                                
                                /*
                                self.courses = NBClient.shared.storedTypes[Course.classIdentifier] as! [Course]
                                
                                if self.navigationController?.topViewController is HomeFeedPostViewController {
                                    TTLog.info("feed post VC is visible!")
                                    self.needsUpdate = true
                                    self.navigationController?.popViewController(animated: true)
                                }
                                else if self.navigationController?.topViewController is HomeFeedViewController {
                                    TTLog.info("home feed is visible!")
                                    self.getPosts()
                                }
                                else {
                                    // self.tabBarController?.tabBar.items![0
                                    self.getPosts()
                                }
                                */
                                
                                /*
                                var sorting = NBClient.shared.storedTypes[Post.classIdentifier] as! [Post]
                                sorting.sort() { $0.secondsSinceUpdate > $1.secondsSinceUpdate }
                                NBClient.shared.storedTypes[Post.classIdentifier] = sorting
                                self.posts = NBClient.shared.storedTypes[Post.classIdentifier] as! [Post]
                                
                                if mappedEnrollment.actionType == .updated {
                                    if #available(iOS 11.0, *) {
                                        self.bulletinTableView.performBatchUpdates({
                                            self.bulletinTableView.insertRows(at: [IndexPath(row: 0, section: 1)], with: .top)
                                        }, completion: { (_) in
                                            TTLog.debug("updates complete")
                                        })
                                    }
                                    else {
                                        self.bulletinTableView.beginUpdates()
                                        self.bulletinTableView.insertRows(at: [IndexPath(row: 0, section: 1)], with: .top)
                                        self.bulletinTableView.endUpdates()
                                    }
                                }
                                else if mappedEnrollment.actionType == .deleted {
                                    guard let parentCourse = self.courses.first(where: { $0.resourceKey == mappedEnrollment.updateUrl!.parent?.resourceKey }) else {
                                        TTLog.debug("couldn't find parent course in enrollment!")
                                        return
                                    }
                                    self.courses = NBClient.shared.storedTypes[Course.classIdentifier] as! [Course]
                                    
                                    if let postVC = self.navigationController?.topViewController as? HomeFeedPostViewController {
                                        if mappedEnrollment.updateUrl!.resourceKey == postVC.post.resourceKey {
                                            self.navigationController?.popViewController(animated: true)
                                        }
                                        
                                    }
                                    
                                    if indexOfPost != nil {
                                        if #available(iOS 11.0, *) {
                                            self.bulletinTableView.performBatchUpdates({
                                                self.bulletinTableView.deleteRows(at: [IndexPath(row: indexOfPost!, section: 1)], with: .fade)
                                            }, completion: { (_) in
                                                TTLog.debug("deletes complete")
                                            })
                                        }
                                        else {
                                            self.bulletinTableView.beginUpdates()
                                            self.bulletinTableView.deleteRows(at: [IndexPath(row: indexOfPost!, section: 1)], with: .fade)
                                            self.bulletinTableView.endUpdates()
                                        }
                                    }
                                }
                                */
                            }
                            
                        
                            
                            
                        // }
                        // else {
                        //    self.needsUpdate = true
                        // }
                        
                        // self.newly.showUpdate(message: "New updates")
                        // self.getPosts()
                    }
                }
                catch let error {
                    print("Error parsing json: \(error)")
                }
            }
        }
        
        
        /*
        if #available(iOS 11.0, *) {
            tableView.performBatchUpdates({
                tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
                tableView.insertRows(at: [IndexPath(row: self.comments.count-1, section: 1)], with: .fade)
            }) { (_) in
                TTLog.debug("updates complete")
            }
        }
        else {
            tableView.beginUpdates()
            tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
            tableView.insertRows(at: [IndexPath(row: self.comments.count-1, section: 1)], with: .fade)
            tableView.endUpdates()
        }
        */
    }
}


extension HomeFeedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : (self.posts != nil ? self.posts.count : 0)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            self.performSegue(withIdentifier: "createPostSegue", sender: nil)
        }
        
        else if indexPath.section == 1 {
            self.performSegue(withIdentifier: "postDetailSegue", sender: tableView.cellForRow(at: indexPath) as! HomeFeedPostCell)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = HomeFeedWritePostCell.dequeue(from: tableView)!
            
            cell.userAvatar.image = self.profileImage
            cell.userAvatar.focusOnFaces = true
            cell.userAvatar.contentMode = .scaleAspectFill
            
            return cell
        }
        else {
            let cell = HomeFeedPostCell.dequeue(from: tableView)!
            let post = self.posts[indexPath.row]
            
            cell.configure(post: post)
            return cell
        }
    }
}

extension HomeFeedViewController: NewlyDelegate{
    
    func newlyDidTapped() {
        DispatchQueue.main.async {
            self.newly.hideUpdate()
        }
        self.getPosts()
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
        
        // logoImageView.
        logoContainer.addSubview(logoImageView)
        self.titleView = logoContainer
        // logoContainer.centerYAnchor
    }
}

class HomeTableView: TableView {
    override func customSetup() {
        placeholdersProvider = .homeFeedPlaceholders
    }
}

