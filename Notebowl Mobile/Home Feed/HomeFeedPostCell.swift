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
import Haptica
import ObjectMapper
import SocketIO
import NVActivityIndicatorView

class HomeFeedPostCell: UITableViewCell, FaveButtonDelegate {
    
    @IBOutlet weak var userAvatar: ProfileImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var postContent: UILabel!
    @IBOutlet weak var postedDate: UILabel!
    @IBOutlet weak var postComments: UILabel!
    @IBOutlet weak var postLikes: UILabel!
    @IBOutlet weak var courseForPost: UILabel!
    @IBOutlet weak var postAttachments: ProfileImageView!
    @IBOutlet weak var likeButton: FaveButton!
    @IBOutlet weak var likeRefresh: NVActivityIndicatorView!
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
        heightConst.constant = 0.0
        
        likeButton.isHaptic = true
        likeButton.hapticType = .impact(.light)
        
        selectedBackgroundView?.backgroundColor = UIColor.cyan
    }
    
    func configure(post: Post) {
        TTLog.debug("configure")
        likeButton.setSelected(selected: post.likedByCurrentUser, animated: false)
        if likeRefresh.isAnimating {
            likeRefresh.stopAnimating()
            postLikes.showViewAnimated(true)
        }
        postLikes.text = post.postLikes.isEmpty ? "0" : "\(post.postLikes.count)"
        postComments.text = post.postComments.isEmpty ? "0" : "\(post.postComments.count)"
        postContent.text = post.text
        courseForPost.text = post.owner!.courseFullName
        postedDate.text = post.createdAt.relativelyFormatted
        
        backgroundColor = post.pinned ? #colorLiteral(red: 0.2310000062, green: 0.6510000229, blue: 0.8859999776, alpha: 0.1000000015) : UIColor(hexString: "#fdfdfd")
        
        if post.isAnonymous {
            userName.text = "Anonymous"
        }
        else {
            userName.text = post.creator!.fullName
            userAvatar.kf.setImage(with: post.creator.profileUrl,
                                   options: [
                                    .transition(ImageTransition.fade(0.3)),
                                    // .forceTransition,
                                    .keepCurrentImageWhileLoading
                ]
            )
        }
        
        if (!post.postAttachments.isEmpty) && (post.postAttachments.first!.type != nil) {
            if (post.postAttachments.first!.type.contains("image")) {
                heightConst.constant = 220.0
                postAttachments.kf.setImage(with: post.postAttachments.first!.getUrlForAvatar()!.absoluteURL, placeholder: nil, options: [.transition(.fade(0.3))], progressBlock: nil, completionHandler: { (image, error, cacheType, URL) in
                    self.setNeedsLayout()
                })
            }
        }
        else {
            heightConst.constant = 0.0
        }
        self.postForCell = post
 
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func faveButton(_ faveButton: FaveButton, didSelected selected: Bool) {
        
        postLikes.showViewAnimated(false)
        likeRefresh.startAnimating()
        DispatchQueue.main.async {
            if (!self.likeButton.isSelected) {
                _ = Just.delete(self.postForCell.likeFromCurrentUser!.url.absoluteString, params: ["uuid": UIDevice().uuid])
            }
            else if (self.likeButton.isSelected) {
                let reqLike = Just.post("https://\(NBClient.baseUrl)/api/v1.0/likes", params: ["uuid": UIDevice().uuid], data: ["_parent": "\(self.postForCell.url.absoluteString)"])
            }
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

