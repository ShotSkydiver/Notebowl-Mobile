//
//  HomeFeedCommentCell.swift
//  Notebowl Mobile
//
//  Created by Conner Owen on 3/19/18.
//  Copyright © 2018 Notebowl. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
import FaveButton
import Haptica
import ObjectMapper

class HomeFeedCommentCell: UITableViewCell, FaveButtonDelegate {
    
    @IBOutlet weak var userAvatar: ProfileImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var commentContent: UILabel!
    @IBOutlet weak var commentAttachments: ProfileImageView!
    @IBOutlet weak var commentLikes: UILabel!
    @IBOutlet weak var commentLikeButton: FaveButton!
    @IBOutlet weak var postedDate: UILabel!
    @IBOutlet weak var heightConst: NSLayoutConstraint!
    
    var commentForCell: Comment!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initSetup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        initSetup()
    }
    
    func initSetup() {
        heightConst.constant = 4.0
        
        commentLikeButton.isHaptic = true
        commentLikeButton.hapticType = .impact(.light)
    }
    
    func configure(comment: Comment) {
        commentLikeButton.setSelected(selected: comment.likedByCurrentUser, animated: false)
        commentLikes.text = comment.commentLikes.isEmpty ? "0" : "\(comment.commentLikes.count)"
        commentContent.text = comment.text
        postedDate.text = comment.createdAt.relativelyFormatted
        
        if comment.isAnonymous {
            userName.text = "Anonymous"
        }
        else {
            userName.text = comment.creator!.fullName
            
            userAvatar.kf.setImage(with: comment.creator!.profileUrl,
                                   options: [
                                    .transition(ImageTransition.fade(0.3)),
                                    // .forceTransition,
                                    .keepCurrentImageWhileLoading
                ]
            )
            
            
            /*
            if comment.creator!.resourceKey == NBClient.shared.getCurrentUser().resourceKey {
                userAvatar.image = NBClient.shared.currentUserPic
            }
            else {
                userAvatar.kf.setImage(with: comment.creator!.profileUrl, placeholder: nil, options: [.transition(.fade(0.3))], progressBlock: nil, completionHandler: { (image, error, cacheType, URL) in
                    self.setNeedsLayout()
                })
            }
            */
        }
        
        if (!comment.commentAttachments.isEmpty) {
            if (comment.commentAttachments.first!.type.contains("image")) {
                heightConst.constant = 180.0
                commentAttachments.kf.setImage(with: comment.commentAttachments.first!.getUrlForAvatar()!.absoluteURL, placeholder: nil, options: [.transition(.fade(0.3))], progressBlock: nil, completionHandler: { (image, error, cacheType, URL) in
                    self.setNeedsLayout()
                })
            }
        }
        else {
            heightConst.constant = 0.0
        }
        self.commentForCell = comment
        
        setNeedsLayout()
        layoutIfNeeded()
        
    }
    
    func faveButton(_ faveButton: FaveButton, didSelected selected: Bool) {
        // commentLikes.ay.startLoading()
        // commentLikes.ay.isLoading
        DispatchQueue.main.async {
            TTLog.testing("starting async like post/delete")
            if (!self.commentLikeButton.isSelected) {
                _ = Just.delete(self.commentForCell.likeFromCurrentUser!.url.absoluteString, params: ["uuid": UIDevice().uuid])
                // NBClient.shared.storedTypes[Like.classIdentifier]?.removeAll(self.commentForCell.likeFromCurrentUser!)
            }
            else if (self.commentLikeButton.isSelected) {
                let reqLike = Just.post("https://\(NBClient.baseUrl)/api/v1.0/likes", params: ["uuid": UIDevice().uuid], data: ["_parent": "\(self.commentForCell.url.absoluteString)"])
                // let finalmap = Mapper<Like>().map(JSONObject: (reqLike.json as AnyObject).value(forKeyPath: "result")!)
                // NBClient.shared.storedTypes[Like.classIdentifier]?.append(finalmap!)
            }
            TTLog.testing("end async like post/delete")
            // self.commentForCell.updateLikes()
            // self.commentLikes.text = self.commentForCell.commentLikes.isEmpty ? "0" : "\(self.commentForCell.commentLikes.count)"
            // self.commentLikes.ay.stopLoading()
        }
    }
}


extension HomeFeedCommentCell {
    
    static var reuseId: String {
        return "commentCell"
    }
    
    class func register(in tableView: UITableView) {
        tableView.register(UINib(nibName: "HomeFeedCommentCell", bundle: nil), forCellReuseIdentifier: self.reuseId)
    }
    
    class func dequeue(from tableView: UITableView) -> HomeFeedCommentCell? {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseId)
        return cell as? HomeFeedCommentCell
    }
}
