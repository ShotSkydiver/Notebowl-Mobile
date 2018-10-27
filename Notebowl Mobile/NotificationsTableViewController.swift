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
import SocketIO

class NotificationsTableViewController: UITableViewController, UpdateVC {
    var indexes: Paths = Paths()
    var notifications: [Notification]!
    var placeholderTableView: NotificationTableView?

    override func viewDidLoad() {
        super.viewDidLoad()
        placeholderTableView = tableView as? NotificationTableView
        placeholderTableView?.placeholderDelegate = self
        TMGradientNavigationBar().setGradientColorOnNavigationBar(bar: (navigationController?.navigationBar)!, direction: .horizontal, startColor: #colorLiteral(red: 0.04705882353, green: 0.4823529412, blue: 0.7568627451, alpha: 1), endColor: #colorLiteral(red: 0.04705882353, green: 0.5294117647, blue: 0.3607843137, alpha: 1), startPoint: CGPoint(x: 0.0, y: 0.4), endPoint: CGPoint(x: 0.8, y: 0.7))
        self.navigationController?.view.backgroundColor = UIColor.white
        reloadTable()
    }
    
    func reloadTable() {
        self.notifications = (NBClient.shared.storedTypes.has(key: Notification.classIdentifier) ? NBClient.shared.storedTypes[Notification.classIdentifier]! as! [Notification] : [])
        let unreadCount = self.notifications.filter({ $0.unseenBool == true })
        self.tabBarController?.tabBar.items![2].badgeValue = ( unreadCount.count == 0 ? nil : String(format: "%d", (unreadCount.count)) )
        placeholderTableView?.reloadData()
    }
    
    @IBAction func profileButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "segueDeck", sender: nil)
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

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         self.navigationController?.navigationBar.tintColor = UIColor.groupTableViewBackground
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !notifications.isEmpty && notifications.contains(where: {$0.unseenBool == true }) { markAsSeen() }
    }
    
    func updateBadgeCount() {
        if let tabbarVC = UIApplication.shared.keyWindow?.rootViewController!.presentedViewController as? MainTabBarViewController {
            if (tabbarVC.selectedViewController as! UINavigationController).topViewController is NotificationsTableViewController {
                for notif in self.notifications {
                    if notif.unseenBool {
                        notif.status = "seen"
                        _ = NBNetworking.shared.request(.put, url: notif.url.absoluteString, json: ["status": "seen"])
                    }
                }
                return
            }

            else {
                let unreadCount = self.notifications.filter({ $0.unseenBool == true })
                let countString = String(format: "%d", (unreadCount.count))
                self.tabBarController?.tabBar.items![2].badgeValue = ( unreadCount.count == 0 ? nil : (unreadCount.count > 99 ? ("99+") : countString) )
                return
            }
        }
    }
    
    func markAsSeen() {
        let markSeen = NBNetworking.shared.request(.post, url: RequestKind.rpc.requestUrl(url: "notifications/markAsSeen"),
                                                   loadImmediately: false,
                                                   asyncCompletionHandler: { r in
                                                    NBClient.shared.delay(1.0) {
                                                        if let jsonObject = r.json as AnyObject?, let nestedJson = jsonObject.value(forKeyPath: "result"), let nestedResults = nestedJson as? [[String: Any]] {
                                                            let mapped = Mapper<Notification>().mapArray(JSONArray: nestedResults)
                                                            let updatedNotifs = NBClient.shared.storeObjectsInCache(mapped)
                                                            self.notifications = (NBClient.shared.storedTypes[Notification.classIdentifier] as! [Notification])
                                                            self.tabBarController?.tabBar.items![2].badgeValue = nil
                                                        }
                                                    }
        })
        markSeen.task?.resume()
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
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
        if let newNotification = newObject as? Notification, NBClient.shared.storedTypes.has(key: Notification.classIdentifier) {
            self.notifications = NBClient.shared.storedTypes[Notification.classIdentifier]! as! [Notification]
            let indexOfNotification = self.notifications.index(of: newNotification)
            let existingNotification = tableView.numberOfRows(inSection: 0) < self.notifications.count ? false : true

            if tableView.cellForRow(at: IndexPath(row: 0, section: 0)) is PlaceholderTableViewCell { placeholderTableView?.showDefault() }

            else if existingNotification == false {
                tableView.insertRows(at: [IndexPath(row: indexOfNotification!, section: 0)], with: .left)
                updateBadgeCount()
            }
            else {
                tableView.reloadRows(at: [IndexPath(row: indexOfNotification!, section: 0)], with: .fade)
            }
        }
    }
    
    func handleDeleted(deletedObject: NBModel) {
        if let deleteNotification = deletedObject as? Notification {
            let indexOfNotification = self.notifications.index(of: deleteNotification)
            self.notifications = NBClient.shared.storedTypes[Notification.classIdentifier]! as! [Notification]
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
