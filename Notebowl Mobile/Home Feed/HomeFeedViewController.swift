//
//  HomeFeedViewController.swift
//  NB-Mobile
//
//  Created by Conner Owen on 2/7/18.
//  Copyright © 2018 NoteBowl. All rights reserved.
//

import Foundation
import UIKit

@available(iOS 11.0, *)
class HomeFeedViewController: UITableVCWithNavbarImage {
    var posts: [Post]!
    var loadingView: NBLoadingView!
    
    @IBOutlet var bulletinTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tempLoadingViewSetup()
        self.tempUserImageUpdater()
        
        self.bulletinTableView.delegate = self
        self.bulletinTableView.dataSource = self
        
        self.getPosts()
    }
    
    func tempUserImageUpdater() {
        DispatchQueue.main.async {
            let user = NBClient.shared.getCurrentUser()
            self.updateImage(image: UIImage(data: Just.get(user.profileThumbUrl.absoluteString).content!)!)
            self.showImage(true)
        }
    }
    func tempLoadingViewSetup() {
        self.loadingView = NBLoadingView()
        self.view.addSubview(self.loadingView)
        self.loadingView.addUntitled2Animation()
    }
    
    func getPosts() {
        self.loadingView.showLoadView(true)
        
        DispatchQueue.main.async {
            let postsFilter = NBClient.shared.buildFilterString(from: NBClient.shared.getMappable(Course.self)!)
            self.posts = NBClient.shared.getMappable(Post.self, filters: "[\"_parent:IN:\(postsFilter)\"]", sortBy: "updatedAt:desc", limit: "2")
            
            for post in self.posts {
                post.refreshData()
            }
            self.posts.sort() { $0.secondsSinceUpdate > $1.secondsSinceUpdate }
        
            self.loadingView.showLoadView(false)
            self.bulletinTableView.reloadData()
            
        }
    }
}

@available(iOS 11.0, *)
extension HomeFeedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.posts) != nil {
            return self.posts.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeFeedCell", for: indexPath) as! HomeFeedTableViewCell

        let postForCell = self.posts[indexPath.row]
        cell.post = postForCell
        
        cell.postContent.text = postForCell.text
        cell.postedDate.text = postForCell.updatedAt.relativelyFormatted
        cell.userName.text = postForCell._creator.fullName
        cell.userAvatar.image = postForCell._creator.profileUrl
        
        cell.postLikes.text = ("\(postForCell.postLikes?.count ?? 0) Likes")
        cell.postComments.text = ("\(postForCell.postComments?.count ?? 0) Comments")
        
        if (postForCell.likedByCurrentUser)! {
            cell.setPostLiked()
        }
        cell.showCell(true)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        DispatchQueue.main.async(execute: {
            (cell as! HomeFeedTableViewCell).updateLikes()
        })
    }
   
}
