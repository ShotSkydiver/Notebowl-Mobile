//
//  HomeFeedCommentCell.swift
//  Notebowl Mobile
//
//  Created by Conner Owen on 3/19/18.
//  Copyright © 2018 Notebowl. All rights reserved.
//

import UIKit
import Kingfisher

class HomeFeedCommentCell: UITableViewCell {
    
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var commentContent: UILabel!
    @IBOutlet weak var commentAttachments: UIImageView!
    @IBOutlet weak var postedDate: UILabel!

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
        userAvatar.layer.cornerRadius = 3.0
        userAvatar.clipsToBounds = true
        userAvatar.layer.masksToBounds = true
        commentAttachments.layer.cornerRadius = 3.0
        commentAttachments.clipsToBounds = true
        commentAttachments.layer.masksToBounds = true
    }
    
    func configure(comment: Comment) {
        if comment.isAnonymous {
            userName.text = "Anonymous"
        }
        else {
            userName.text = comment.creator?.fullName
            userAvatar.kf.setImage(with: comment.creator!.profileThumbUrl, placeholder: UIImage(named: "Default Avatar"), options: [.transition(.fade(0.3))])
        }
        if (!comment.commentAttachments.isEmpty) {
            if (comment.commentAttachments.first!.type.contains("image")) {
                commentAttachments.kf.setImage(with: comment.commentAttachments.first!.locationUrl, placeholder: UIImage(named: "Default Avatar"), options: [.transition(.fade(0.3))])
            }
        }

        commentContent.text = comment.text
        postedDate.text = comment.updatedAt.relativelyFormatted
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
