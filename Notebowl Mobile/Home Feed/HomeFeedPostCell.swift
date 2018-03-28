//
//  HomeFeedPostCell.swift
//  Notebowl Mobile
//
//  Created by Conner Owen on 3/15/18.
//  Copyright © 2018 Notebowl. All rights reserved.
//



import Foundation
import UIKit
import Kingfisher
import FaveButton
import AyLoading

class HomeFeedPostCell: UITableViewCell, FaveButtonDelegate {
    
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var postContent: UILabel!
    @IBOutlet weak var postedDate: UILabel!
    @IBOutlet weak var postComments: UILabel!
    @IBOutlet weak var postLikes: UILabel!
    @IBOutlet weak var postAttachments: UIImageView!
    @IBOutlet weak var likeButton: FaveButton!
    @IBOutlet weak var commentButton: FaveButton!
    @IBOutlet weak var likeActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var heightConst: NSLayoutConstraint!
    
    var postForCell: Post!
    var imageIsSet: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        initSetup()
    }
    
    func initSetup() {
        userAvatar.layer.cornerRadius = 3.0
        userAvatar.clipsToBounds = true
        userAvatar.layer.masksToBounds = true
        
        // postAttachments.image = UIImage(named: "anon")
        heightConst.constant = 4.0
        postAttachments.layer.cornerRadius = 3.0
        postAttachments.clipsToBounds = true
        postAttachments.layer.masksToBounds = true
        
        selectedBackgroundView?.backgroundColor = UIColor.cyan
    }
    
    func configure(post: Post) {
        print("configure")
        likeButton.setSelected(selected: post.likedByCurrentUser, animated: false)
        postLikes.text = post.postLikes.isEmpty ? "0" : "\(post.postLikes.count)"
        postComments.text = post.postComments.isEmpty ? "0" : "\(post.postComments.count)"
        postContent.text = post.text
        postedDate.text = post.updatedAt.relativelyFormatted
        
        if post.isAnonymous {
            userName.text = "Anonymous"
        }
        else {
            userName.text = post._creator!.fullName
            userAvatar.kf.setImage(with: post._creator!.profileUrl, placeholder: UIImage(named: "Default Avatar"), options: [.transition(.fade(0.3))])
        }

        if (!post.postAttachments.isEmpty) {
            if (post.postAttachments.first!.type.contains("image")) {
                print("postattachment set")
                heightConst.constant = 140.0
                postAttachments.kf.indicatorType = .activity
                postAttachments.kf.setImage(with: post.postAttachments.first!.locationUrl, placeholder: UIImage(named: "Default Avatar"), options: [.transition(.fade(0.3))])
            }
        }
        else {
            heightConst.constant = 0.0
            // postAttachments.isHidden = true
        }

        self.postForCell = post
 
        setNeedsLayout()
        layoutIfNeeded()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func faveButton(_ faveButton: FaveButton, didSelected selected: Bool) {
        // likeActivityIndicator.showViewAnimated(true)
        // postLikes.showViewAnimated(false)
        // likeActivityIndicator.startAnimating()
        postLikes.ay.startLoading()
        
        DispatchQueue.main.async {
            if (!self.likeButton.isSelected) {
                _ = Just.delete(self.postForCell.likeFromCurrentUser!.url.absoluteString, params: ["uuid": UIDevice().uuid])
            }
            else if (self.likeButton.isSelected) {
                _ = Just.post("https://\(NBClient.shared.baseUrl)/api/v1.0/likes", params: ["uuid": UIDevice().uuid], data: ["_parent": "\(self.postForCell.url.absoluteString)"])
            }
            self.postForCell.updateLikes()
            self.postLikes.text = self.postForCell.postLikes.isEmpty ? "0" : "\(self.postForCell.postLikes.count)"
            
            // self.postLikes.showViewAnimated(true)
            // self.likeActivityIndicator.showViewAnimated(false)
            // self.likeActivityIndicator.stopAnimating()
            self.postLikes.ay.stopLoading()
        }
    }
    
}

extension HomeFeedPostCell {
    
    static var reuseId: String {
        return "postCell"
    }
    
    class func register(in tableView: UITableView) {
        tableView.register(UINib(nibName: "HomeFeedPostCell", bundle: nil), forCellReuseIdentifier: self.reuseId)
    }
    
    class func dequeue(from tableView: UITableView) -> HomeFeedPostCell? {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseId)
        return cell as? HomeFeedPostCell
    }
}

