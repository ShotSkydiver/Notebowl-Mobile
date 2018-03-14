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

class HomeFeedViewController: UITableVCWithNavbarImage, PlaceholderDelegate {
    var posts: [Post]!
    var loadingView: NBLoadingView!
    var bgView: UIView!
    
    @IBOutlet var bulletinTableView: HomeTableView!
    
    var placeholderTableView: TableView?

    override func viewDidLoad() {
        super.viewDidLoad()
        bulletinTableView.delegate = self
        bulletinTableView.dataSource = self
        self.tempLoadingViewSetup()
        
        placeholderTableView = bulletinTableView
        placeholderTableView?.placeholderDelegate = self
        
        self.getPosts()
    }

    func tempLoadingViewSetup() {
        self.loadingView = NBLoadingView()
        self.bgView = UIView(loadingView: self.loadingView)
        self.view.addSubview(bgView)
    }
    
    func view(_ view: Any, actionButtonTappedFor placeholder: HGPlaceholders.Placeholder) {
        placeholderTableView?.showDefault()
        
        self.getPosts()
    }
    
    func getPosts() {
        self.loadingView.showLoadView(true)
        
        DispatchQueue.main.async {
            self.posts = NBClient.shared.initArray(from: NBClient.shared.getMappable(Post.self, sortBy: "updatedAt:desc", limit: "6")!)
            self.bulletinTableView.reloadData()
            
            self.bgView.showViewAnimated(false)
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
        if (cell.post == nil) {
            print("post nil")
            cell.post = postForCell
        }
        
        
        
        DispatchQueue.main.async {
            cell.updateLikeButton(animated: false)
            //cell.updatePostText()
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


class NotebowlLogoNavigationItem: UINavigationItem {
    
    let logoContainer = UIView(frame: CGRect(x: 0, y: 0, width: 270, height: 30))
    
    private let nbLogo = UIImage(named: "nb-logo-vector-white2")!
    private let logoImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 270, height: 22))
    
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
