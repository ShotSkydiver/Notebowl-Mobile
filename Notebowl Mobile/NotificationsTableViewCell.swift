//
//  NotificationsTableViewCell.swift
//  Notebowl Mobile
//
//  Created by Conner Owen on 2/14/18.
//  Copyright © 2018 Notebowl. All rights reserved.
//

import Foundation
import UIKit

@available(iOS 11.0, *)
class NotificationsTableViewCell: UITableViewCell {

    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var notificationContent: UILabel!
    @IBOutlet weak var notificationDate: UILabel!
    
    var notification: Notification?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.userAvatar.layer.cornerRadius = self.userAvatar.frame.size.height*0.5
        self.userAvatar.clipsToBounds = true
        self.userAvatar.layer.masksToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateReadStatus() {
        DispatchQueue.main.async {
            if (!self.notification!.statusBool) {
                self.backgroundColor = UIColor(red: 59.0/255.0, green: 166.0/255.0, blue: 226.0/255.0, alpha: 0.1)
            }
            else if (self.notification!.statusBool) {
                self.backgroundColor = UIColor.white
            }
        }
    }
    
    
}
