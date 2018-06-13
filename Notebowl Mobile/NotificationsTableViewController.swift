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

class NotificationsTableViewController: UITableViewController, PlaceholderDelegate, UpdateVC {
    var indexes: Paths = Paths()
    var notifications: [Notification]!
    var placeholderTableView: TableView?

    override func viewDidLoad() {
        super.viewDidLoad()

        placeholderTableView = tableView as? TableView
        placeholderTableView?.placeholderDelegate = self
        
        self.notifications = NBClient.shared.storedTypes[Notification.classIdentifier] as! [Notification]
        let unreadCount = self.notifications.filter({ $0.unseenBool == true })
        self.tabBarController?.tabBar.items![2].badgeValue = ( unreadCount.count == 0 ? nil : String(format: "%d", (unreadCount.count)) )
        
        setupNavBar()
        TMGradientNavigationBar().setGradientColorOnNavigationBar(bar: (navigationController?.navigationBar)!, direction: .horizontal, startColor: #colorLiteral(red: 0.2310000062, green: 0.6510000229, blue: 0.8859999776, alpha: 1), endColor: #colorLiteral(red: 0.3249999881, green: 0.7139999866, blue: 0.4350000024, alpha: 1))
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //markAsSeen()
    }
    
    func markAsSeen() {
        NBNetworking.shared.request(.post, url: RequestKind.rpc.requestUrl(url: "notifications/markAsSeen"))
        for notification in (NBClient.shared.storedTypes[Notification.classIdentifier]! as! [Notification]).filter({ $0.unseenBool == true }) {
            notification.status = "seen"
        }
    }

    func view(_ view: Any, actionButtonTappedFor placeholder: HGPlaceholders.Placeholder) {
        placeholderTableView?.showDefault()
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
        cell.notificationDate.text = notificationForCell.createdAt.relativelyFormatted
        cell.userAvatar.kf.indicatorType = .activity
        cell.userAvatar.kf.setImage(with: notificationForCell.getUrlForAvatar()!.absoluteURL, placeholder: nil, options: [.transition(ImageTransition.fade(0.3))], completionHandler: { (image, error, cacheType, URL) in
            cell.setNeedsLayout()
        })
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as! NotificationsTableViewCell).updateReadStatus()
    }
}

extension NotificationsTableViewController {
    
    func handleUpdated(newObject: NBModel) {
        self.notifications = NBClient.shared.storedTypes[Notification.classIdentifier]! as! [Notification]
        if newObject.itemType == "Notification" {
            let indexOfNotification = self.notifications.index(where: { $0.resourceKey == newObject.resourceKey })
            indexOfNotification == nil ? indexes.insertIndexPaths.append(IndexPath(row: 0, section: 0)) : indexes.reloadIndexPaths.append(IndexPath(row: indexOfNotification!, section: 0))
            let unreadCount = self.notifications.filter({ $0.unseenBool == true })
            self.tabBarController?.tabBar.items![2].badgeValue = ( unreadCount.count == 0 ? nil : String(format: "%d", (unreadCount.count)) )
        }
        
    }
    
    func handleDeleted(deletedObject: NBModel) {
        self.notifications = NBClient.shared.storedTypes[Notification.classIdentifier]! as! [Notification]
        if deletedObject.itemType == "Notification" {
            let indexOfNotification = self.notifications.index(where: { $0.resourceKey == deletedObject.resourceKey })
            if indexOfNotification != nil { indexes.deleteIndexPaths.append(IndexPath(row: indexOfNotification!, section: 0)) }
            let unreadCount = self.notifications.filter({ $0.unseenBool == true })
            self.tabBarController?.tabBar.items![2].badgeValue = ( unreadCount.count == 0 ? nil : String(format: "%d", (unreadCount.count)) )
        }
    }
    
    func handleElapsed(elapsedObject: NBModel) {
        
    }
    
    func reloadTableViews() {

    }
}

class NotificationTableView: TableView {
    override func customSetup() {
        placeholdersProvider = .notifsPlaceholders
    }
}
