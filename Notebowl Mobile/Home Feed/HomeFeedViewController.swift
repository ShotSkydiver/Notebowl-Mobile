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
import Tamamushi

class HomeFeedViewController: UIViewController, PlaceholderDelegate {
    var posts: [Post]!
    var courses: [Course]!
    var loadingView: NBLoadingView!
    var bgView: UIView!
    var profileImage: UIImage!
    
    
    @IBOutlet var bulletinTableView: HomeTableView!
    
    var placeholderTableView: TableView?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()
        
        profileImage = NBClient.shared.currentUserPic
        
        HomeFeedWritePostCell.register(in: bulletinTableView)
        HomeFeedPostCell.register(in: bulletinTableView)
        
        self.tempLoadingViewSetup()
        placeholderTableView = bulletinTableView
        placeholderTableView?.placeholderDelegate = self
        
        setupNavBar()
        
        //self.automaticallyAdjustsScrollViewInsets = false
        bulletinTableView.contentInset = UIEdgeInsetsMake(-36, 0, 0, 0)
        self.getPosts()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
        navigationController?.navigationBar.layer.shadowRadius = 5.5
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
    
    func getPosts() {
        self.loadingView.showLoadView(true)
        self.bgView.showViewAnimated(true)
        
        DispatchQueue.main.async {
            if (self.courses == nil) || (self.courses.isEmpty) {
                
                let enrollments = NBClient.shared.getMappable(Enrollment.self, filters: "[\"_parent:TYPE:Course\",\"_user:IN:\(NBClient.shared.getCurrentUser().url.absoluteString)\"]", limit: "100")!
                
                var resourceKeys: String = ""

                for enrollment in enrollments {
                    if enrollment.statusIsAccepted {
                        resourceKeys = (resourceKeys + enrollment.parent.lastPathComponent + ",")
                    }
                }
                self.courses = NBClient.shared.initArray(from: NBClient.shared.getMappable(Course.self, filters: "[\"resourceKey:IN:\(resourceKeys)\"]", limit: "100")!)
                if NBClient.shared.storedTypes[Course.classIdentifier] == nil {
                    NBClient.shared.storedTypes[Course.classIdentifier] = self.courses
                }
                else {
                    for course in self.courses {
                        if NBClient.shared.storedTypes[Course.classIdentifier]!.first(where: {$0.resourceKey == course.resourceKey}) == nil {
                            print("course doesn't exist!")
                            NBClient.shared.storedTypes[Course.classIdentifier]!.append(course)
                        }
                    }
                }
            }

            self.posts = NBClient.shared.getMappable(Post.self, filters: "[\"_owner:TYPE:Course\",\"_parent:TYPE:Course\"]", sortBy: "updatedAt:desc", limit: "10")
            
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
           
            self.bgView.showViewAnimated(false)
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

