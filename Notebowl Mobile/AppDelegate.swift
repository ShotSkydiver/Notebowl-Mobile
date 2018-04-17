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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FeedbackSlack.setup("xoxb-342245113713-XuL04z8fKmrwO5QXCBHQgWCi", slackChannel: "#dev-mobile-feedback", subjects: [
            "Bug",
            "Question",
            "Looks good!"
            ])
        UNUserNotificationCenter.current().delegate = self
        let defaults = UserDefaults.standard
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
        
        _ = Just.get("https://\(NBClient.shared.baseUrl)/gateway/services/mobile/notifications/enable", params: ["uuid": UIDevice().uuid, "token": token])
        
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        TTLog.debug("fail ", error.localizedDescription)
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        let aps = userInfo["aps"] as! [String: AnyObject]
        TTLog.debug("aps fg: ", aps)
 
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
