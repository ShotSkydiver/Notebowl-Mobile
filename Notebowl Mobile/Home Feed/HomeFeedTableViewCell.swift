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
    @IBOutlet weak var commentButton: FaveButton!
    @IBOutlet weak var likeActivityIndicator: UIActivityIndicatorView!

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
        print("didselected: ", selected)
        self.likeActivityIndicator.showViewAnimated(true)
        self.postLikes.showViewAnimated(false)
        self.likeActivityIndicator.startAnimating()
        
        DispatchQueue.main.async {
            if (!self.likeButton.isSelected) {
                _ = Just.delete(self.post!.likeFromCurrentUser!.url.absoluteString, params: ["uuid": UIDevice().uuid])
            }
            else if (self.likeButton.isSelected) {
                _ = Just.post("https://\(NBClient.shared.baseUrl)/api/v1.0/likes", params: ["uuid": UIDevice().uuid], data: ["_parent": "\(self.post!.url.absoluteString)"])
            }
            self.post!.updateLikes()
            self.updatePostText()
            
            self.postLikes.showViewAnimated(true)
            self.likeActivityIndicator.showViewAnimated(false)
            self.likeActivityIndicator.stopAnimating()
        }
    }
    
    @IBAction func commentButtonPressed() {
        
    }

    @IBAction func likeButtonPressed() {
        
    }
    
    func updateLikeButton(animated: Bool) {
        self.likeButton.setSelected(selected: self.post!.likedByCurrentUser!, animated: animated)
    }
    
    func updatePostText() {
        self.postLikes.text = ("\(self.post!.postLikes?.count ?? 0)")
        self.postComments.text = ("\(self.post!.postComments?.count ?? 0)")
    }
    
    
    
}
