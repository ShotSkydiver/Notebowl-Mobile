//
//  NotificationsTableViewCell.swift
//  Notebowl Mobile
//
//  Created by Conner Owen on 2/14/18.
//  Copyright © 2018 Notebowl. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class NotificationsTableViewCell: UITableViewCell {

    @IBOutlet weak var userAvatar: ProfileImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var notificationContent: UILabel!
    @IBOutlet weak var notificationDate: UILabel!
    
    var notificationForCell: Notification!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initSetup()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        initSetup()
    }
    
    func initSetup() {
        
        
    }
    
    func configure(notification: Notification) {
        notificationContent.text = notification.text
        notificationDate.text = notification.createdAt.relativeFormat

        let userProfile = notification.userProfilePicURL

        userAvatar.kf.setImage(with: userProfile,
                                    options: [
                                        .transition(ImageTransition.fade(0.3)),
                                        .onlyLoadFirstFrame,
                                        .keepCurrentImageWhileLoading
            ]
        )
        
        self.backgroundColor = (notification.unreadBool ? #colorLiteral(red: 0.9294117647, green: 0.9529411765, blue: 0.9803921569, alpha: 1) : UIColor.white)
        
        self.notificationForCell = notification
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}


extension NotificationsTableViewCell {
    static var reuseId: String {
        return "notificationCell"
    }

    class func dequeue(from tableView: UITableView) -> NotificationsTableViewCell? {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseId)
        return cell as? NotificationsTableViewCell
    }
}
