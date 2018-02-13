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
    var loadingView: NBLoadingView?
    
    @IBOutlet var bulletinTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bulletinTableView.refreshControl = UIRefreshControl()
        self.bulletinTableView.refreshControl!.attributedTitle = NSAttributedString(string: "Refresh feed")
        self.bulletinTableView.refreshControl!.tintColor = UIColor(named: "Notebowl Blue")
        self.bulletinTableView.refreshControl!.addTarget(self, action: #selector(HomeFeedViewController.refreshFeed(sender:)), for: .valueChanged)
        
        self.showImage(false)
        loadingView = NBLoadingView()
        loadingView?.showLoadView(false)
        self.view.addSubview(loadingView!)
        loadingView?.addUntitled2Animation()
        
        getPosts()
    }
    
    @objc func refreshFeed(sender: UIRefreshControl) {
        self.getPosts()
    }
    
    func getPosts() {
        loadingView?.showLoadView(true)
        DispatchQueue.main.async {
            
            /// TODO: put this somewhere else
            let user = NBClient.shared.getCurrentUser()
            self.updateImage(image: UIImage(data: Just.get(user.profileThumbUrl.absoluteString).content!)!)
            
            let postsFilter = NBClient.shared.buildFilterString(from: NBClient.shared.getMappable(Course.self)!)
            self.posts = NBClient.shared.getMappable(Post.self, filters: "[\"_parent:IN:\(postsFilter)\"]", sortBy: "updatedAt:desc", limit: "5")
            
            for post in self.posts {
                post.refreshData()
                
            }
            self.posts.sort() { $0.secondsSinceUpdate > $1.secondsSinceUpdate }
            
            self.loadingView?.showLoadView(false)
            self.bulletinTableView.refreshControl!.endRefreshing()
            self.bulletinTableView.delegate = self
            self.bulletinTableView.dataSource = self
            self.bulletinTableView.reloadData()
            self.showImage(true)
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
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Posts from All Courses"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeFeedCell", for: indexPath) as! HomeFeedTableViewCell

        if (self.posts != nil) {
            cell.post = self.posts[indexPath.row]
            cell.awakeFromNib()
        }
 
        return cell
    }
}
