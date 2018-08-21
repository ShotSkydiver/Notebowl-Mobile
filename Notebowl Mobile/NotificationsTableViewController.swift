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

class NotificationsTableViewController: UITableViewController, UpdateVC {
    var indexes: Paths = Paths()
    var notifications: [Notification]!
    var placeholderTableView: NotificationTableView?

    override func viewDidLoad() {
        super.viewDidLoad()
        placeholderTableView = tableView as? NotificationTableView
        placeholderTableView?.placeholderDelegate = self
        
        setupNavBar()
        TMGradientNavigationBar().setGradientColorOnNavigationBar(bar: (navigationController?.navigationBar)!, direction: .horizontal, startColor: #colorLiteral(red: 0.04705882353, green: 0.4823529412, blue: 0.7568627451, alpha: 1), endColor: #colorLiteral(red: 0.04705882353, green: 0.5294117647, blue: 0.3607843137, alpha: 1))
        
        reloadTable()
    }
    
    func reloadTable() {
        self.notifications = (NBClient.shared.storedTypes.has(key: Notification.classIdentifier) ? NBClient.shared.storedTypes[Notification.classIdentifier]! as! [Notification] : [])
        let unreadCount = self.notifications.filter({ $0.unseenBool == true })
        self.tabBarController?.tabBar.items![2].badgeValue = ( unreadCount.count == 0 ? nil : String(format: "%d", (unreadCount.count)) )
        placeholderTableView?.reloadData()
    }
    
    @IBAction func profileButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "segueNotifDeck", sender: nil)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         self.navigationController?.navigationBar.tintColor = UIColor.groupTableViewBackground
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !notifications.isEmpty { markAsSeen() }
    }
    
    func updateBadgeCount() {
        let unreadCount = self.notifications.filter({ $0.unseenBool == true })
        let countString = String(format: "%d", (unreadCount.count))
        self.tabBarController?.tabBar.items![2].badgeValue = ( unreadCount.count == 0 ? nil : (unreadCount.count > 99 ? ("99+") : countString) )
    }
    
    func markAsSeen() {
        _ = NBNetworking.shared.request(.post, url: RequestKind.rpc.requestUrl(url: "notifications/markAsSeen"))
        for notification in (NBClient.shared.storedTypes[Notification.classIdentifier]! as! [Notification]).filter({ $0.unseenBool == true }) {
            notification.status = "seen"
        }
        updateBadgeCount()
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
        let cell = NotificationsTableViewCell.dequeue(from: tableView)!
        let notification = self.notifications[indexPath.row]
        cell.configure(notification: notification)
        return cell
    }
}

extension NotificationsTableViewController {
    
    func handleUpdated(newObject: NBModel) {
        self.notifications = (NBClient.shared.storedTypes.has(key: Notification.classIdentifier) ? NBClient.shared.storedTypes[Notification.classIdentifier]! as! [Notification] : [])
        if let newNotification = newObject as? Notification {
            let indexOfNotification = self.notifications.index(of: newNotification)
            let existingNotification = tableView.numberOfRows(inSection: 0) < self.notifications.count ? false : true
            if tableView.cellForRow(at: IndexPath(row: 0, section: 0)) is PlaceholderTableViewCell { placeholderTableView?.showDefault() }
            else if existingNotification == false { tableView.insertRows(at: [IndexPath(row: indexOfNotification!, section: 0)], with: .left) }
            updateBadgeCount()
        }
    }
    
    func handleDeleted(deletedObject: NBModel) {
        if let deleteNotification = deletedObject as? Notification {
            let indexOfNotification = self.notifications.index(of: deleteNotification)
            self.notifications = (NBClient.shared.storedTypes.has(key: Notification.classIdentifier) ? NBClient.shared.storedTypes[Notification.classIdentifier]! as! [Notification] : [])
            if indexOfNotification != nil { tableView.deleteRows(at: [IndexPath(row: indexOfNotification!, section: 0)], with: .right) }
            if tableView.numberOfRows(inSection: 0) == 0 { placeholderTableView?.showNoResultsPlaceholder() }
            updateBadgeCount()
        }
    }
    
    func handleElapsed(elapsedObject: NBModel) { }
    func reloadTableViews() { }
}

extension NotificationsTableViewController: PlaceholderDelegate {
    func view(_ view: Any, actionButtonTappedFor placeholder: HGPlaceholders.Placeholder) {
        self.reloadTable()
    }
}

class NotificationTableView: TableView {
    override func customSetup() {
        placeholdersProvider = .makePlaceholdersProvider(from: .emptyNotifications)
    }
}
