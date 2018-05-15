//
//  AppDelegate.swift
//  Notebowl Mobile
//
//  Created by Conner Owen on 9/5/17.
//  Copyright © 2017 NoteBowl. All rights reserved.
//

import UIKit
import UserNotifications
import Bugsnag
import FeedbackSlack
import Tamamushi
import ObjectMapper

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var disconnectDate: Date!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        var isAppStore: Bool = false
            switch (Config.appConfiguration) {
            case .Debug:
                isAppStore = false
            case .TestFlight:
                isAppStore = false
            case .AppStore:
                isAppStore = true
            }
        if !isAppStore {
            TTLog.debug("not appstore!")
            FeedbackSlack.setup("xoxb-342245113713-XuL04z8fKmrwO5QXCBHQgWCi", slackChannel: "#dev-mobile-feedback", subjects: [
                "Bug",
                "Question",
                "Looks good!"
                ])
        }
 
        UNUserNotificationCenter.current().delegate = self
        let defaults = UserDefaults.standard
        // defaults.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
        
        if defaults.object(forKey: UserDefaults.Keys.HasUserLoggedIn) == nil {
            UserDefaults.set(hasUserLoggedIn: false)
        }
        return true
    }

    func startBugsnag(user: User) {
        let bugConfig = BugsnagConfiguration()
        bugConfig.apiKey = "572ce3fbfa0c590dcfbc69519080d42e"
        bugConfig.setUser(user.resourceKey, withName: user.fullName, andEmail: user.email!)
        Bugsnag.start(with: bugConfig)
    }
    
    func registerNotifications() {
        #if arch(i386) || arch(x86_64)
        TTLog.debug("is simulator!")
        return
        #endif
        
        if !(UIApplication.shared.isRegisteredForRemoteNotifications) {
            TTLog.debug("not registered!")
            
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { allow, error in
                if allow {
                    TTLog.debug("notifications allowed")
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        let token = tokenParts.joined()
        TTLog.debug("Device Token: \(token)")
        getUrl("notifications/enable", kind: .mobile, params: ["token": token]) {r in TTLog.debug("notif register: ", r) }
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        TTLog.debug("fail ", error.localizedDescription)
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        let aps = userInfo["aps"] as! [String: AnyObject]
        TTLog.debug("aps fg: ", aps)
 
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        TTLog.debug("didbecomeactive!")
        
    }
    func applicationWillResignActive(_ application: UIApplication) {
        TTLog.debug("resignactive!")
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        TTLog.debug("in background!")
        NBSocket.shared.manager.disconnect()
        disconnectDate = Date()
    }
    func applicationWillEnterForeground(_ application: UIApplication) {
        guard let tabbarVC = UIApplication.shared.keyWindow?.rootViewController!.presentedViewController as? MainTabBarViewController else {
            TTLog.debug("tabController is not presented!")
            return
        }
        
        NBSocket.shared.manager.connect()
        let formatter = DateFormatter.iso8061
        let dateString = formatter.string(from: self.disconnectDate)
        let recReq = getUrl("operations/reconnect", kind: .rpc, params: ["since": dateString])
        guard let reqData = recReq.content else { return }
        let JSON : [String:AnyObject] = try! JSONSerialization.jsonObject(with: reqData, options: .allowFragments) as! [String : AnyObject]
        let results: [String] = JSON["result"] as! [String]
        for result in results {
            let mapResult = Mapper<Generic>().map(JSONString: result)
            if let viewControllers = tabbarVC.viewControllers {
                for viewController in viewControllers {
                    let rootNavController = viewController as! UINavigationController
                    if let switchVC = rootNavController.topViewController as? UpdateVC {
                        TTLog.debug("found updateVC!")
                        switchVC.handleUpdate(mapped: mapResult!, updateUI: false)
                    }
                }
            }
        }
        if let homeVC = ((tabbarVC.viewControllers![0] as! UINavigationController).topViewController as? HomeFeedViewController) {
            homeVC.bulletinTableView.beginUpdates()
            homeVC.bulletinTableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
            homeVC.bulletinTableView.reloadSections(IndexSet(integer: 1), with: .automatic)
            homeVC.bulletinTableView.endUpdates()
        }
        else if let homeVC = ((tabbarVC.viewControllers![0] as! UINavigationController).topViewController as? HomeFeedPostViewController) {
            homeVC.tableView.beginUpdates()
            homeVC.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
            homeVC.tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
            homeVC.tableView.endUpdates()
        }
        if let courseVC = ((tabbarVC.viewControllers![1] as! UINavigationController).topViewController as? CoursesTableViewController) {
            courseVC.tableView.beginUpdates()
            // courseVC.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
            courseVC.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
            courseVC.tableView.endUpdates()
        }
        if let notifVC = ((tabbarVC.viewControllers![2] as! UINavigationController).topViewController as? NotificationsTableViewController) {
            notifVC.tableView.beginUpdates()
            // notifVC.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
            notifVC.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
            notifVC.tableView.endUpdates()
        }
    }
    
    
    func applicationWillTerminate(_ application: UIApplication) {
        TTLog.debug("will terminate!")
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        TTLog.debug("willpresent ", userInfo)
        
        completionHandler([.alert])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // let aps = userInfo["aps"] as! [String: AnyObject]
        
        if response.actionIdentifier == "viewActionIdentifier" {
            TTLog.debug("view action")
        }

        completionHandler()
    }
}
