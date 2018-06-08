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

class HomeFeedViewController: UIViewController, PlaceholderDelegate, UpdateVC {
    var indexes: Paths = Paths()
    
    
    var posts: [Post]!
    var courses: [Course]!
    var attachments: [Attachment]!
    var loadingView: NBLoadingView!
    var bgView: UIView!
    
    @IBOutlet var bulletinTableView: HomeTableView!
    var placeholderTableView: TableView?
    
    override func viewDidLoad() {
        TTLog.testing("homeVC didload")
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()
        HomeFeedWritePostCell.register(in: bulletinTableView)
        HomeFeedPostCell.register(in: bulletinTableView)
        
        self.tempLoadingViewSetup()
        placeholderTableView = bulletinTableView
        placeholderTableView?.placeholderDelegate = self
        
        setupNavBar()
        TMGradientNavigationBar().setGradientColorOnNavigationBar(bar: (navigationController?.navigationBar)!, direction: .horizontal, startColor: #colorLiteral(red: 0.2310000062, green: 0.6510000229, blue: 0.8859999776, alpha: 1), endColor: #colorLiteral(red: 0.3249999881, green: 0.7139999866, blue: 0.4350000024, alpha: 1))
        bulletinTableView.contentInset = UIEdgeInsetsMake(-36, 0, -36, 0)
        self.getPosts()
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
        // homeVC.bgView.showViewAnimated(false) TAKE CARE OF THIS 
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
                        resourceKeys = (resourceKeys + enrollment.parent!.url.absoluteURL.lastPathComponent + ",")
                    }
                }
                self.courses = NBClient.shared.initArray(from: NBClient.shared.getMappable(Course.self, filters: "[\"resourceKey:IN:\(resourceKeys)\"]", limit: "100")!)
                let categories: [Category]! = NBClient.shared.initArray(from: NBClient.shared.getMappable(Category.self, filters: "[\"_parent:IN:\(NBClient.shared.buildFilterString(from: self.courses))\"]")!)
            }
            self.getData()
            self.bulletinTableView.reloadData()
        }
    }
    
    func getData() {
        self.posts = NBClient.shared.getMappable(Post.self, filters: "[\"_owner:TYPE:Course\",\"_parent:TYPE:Course\"]", sortBy: "createdAt:desc", limit: "10")
        let comments: [Comment]! = NBClient.shared.getMappable(Comment.self, filters: "[\"_parent:IN:\(NBClient.shared.buildFilterString(from: self.posts))\"]")!
        let filterString = NBClient.shared.buildFilterString(from: self.posts)
        let combinedFilter = filterString + NBClient.shared.buildFilterString(from: comments)
        
        let likes = NBClient.shared.getMappable(Like.self, filters: "[\"_parent:IN:\(combinedFilter)\"]")!
        self.attachments = NBClient.shared.getMappable(Attachment.self, filters: "[\"_parent:IN:\(combinedFilter)\"]")!

        self.posts = NBClient.shared.initArray(from: self.posts)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        TTLog.testing("homeVC willappear")
        let selectedRowIndexPath = self.bulletinTableView.indexPathForSelectedRow
        super.viewWillAppear(animated)
        
        if selectedRowIndexPath != nil {
            TTLog.debug("reloading")
            self.bulletinTableView.reloadData(withoutScroll: true)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        TTLog.testing("homeVC didappear")
        super.viewDidAppear(animated)
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
            destVC.coursesForPicker = self.courses
            destVC.selectedCourse = self.courses.first!
            if let senderCell = sender as? HomeFeedPostCell {
                TTLog.debug("editing existing post!")
                destVC.editingExistingPost = true
                destVC.existingPostToEdit = senderCell.postForCell
                destVC.existingCell = senderCell
            }
        }
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        self.performSegue(withIdentifier: "segueDeck", sender: nil)
    }
    
}

extension HomeFeedViewController {

    func handleUpdated(newObject: NBModel) {
        if newObject.itemType == "Post" {
            self.posts = NBClient.shared.storedTypes[Post.classIdentifier]! as! [Post]
            let indexOfPost = self.posts.index(where: { $0.resourceKey == newObject.resourceKey })
            let existingPost = self.bulletinTableView.numberOfRows(inSection: 1) < self.posts.count ? false : true
            
            existingPost == false ? indexes.insertIndexPaths.append(IndexPath(row: indexOfPost!, section: 1)) : indexes.reloadIndexPaths.append(IndexPath(row: indexOfPost!, section: 1))
        }
        else if ["Comment","Like","AttachmentS3"].contains(newObject.itemType) {
            if let parentPost = self.posts.first(where: { $0.resourceKey == newObject.parentURL!.absoluteURL.lastPathComponent }) {
                let indexOfPost = self.posts.index(where: { $0.resourceKey == parentPost.resourceKey })
                parentPost.refresh()
                if indexOfPost != nil { indexes.reloadIndexPaths.append(IndexPath(row: indexOfPost!, section: 1)) }
            }
        }
        else if newObject.itemType == "User" {
            if newObject.resourceKey == NBClient.shared.getCurrentUser().resourceKey {
                indexes.reloadIndexPaths.append(IndexPath(row: 0, section: 0))
                let postsForUser = self.posts.filter({ $0.creator.resourceKey == newObject.resourceKey })
                for post in postsForUser {
                    if let index = self.posts.index(of: post) {
                        indexes.reloadIndexPaths.append(IndexPath(row: index, section: 1))
                    }
                }
            }
        }
        else if newObject.itemType == "CourseUser" {
 
            if (newObject as! Enrollment).parent!.firstTimeLoading {
                self.getPosts()
                self.bgView.showViewAnimated(false)
                
            }
            else if !(newObject as! Enrollment).parent!.firstTimeLoading || (newObject as! Enrollment).parent!.firstTimeLoading == nil {
                (newObject as! Enrollment).parent!.refresh()
                
            }
            
        }
    }
    
    func handleDeleted(deletedObject: NBModel) {
        
        if deletedObject.itemType == "Post" {
            if let postVC = self.navigationController?.topViewController as? HomeFeedPostViewController {
                if deletedObject.resourceKey == postVC.post.resourceKey {
                    self.navigationController?.popViewController(animated: true)
                }
            }
            let indexOfPost = self.posts.index(where: { $0.resourceKey == deletedObject.resourceKey })
            if indexOfPost != nil { indexes.deleteIndexPaths.append(IndexPath(row: indexOfPost!, section: 1)) }
            
            self.posts = NBClient.shared.storedTypes[Post.classIdentifier]! as! [Post]
        }
        
        else if ["Comment","Like","AttachmentS3"].contains(deletedObject.itemType) {
            if let parentPost = self.posts.first(where: { $0.resourceKey == deletedObject.parentURL!.absoluteURL.lastPathComponent }) {
                let indexOfPost = self.posts.index(where: { $0.resourceKey == parentPost.resourceKey })
                parentPost.refresh()
                if indexOfPost != nil { indexes.reloadIndexPaths.append(IndexPath(row: indexOfPost!, section: 1)) }
            }

        }
            
            
        else if deletedObject.itemType == "User" {
            TTLog.error("????????????")
        }
        
        else if deletedObject.itemType == "CourseUser" {
            guard let deletedEnrollment = deletedObject as? Enrollment else { return }
            
            NBClient.shared.storedTypes[Course.classIdentifier]!.removeAll(deletedEnrollment.parent!)
            let postsToRemove = NBClient.shared.storedTypes[Post.classIdentifier]!.filter({($0 as! Post).owner.resourceKey == deletedEnrollment.parent!.resourceKey }) as! [Post]
            for post in postsToRemove {
                NBClient.shared.storedTypes[Post.classIdentifier]!.removeAll(post)
                
            }
            if NBClient.shared.storedTypes[Post.classIdentifier]!.count < 1 {
                var newPosts = NBClient.shared.getMappable(Post.self, filters: "[\"_owner:TYPE:Course\",\"_parent:TYPE:Course\"]", sortBy: "createdAt:desc", limit: "10")
                newPosts = NBClient.shared.initArray(from: newPosts!)
                NBClient.shared.storedTypes[Post.classIdentifier]! = newPosts!
            }
            self.courses = NBClient.shared.storedTypes[Course.classIdentifier]! as! [Course]
            self.posts = NBClient.shared.storedTypes[Post.classIdentifier]! as! [Post]
            
            self.bulletinTableView.reloadData()
        }
    }
    
    func handleElapsed(elapsedObject: NBModel) {
        if elapsedObject.itemType == "User" {
            TTLog.debug("user elapsed")
        }
    }
    
    func reloadTableViews() {
        self.bulletinTableView.beginUpdates()

        self.bulletinTableView.reloadRows(at: self.indexes.reloadIndexPaths, with: .fade)
        self.bulletinTableView.insertRows(at: self.indexes.insertIndexPaths, with: .left)
        self.bulletinTableView.deleteRows(at: self.indexes.deleteIndexPaths, with: .right)
        self.bulletinTableView.endUpdates()
        TTLog.warning("COMPLETED????")
        self.indexes = Paths()
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
        tableView.deselectRow(at: indexPath, animated: false)
        if let cell = tableView.cellForRow(at: indexPath) as? HomeFeedWritePostCell {
            self.performSegue(withIdentifier: "createPostSegue", sender: nil)
        }
        else if let cell = tableView.cellForRow(at: indexPath) as? HomeFeedPostCell {
            self.performSegue(withIdentifier: "postDetailSegue", sender: cell)
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
            cell.parentController = self
            cell.configure(post: post)
            cell.delegate = self
            cell.setCollectionView(dataSource: cell, delegate: cell, indexPath: indexPath)
            return cell
        }
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
        edit.backgroundColor = #colorLiteral(red: 0.1019607843, green: 0.5137254902, blue: 0.7411764706, alpha: 1)
        edit.fulfill(with: .reset)
        
        let delete = SwipeAction(style: .destructive, title: "Delete") { (action, indexPath) in
            self.posts.remove(at: indexPath.row)
            action.fulfill(with: .delete)
            NBNetworking.shared.request(.delete, url: selectedCell.postForCell.url.absoluteString)
        }
        delete.image = UIImage(named: "trash-vector")!.filled(withColor: .groupTableViewBackground).withRenderingMode(.alwaysOriginal)
        delete.textColor = .groupTableViewBackground
        delete.backgroundColor = #colorLiteral(red: 1, green: 0.2352941176, blue: 0.1882352941, alpha: 1)
        
        let report = SwipeAction(style: .default, title: "Report") { (action, indexPath) in
            let alert = UIAlertController(title: "Report Post", message: "What's wrong with this post?", preferredStyle: .actionSheet)
            let inappropriate = UIAlertAction(title: "It doesn't belong on Notebowl", style: .default, handler: { inappAction in
                let payload: Any? = ["reason": "inappropriate", "_parent": "\(selectedCell.postForCell.url.absoluteString)"]
                NBNetworking.shared.request(.post, url: Abuse.endpoint, json: payload)
                alert.dismiss(animated: true, completion: nil)
            })
            let spam = UIAlertAction(title: "It's spam", style: .default, handler: { spamAction in
                let payload: Any? = ["reason": "spam", "_parent": "\(selectedCell.postForCell.url.absoluteString)"]
                NBNetworking.shared.request(.post, url: Abuse.endpoint, json: payload)
                alert.dismiss(animated: true, completion: nil)
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
        
        if (selectedCell.postForCell.creator != nil) && (selectedCell.postForCell.creator.resourceKey == NBClient.shared.getCurrentUser().resourceKey) {
            return [delete, edit]
        }
        else if (selectedCell.postForCell.owner.enrollmentForUser?.role == "Professor") {
            return [delete, report] // and pin
        }
        else {
            return [report]
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        let selectedCell = tableView.cellForRow(at: indexPath) as! HomeFeedPostCell
        if (selectedCell.postForCell.creator != nil) {
            if (selectedCell.postForCell.creator.resourceKey == NBClient.shared.getCurrentUser().resourceKey) || (selectedCell.postForCell.owner.enrollmentForUser?.role == "Professor") {
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

