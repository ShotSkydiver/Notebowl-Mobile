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

@available(iOS 11.0, *)
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
            _ = NBClient.shared.getMappable(Notification.self, sortBy: "updatedAt:desc", limit: "10") { result in
                self.notifications = NBClient.shared.initArray(from: result!)
                self.loadingView.showLoadView(false)
                self.tableView.reloadData()
            }
        }
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
        cell.userAvatar.image = notificationForCell.imageForUser
        
        if (!notificationForCell.statusBool) {
            cell.backgroundColor = UIColor(red: 59.0/255.0, green: 166.0/255.0, blue: 226.0/255.0, alpha: 0.1)
        }
        
        cell.showCell(true)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        DispatchQueue.main.async(execute: {
            (cell as! NotificationsTableViewCell).updateReadStatus()
        })
    }
}


