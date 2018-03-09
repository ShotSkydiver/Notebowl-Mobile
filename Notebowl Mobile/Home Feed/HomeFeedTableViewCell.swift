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
import FaveButton

class HomeFeedTableViewCell: UITableViewCell, FaveButtonDelegate {
    
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var postContent: UILabel!
    @IBOutlet weak var postedDate: UILabel!
    @IBOutlet weak var postComments: UILabel!
    @IBOutlet weak var postLikes: UILabel!
    @IBOutlet weak var likeButton: FaveButton!

    var post: Post?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.userAvatar.layer.cornerRadius = 3.0
        self.userAvatar.clipsToBounds = true
        self.userAvatar.layer.masksToBounds = true
 
        self.likeButton.delegate = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func faveButton(_ faveButton: FaveButton, didSelected selected: Bool) {
        print("didselected")
        // self.likeButton.setSelected(selected: selected, animated: true)
    }

    @IBAction func likeButtonPressed() {
        print("pressed")
        if (!self.likeButton.isSelected) {
            // self.likedBool = false
                // self.updateLikeButton(animated: true)

            // DispatchQueue.main.async {
            _ = Just.delete(self.post!.likeFromCurrentUser!.url.absoluteString, params: ["uuid": UIDevice().uuid]) { _ in
                print("after del")
                self.post!.updateLikes()
            }

            // }
        }
        else if (self.likeButton.isSelected) {
            // self.likedBool = true

            // DispatchQueue.main.async {
            _ = Just.post("https://demo.nbstage.com/api/v1.0/likes", params: ["uuid": UIDevice().uuid], data: ["_parent": "\(self.post!.url.absoluteString)"]) { _ in
                print("after post")
                self.post!.updateLikes()
            }
            
            
                // self.updatePostText()
            // }
        }
        
        DispatchQueue.main.async {
            
        self.postLikes.text = "\(self.post!.postLikes!.count)"
        }
    }
    
    func updateLikeButton(animated: Bool) {
 
            self.likeButton.setSelected(selected: self.post!.likedByCurrentUser!, animated: animated)
        
  
            // self.likeButton.setSelected(selected: self.likedBool, animated: animated)
        
    }
    
    func updatePostText() {
        // DispatchQueue.main.async {
            switch (self.post!.postLikes!.count) {
            case 1:
                self.postLikes.text = ("\(self.post!.postLikes?.count ?? 0)")
                break
            default:
                self.postLikes.text = ("\(self.post!.postLikes?.count ?? 0)")
                break
            }
            switch (self.post!.postComments!.count) {
            case 1:
                self.postComments.text = ("\(self.post!.postComments?.count ?? 0) comment")
                break
            default:
                self.postComments.text = ("\(self.post!.postComments?.count ?? 0) comments")
                break
            }
            
        // }
    }
    
}
