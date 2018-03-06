//
//  NotificationsTableViewController.swift
//  Notebowl Mobile
//
//  Created by Conner Owen on 2/14/18.
//  Copyright © 2018 Notebowl. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper
import Kingfisher

class NotificationsTableViewController: UITableViewController {
    var notifications: [Notification]!
    var loadingView: NBLoadingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tempLoadingViewSetup()
        self.getNotifications()
    }
    
    func tempLoadingViewSetup() {
        self.loadingView = NBLoadingView()
        self.view.addSubview(self.loadingView)
        self.loadingView.addUntitled2Animation()
    }
    
    func getNotifications() {
        self.loadingView.showLoadView(true)
        
        DispatchQueue.main.async {
            self.notifications = NBClient.shared.getMappable(Notification.self, filters: "[\"text:IS_NULL:false\"]", sortBy: "updatedAt:desc", limit: "10")
            
            var unreadCount = 0
            for notification in self.notifications {
                if !notification.statusBool {
                    unreadCount = unreadCount + 1
                }
            }
            if unreadCount > 0 {
                self.tabBarController?.tabBar.items?[2].badgeValue = String(format: "%d", unreadCount)
            }
            self.notifications.sort() { $0.secondsSinceUpdate > $1.secondsSinceUpdate }
            self.loadingView.showLoadView(false)
            self.tableView.reloadData()
            
        }
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.notifications) != nil {
            return self.notifications.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notificationCell", for: indexPath) as! NotificationsTableViewCell
        
        let notificationForCell = self.notifications[indexPath.row]
        cell.notification = notificationForCell
        
        cell.notificationContent.text = notificationForCell.text
        cell.notificationDate.text = notificationForCell.updatedAt.relativelyFormatted
        
        let placeholderimg = UIImage(named: "Default Avatar")
        cell.userAvatar.kf.setImage(with: notificationForCell.getUrlForAvatar(), placeholder: placeholderimg, options: [.transition(.fade(0.3))])

        cell.showCell(true)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as! NotificationsTableViewCell).updateReadStatus()
    }
}


