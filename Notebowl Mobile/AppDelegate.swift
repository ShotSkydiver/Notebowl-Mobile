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
        
        // #if DEBUG
        
        FeedbackSlack.setup("xoxb-342245113713-XuL04z8fKmrwO5QXCBHQgWCi", slackChannel: "#dev-mobile-feedback", subjects: [
            "Bug",
            "Question",
            "Looks good!"
            ])
 
        // #else
        // #endif
 
        UNUserNotificationCenter.current().delegate = self
        let defaults = UserDefaults.standard
        defaults.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
        
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
        
        //let alert = UIAlertController(title: "Token", message: "\(token)", preferredStyle: .alert)
        //alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        let reqNotif = Just.get("https://\(NBClient.baseUrl)/gateway/services/mobile/notifications/enable", params: ["uuid": UIDevice().uuid, "token": token])
        TTLog.debug("notif register: ", reqNotif)
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
        TTLog.debug("enter foreground!")
        NBSocket.shared.manager.connect()
        let formatter = DateFormatter.iso8061
        let dateString = formatter.string(from: self.disconnectDate)
        var reconnectUrl: URL { return  (URL(string: ("https://\(NBClient.baseUrl)/rpc/v1.0/operations/reconnect"))?.appendingQueryParameters(["since": dateString,"uuid": UIDevice().uuid]))!}
        let recReq = Just.get(reconnectUrl)
        let nestedData = try? JSONSerialization.data(withJSONObject: (recReq.json as AnyObject).value(forKeyPath: "result")!)
        let result = Mapper<Generic>().mapArray(JSONString: String(data: nestedData!, encoding: .utf8)!)
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
