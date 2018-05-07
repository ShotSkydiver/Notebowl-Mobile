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
        
        registerHandler()
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
            self.tableView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        markAsSeen()
    }
    
    func markAsSeen() {
       _ = Just.post("https://\(NBClient.baseUrl)/rpc/v1.0/notifications/markAsSeen", params: ["uuid": UIDevice().uuid])

        for notification in (NBClient.shared.storedTypes[Notification.classIdentifier]! as! [Notification]).filter({ $0.unseenBool == true }) {
            notification.status = "seen"
        }
    }
    
    func handleUpdate(mapped: Generic, updateUI: Bool) {
        if mapped.itemType!.contains("Notification") {
            // let mappedNotif = mapped as! Response<Notification>
            NBClient.shared.storedTypes[Notification.classIdentifier]!.sort(by: { $0.secondsSinceCreation > $1.secondsSinceCreation } )
            self.notifications = NBClient.shared.storedTypes[Notification.classIdentifier]! as! [Notification]
            if updateUI {
                self.tableView.beginUpdates()
                self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
                self.tableView.endUpdates()
            }
            
            let unreadCount = self.notifications.filter({ $0.unseenBool == true })
            self.tabBarController?.tabBar.items![2].badgeValue = ( unreadCount.count == 0 ? nil : String(format: "%d", (unreadCount.count)) )
        }
    }
    
    func registerHandler() {
        NBSocket.shared.manager.defaultSocket.on(NBClient.shared.getCurrentUser().resourceKey) { (data, ackEmitter) in
            guard let message = data[0] as? String else { return }
            if let data = message.data(using: .utf8) {
                do {
                    let JSON = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String : AnyObject]
                    let mapped = Mapper<Generic>().map(JSON: JSON)!
                    
                    self.handleUpdate(mapped: mapped, updateUI: true)
                }
                catch let error {
                    print("Error parsing json: \(error)")
                }
            }
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
        cell.notificationDate.text = notificationForCell.createdAt.relativelyFormatted
 
        cell.userAvatar.kf.setImage(with: notificationForCell.userPictureUrl,
                                    options: [
                                        .fromMemoryCacheOrRefresh,
                                        .transition(ImageTransition.fade(0.3)),
                                        // .forceTransition,
                                        .keepCurrentImageWhileLoading
            ]
        )

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
