//
//  HomeFeedTableViewCell.swift
//  NB-Mobile
//
//  Created by Conner Owen on 2/7/18.
//  Copyright © 2018 NoteBowl. All rights reserved.
//

import Foundation
import UIKit

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
    
    var post: Post?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.showCell(false)
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor(red: 59.0/255.0, green: 166.0/255.0, blue: 226.0/255.0, alpha: 0.2)
        self.selectedBackgroundView = selectedView
        
        self.userAvatar.layer.cornerRadius = self.userAvatar.frame.size.height*0.5
        self.userAvatar.clipsToBounds = true
        self.userAvatar.layer.masksToBounds = true
        
        self.updateCell()
        self.showCell(true)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateCell() {
        if (self.post != nil) {
            DispatchQueue.main.async {
                self.userName.text = self.post!._creator?.fullName
                self.userAvatar.image = UIImage(data: Just.get((self.post!._creator?.profileThumbUrl.absoluteString)!).content!)
                self.postContent.text = self.post!.text
                self.postedDate.text = self.post!.updatedAt.relativelyFormatted
                
                self.postLikes.text = ("\(self.post!.postLikes?.count ?? 0) Likes")
                self.postComments.text = ("\(self.post!.postComments?.count ?? 0) Comments")
                
                if (self.post!.likedByCurrentUser)! {
                    self.likeButton.setTitle("Liked", for: .normal)
                    self.likeButton.setBackgroundImage(UIImage().filled(withColor: UIColor(named: "Notebowl Blue")!), for: .normal)
                    self.likeButton.setTitleColor(UIColor.groupTableViewBackground, for: .normal)
                    
                }
            }
        }
    }
}
