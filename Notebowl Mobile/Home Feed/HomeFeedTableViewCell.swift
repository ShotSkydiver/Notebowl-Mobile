//
//  HomeFeedTableViewCell.swift
//  Notebowl Mobile
//
//  Created by Conner Owen on 2/7/18.
//  Copyright © 2018 NoteBowl. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

@available(iOS 11.0, *)
class HomeFeedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var postContent: UILabel!
    @IBOutlet weak var postedDate: UILabel!
    @IBOutlet weak var postComments: UILabel!
    @IBOutlet weak var postLikes: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var buttonsView: UIView!
    
    var post: Post?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.userAvatar.layer.cornerRadius = self.userAvatar.frame.size.height*0.5
        self.userAvatar.clipsToBounds = true
        self.userAvatar.layer.masksToBounds = true
 
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func likeButtonPressed() {
        if (self.likeButton.isSelected) {
            let delReq = Just.delete(self.post!.likeFromCurrentUser!.url.absoluteString, params: ["uuid": UIDevice().uuid])
            if (delReq.ok) {
                self.post!.refresh()
                self.updateLikes()
            }
        }
        else if (!self.likeButton.isSelected) {
            let postReq = Just.post("https://demo.nbstage.com/api/v1.0/likes", params: ["uuid": UIDevice().uuid], data: ["_parent": "\(self.post!.url.absoluteString)"])
            if (postReq.ok) {
                self.post!.refresh()
                self.updateLikes()
            }
        }
    }
    
    func updateLikes() {
        DispatchQueue.main.async {
            self.postLikes.text = ("\(self.post!.postLikes?.count ?? 0) Likes")
            self.postComments.text = ("\(self.post!.postComments?.count ?? 0) Comments")
            self.likeButton.isSelected = self.post!.likedByCurrentUser!
        }
    }
    
}
