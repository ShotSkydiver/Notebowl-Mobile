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

class HomeFeedViewController: UITableVCWithNavbarImage {
    var posts: [Post]!
    var loadingView: NBLoadingView!
    
    @IBOutlet var bulletinTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.bulletinTableView.delegate = self
        self.bulletinTableView.dataSource = self
        
        self.tempLoadingViewSetup()
        self.getPosts()
    }

    func tempLoadingViewSetup() {
        self.loadingView = NBLoadingView()
        
        self.view.addSubview(self.loadingView)
        self.loadingView.addUntitled2Animation()
    }
    
    func getPosts() {
        self.loadingView.showLoadView(true)
        
        DispatchQueue.main.async {
                self.posts = NBClient.shared.initArray(from: NBClient.shared.getMappable(Post.self, sortBy: "updatedAt:desc", limit: "8")!)
                self.bulletinTableView.reloadData()
                self.loadingView.showLoadView(false)
            }
    }
}

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
        
        DispatchQueue.main.async {
            cell.updateLikes(animated: false)
            
        }
        
        cell.postContent.text = postForCell.text
        cell.postedDate.text = postForCell.updatedAt.relativelyFormatted
        cell.userName.text = postForCell._creator.fullName
        
        let placeholderimg = UIImage(named: "Default Avatar")
        cell.userAvatar.kf.setImage(with: postForCell._creator.profileThumbUrl, placeholder: placeholderimg, options: [.transition(.fade(0.3))])

        cell.showCell(true)
        return cell
    }
}
