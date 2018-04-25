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
import HGPlaceholders
import QuartzCore
import Tamamushi

class NotificationsTableViewController: UITableViewController, PlaceholderDelegate {
    var notifications: [Notification]!
    var loadingView: NBLoadingView!
    var bgView: UIView!
    var placeholderTableView: TableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadingView = NBLoadingView()
        self.bgView = UIView(loadingView: self.loadingView)
        self.view.addSubview(bgView)
        self.bgView.alpha = 0.0
        
        placeholderTableView = tableView as? TableView
        placeholderTableView?.placeholderDelegate = self
        
        setupNavBar()
        TMGradientNavigationBar().setGradientColorOnNavigationBar(bar: (navigationController?.navigationBar)!, direction: .horizontal, startColor: #colorLiteral(red: 0.2310000062, green: 0.6510000229, blue: 0.8859999776, alpha: 1), endColor: #colorLiteral(red: 0.3249999881, green: 0.7139999866, blue: 0.4350000024, alpha: 1))
        
        self.getNotifications()
    }
    
    func setupNavBar() {
        navigationController?.navigationBar.shadowImage = UIImage.init()
        
        navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
        navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        navigationController?.navigationBar.layer.shadowRadius = 7.5
        navigationController?.navigationBar.layer.shadowOpacity = 0.7
        navigationController?.navigationBar.layer.masksToBounds = false
        
        self.view.layer.masksToBounds = false
        
    }
    
    func getNotifications() {
        // self.loadingView.showLoadView(true)
        
        DispatchQueue.main.async {
            if self.notifications == nil {
                TTLog.error("this shouldn't be nil!")
                if NBClient.shared.storedTypes[Notification.classIdentifier]! != nil {
                    self.notifications = NBClient.shared.storedTypes[Notification.classIdentifier]! as! [Notification]
                }
                else {
                    TTLog.error("courses stored cache is nil!")
                    
                }
            }
            
            
            if (self.notifications.isEmpty) { self.loadingView.alpha = 0.0 }
            /*
            var unreadCount = 0
            for notification in self.notifications {
                if !notification.statusBool {
                    unreadCount = unreadCount + 1
                }
            }
            if unreadCount > 0 {
                self.tabBarController?.tabBar.items?[2].badgeValue = String(format: "%d", unreadCount)
            }
            */
            
            // self.notifications.sort() { $0.secondsSinceUpdate > $1.secondsSinceUpdate }
            
            self.tableView.reloadData()
            // self.bgView.showViewAnimated(false)
        }
    }
    
    func view(_ view: Any, actionButtonTappedFor placeholder: HGPlaceholders.Placeholder) {
        placeholderTableView?.showDefault()
        
        self.getNotifications()
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

class NotificationTableView: TableView {
    override func customSetup() {
        placeholdersProvider = .notifsPlaceholders
    }
}
