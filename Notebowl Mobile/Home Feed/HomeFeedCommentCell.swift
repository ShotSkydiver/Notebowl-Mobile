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
import NVActivityIndicatorView

class HomeFeedCommentCell: UITableViewCell, FaveButtonDelegate {
    
    @IBOutlet weak var userAvatar: ProfileImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var commentContent: UILabel!
    @IBOutlet weak var commentAttachments: ProfileImageView!
    @IBOutlet weak var commentLikes: UILabel!
    @IBOutlet weak var likeRefresh: NVActivityIndicatorView!
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
        if likeRefresh.isAnimating {
            likeRefresh.stopAnimating()
            commentLikes.showViewAnimated(true)
        }
        commentLikes.text = comment.commentLikes.isEmpty ? "0" : "\(comment.commentLikes.count)"
        commentContent.text = comment.text
        postedDate.text = comment.createdAt.relativelyFormatted
        
        if comment.isAnonymous {
            userName.text = "Anonymous"
            userAvatar.image = UIImage(named: "anonymous")!
        }
        else {
            userName.text = comment.creator!.fullName
            userAvatar.kf.setImage(with: comment.creator!.profileUrl,
                                   options: [
                                    .transition(ImageTransition.fade(0.3)),
                                    .keepCurrentImageWhileLoading
                ]
            )
        }
        
        if (!comment.commentAttachments.isEmpty) {
            if (comment.commentAttachments.first!.type.contains("image")) {
                heightConst.constant = 180.0
                commentAttachments.kf.indicatorType = .activity
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
    
    @IBAction func likeButtonAction(_ sender: Any) {
        likeRefresh.startAnimating()
        commentLikes.showViewAnimated(false)
    }
    
    func faveButton(_ faveButton: FaveButton, didSelected selected: Bool) {
        DispatchQueue.main.async {
            TTLog.testing("starting async like post/delete")
            if (!self.commentLikeButton.isSelected) {
                getUrl(self.commentForCell.likeFromCurrentUser!.url.absoluteString, method: .delete)
            }
            else if (self.commentLikeButton.isSelected) {
                getUrl(Like.endpoint, method: .post, data: ["_parent": "\(self.commentForCell.url.absoluteString)"])
            }
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
