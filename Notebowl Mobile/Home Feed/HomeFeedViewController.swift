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

class HomeFeedViewController: UIViewController, PlaceholderDelegate, UpdateVC {
    var posts: [Post]!
    var courses: [Course]!
    var loadingView: NBLoadingView!
    var bgView: UIView!
    
    @IBOutlet var bulletinTableView: HomeTableView!
    
    var placeholderTableView: TableView?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()
        
        HomeFeedWritePostCell.register(in: bulletinTableView)
        HomeFeedPostCell.register(in: bulletinTableView)
        
        self.tempLoadingViewSetup()
        placeholderTableView = bulletinTableView
        placeholderTableView?.placeholderDelegate = self
        
        registerSocketHandler()
        setupNavBar()
        TMGradientNavigationBar().setGradientColorOnNavigationBar(bar: (navigationController?.navigationBar)!, direction: .horizontal, startColor: #colorLiteral(red: 0.2310000062, green: 0.6510000229, blue: 0.8859999776, alpha: 1), endColor: #colorLiteral(red: 0.3249999881, green: 0.7139999866, blue: 0.4350000024, alpha: 1))
        bulletinTableView.contentInset = UIEdgeInsetsMake(-36, 0, -36, 0)
        self.getPosts()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TTLog.info("viewdidappear")
        TTLog.socket("registered handlers: ", NBSocket.shared.manager.defaultSocket.handlers.count)
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
                    let coursesVC = rootNavController.topViewController as! CoursesTableViewController
                    coursesVC.courses = self.courses
                    let _ = coursesVC.view
                }
                else if rootNavController.topViewController is NotificationsTableViewController {
                    let notifsVC = rootNavController.topViewController as! NotificationsTableViewController

                    notifsVC.notifications = NBClient.shared.getMappable(Notification.self, filters: "[\"text:IS_NULL:false\"]", sortBy: "createdAt:desc")!
                    if NBClient.shared.storedTypes[Notification.classIdentifier] == nil {
                        NBClient.shared.storedTypes[Notification.classIdentifier] = notifsVC.notifications
                    }
                    tabBarController?.tabBar.items![2].badgeColor = #colorLiteral(red: 0.2310000062, green: 0.6510000229, blue: 0.8859999776, alpha: 1)
                    let unreads = notifsVC.notifications.filter({ $0.unseenBool == true })
                    if unreads.count > 0 {
                        tabBarController?.tabBar.items![2].badgeValue = String(format: "%d", (unreads.count))
                    }
                    
                    let _ = notifsVC.view
                }
            }
        }
    }
    
    func getPosts() {
        self.loadingView.showLoadView(true)
        self.bgView.showViewAnimated(true)

        DispatchQueue.main.async {
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
                        resourceKeys = (resourceKeys + enrollment.parent!.url.absoluteURL.lastPathComponent + ",")
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
                let categories: [Category]! = NBClient.shared.initArray(from: NBClient.shared.getMappable(Category.self, filters: "[\"_parent:IN:\(NBClient.shared.buildFilterString(from: self.courses))\"]")!)
                
                if NBClient.shared.storedTypes[Category.classIdentifier] == nil {
                    NBClient.shared.storedTypes[Category.classIdentifier] = categories
                }
                else {
                    for category in categories {
                        if NBClient.shared.storedTypes[Category.classIdentifier]!.first(where: {$0.resourceKey == category.resourceKey}) == nil {
                            NBClient.shared.storedTypes[Category.classIdentifier]!.append(category)
                        }
                    }
                }
            }
            self.getData()
            self.bulletinTableView.reloadData()
   
            self.loadOtherTabs()

            self.bgView.showViewAnimated(false)
            // self.animateCells()
        }
    }
    /*
    func animateCells() {
        let fromAnimation = AnimationType.from(direction: .bottom, offset: 30.0)
        UIView.animate(views: self.bulletinTableView.visibleCells,
                       animations: [fromAnimation])
    }
    */
    func getData() {
        self.posts = NBClient.shared.getMappable(Post.self, filters: "[\"_owner:TYPE:Course\",\"_parent:TYPE:Course\"]", sortBy: "createdAt:desc", limit: "10")
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
        
        let comments: [Comment]! = NBClient.shared.getMappable(Comment.self, filters: "[\"_parent:IN:\(NBClient.shared.buildFilterString(from: self.posts))\"]")!
        if NBClient.shared.storedTypes[Comment.classIdentifier] == nil {
            NBClient.shared.storedTypes[Comment.classIdentifier] = comments
        }
        else {
            for comment in comments {
                if NBClient.shared.storedTypes[Comment.classIdentifier]!.first(where: {$0.resourceKey == comment.resourceKey}) == nil {
                    NBClient.shared.storedTypes[Comment.classIdentifier]!.append(comment)
                }
            }
        }
        
        let filterString = (NBClient.shared.buildFilterString(from: self.posts) + (NBClient.shared.buildFilterString(from: comments)))
        
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
            destVC.coursesForPicker = self.courses
            destVC.selectedCourse = self.courses.first!
        }
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        self.performSegue(withIdentifier: "segueDeck", sender: nil)
    }
    
    func handleUpdate(mapped: Generic, updateUI: Bool) {
        if (mapped.itemType?.contains("Post"))! {
            let mappedPost = mapped as! Response<Post>
            let indexOfPost = self.posts.index(of: mappedPost.updateUrl!)
            NBClient.shared.storedTypes[Post.classIdentifier]!.sort(by: { ($0 as! Post).secondsSinceCreation > ($1 as! Post).secondsSinceCreation })
            self.posts = NBClient.shared.storedTypes[Post.classIdentifier]! as! [Post]
            
            if mappedPost.actionType == .updated {
                if updateUI {
                    self.bulletinTableView.beginUpdates()
                    self.bulletinTableView.reloadSections(IndexSet(integer: 1), with: .automatic)
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
                    if updateUI {
                        self.bulletinTableView.beginUpdates()
                        self.bulletinTableView.deleteRows(at: [IndexPath(row: indexOfPost!, section: 1)], with: .right)
                        self.bulletinTableView.endUpdates()
                    }
                }
            }
        }
            
        /// TODO :: COMBINE COMMENTS AND LIKES UPDATE HANDLING
        else if (mapped.itemType?.contains("Comment"))! {
            let mappedComment = mapped as! Response<Comment>
            guard let parentPost = self.posts.first(where: { $0.resourceKey == mappedComment.updateUrl!.parent.absoluteURL.lastPathComponent }) else {
                return
            }
            let indexOfPost = self.posts.index(of: parentPost)
            parentPost.refresh()
            
            if indexOfPost != nil {
                if updateUI {
                    self.bulletinTableView.beginUpdates()
                    self.bulletinTableView.reloadRows(at: [IndexPath(row: indexOfPost!, section: 1)], with: .fade)
                    self.bulletinTableView.endUpdates()
                }
            }
        }
        else if (mapped.itemType?.contains("Like"))! {
            let mappedLike = mapped as! Response<Like>
            if let parentPost = self.posts.first(where: { $0.resourceKey == mappedLike.updateUrl!.parent.absoluteURL.lastPathComponent }) {
                let indexOfPost = self.posts.index(of: parentPost)
                parentPost.updateLikes()
                if indexOfPost != nil {
                    if updateUI {
                        self.bulletinTableView.beginUpdates()
                        self.bulletinTableView.reloadRows(at: [IndexPath(row: indexOfPost!, section: 1)], with: .fade)
                        self.bulletinTableView.endUpdates()
                    }
                }
            }
            else if let parentComment = NBClient.shared.storedTypes[Comment.classIdentifier]!.first(where: { $0.resourceKey == mappedLike.updateUrl!.parent.absoluteURL.lastPathComponent }) {
                (parentComment as! Comment).updateLikes()
            }
        }
        else if (mapped.itemType?.contains("AttachmentS3"))! {
            let mappedAttachment = mapped as! Response<Attachment>
            
            if let parentPost = self.posts.first(where: { $0.resourceKey == mappedAttachment.updateUrl!.parent.absoluteURL.lastPathComponent }) {
                let indexOfPost = self.posts.index(of: parentPost)
                parentPost.refresh()
                
                if indexOfPost != nil {
                    if updateUI {
                        self.bulletinTableView.beginUpdates()
                        self.bulletinTableView.reloadRows(at: [IndexPath(row: indexOfPost!, section: 1)], with: .fade)
                        self.bulletinTableView.endUpdates()
                    }
                }
            }
            else if let parentComment = NBClient.shared.storedTypes[Comment.classIdentifier]!.first(where: { $0.resourceKey == mappedAttachment.updateUrl!.parent.absoluteURL.lastPathComponent }) {
                (parentComment as! Comment).refresh()
            }
        }
        else if (mapped.itemType?.contains("User"))! {
            let mappedUser = mapped as! Response<User>
            for post in self.posts {
                post.refresh()
            }
            if mappedUser.updateUrl!.resourceKey == NBClient.shared.getCurrentUser().resourceKey {
                // NBClient.shared.getCurrentUser()
            }
            if updateUI {
                self.bulletinTableView.beginUpdates()
                self.bulletinTableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
                self.bulletinTableView.reloadSections(IndexSet(integer: 1), with: .fade)
                self.bulletinTableView.endUpdates()
            }
        }
        else if (mapped.itemType?.contains("CourseUser"))! {
            let mappedEnrollment = mapped as! Response<Enrollment>
            if mappedEnrollment.updateUrl!.parent!.firstTimeLoading {
                let loadingView2 = NBLoadingView()
                UIApplication.shared.keyWindow?.addSubview(loadingView2)
                loadingView2.addUntitled2Animation()
                loadingView2.showLoadView(true)
                DispatchQueue.main.async {
                    self.getData()
                    loadingView2.showLoadView(false)
                    if updateUI {
                        self.bulletinTableView.beginUpdates()
                        self.bulletinTableView.reloadSections(IndexSet(integer: 1), with: .automatic)
                        self.bulletinTableView.endUpdates()
                    }
                }
            }
            else if !mappedEnrollment.updateUrl!.parent!.firstTimeLoading || mappedEnrollment.updateUrl!.parent!.firstTimeLoading == nil {
                mappedEnrollment.updateUrl!.parent!.refresh()
                
            }
            if mappedEnrollment.actionType == .deleted {
                NBClient.shared.storedTypes[Course.classIdentifier]!.removeAll(mappedEnrollment.updateUrl!.parent!)
                
                let postsToRemove = NBClient.shared.storedTypes[Post.classIdentifier]!.filter({($0 as! Post).owner.resourceKey == mappedEnrollment.updateUrl!.parent!.resourceKey }) as! [Post]
                for post in postsToRemove {
                    NBClient.shared.storedTypes[Post.classIdentifier]!.removeAll(post)
                }
                if NBClient.shared.storedTypes[Post.classIdentifier]!.count < 1 {
                    var newPosts = NBClient.shared.getMappable(Post.self, filters: "[\"_owner:TYPE:Course\",\"_parent:TYPE:Course\"]", sortBy: "createdAt:desc", limit: "10")
                    newPosts = NBClient.shared.initArray(from: newPosts!)
                    NBClient.shared.storedTypes[Post.classIdentifier]! = newPosts!
                }
                NBClient.shared.storedTypes[Course.classIdentifier]!.sort(by: { ($0 as! Course).secondsSinceUpdate > ($1 as! Course).secondsSinceUpdate })
                self.courses = NBClient.shared.storedTypes[Course.classIdentifier]! as! [Course]
                
                NBClient.shared.storedTypes[Post.classIdentifier]!.sort(by: { $0.secondsSinceCreation > $1.secondsSinceCreation } )
                self.posts = NBClient.shared.storedTypes[Post.classIdentifier]! as! [Post]
                if updateUI {
                    self.bulletinTableView.beginUpdates()
                    self.bulletinTableView.reloadSections(IndexSet(integer: 1), with: .automatic)
                    self.bulletinTableView.endUpdates()
                }
            }
        }
    }

    func registerSocketHandler() {
        NBSocket.shared.manager.defaultSocket.on(NBClient.shared.getCurrentUser().resourceKey) { (data, ackEmitter) in
            guard let message = data[0] as? String else { return }
            if let data = message.data(using: .utf8) {
                do {
                    let JSON = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String : AnyObject]
                    let mapped = Mapper<Generic>().map(JSON: JSON)!
                    
                    self.handleUpdate(mapped: mapped, updateUI: true)
                }
                catch let error {
                    print("Error parsing json: \(error)")
                }
            }
        }
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

            cell.userAvatar.kf.setImage(with: NBClient.shared.getCurrentUser().profileUrl,
                        options: [
                            .transition(ImageTransition.fade(0.3)),
                            // .forceTransition,
                            .keepCurrentImageWhileLoading
                ]
            )
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
        placeholdersProvider = .homeFeedPlaceholders
    }
}

