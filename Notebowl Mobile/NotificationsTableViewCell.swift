//
//  NotificationsTableViewCell.swift
//  Notebowl Mobile
//
//  Created by Conner Owen on 2/14/18.
//  Copyright © 2018 Notebowl. All rights reserved.
//

import Foundation
import UIKit

class NotificationsTableViewCell: UITableViewCell {

    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var notificationContent: UILabel!
    @IBOutlet weak var notificationDate: UILabel!
    
    var notification: Notification?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.userAvatar.layer.cornerRadius = 3.0
        self.userAvatar.clipsToBounds = true
        self.userAvatar.layer.masksToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateReadStatus() {
        DispatchQueue.main.async {
            if (!self.notification!.statusBool) {
                self.backgroundColor = #colorLiteral(red: 0.9294117647, green: 0.9529411765, blue: 0.9803921569, alpha: 1)
            }
            else if (self.notification!.statusBool) {
                self.backgroundColor = UIColor.white
            }
        }
    }
    
    
}
