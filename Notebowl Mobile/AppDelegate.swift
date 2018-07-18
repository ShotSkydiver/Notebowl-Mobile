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
import SocketIO

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var disconnectDate: Date!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        var isAppStore: Bool = false
            switch (Config.appConfiguration) {
            case .Debug:
                TTLog.debug("is debug!")
                isAppStore = false
            case .TestFlight:
                isAppStore = false
            case .AppStore:
                isAppStore = true
            }
        
        if !isAppStore {
            TTLog.debug("not appstore!")
            /*
            _ = FeedbackSlack.setup("xoxb-342245113713-XuL04z8fKmrwO5QXCBHQgWCi", slackChannel: "#dev-mobile-feedback", subjects: [
                "Bug",
                "Question",
                "Looks good!"
                ])
            */
        }
        
        Bugsnag.start(withApiKey: "572ce3fbfa0c590dcfbc69519080d42e")
 
        UNUserNotificationCenter.current().delegate = self
        let defaults = UserDefaults.standard
        if defaults.object(forKey: UserDefaults.Keys.HasUserLoggedIn) == nil {
            UserDefaults.set(hasUserLoggedIn: false)
        }
        return true
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
        _ = NBNetworking.shared.request(url: RequestKind.mobile.requestUrl(url: "notifications/enable"), params: ["token": token])
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
        if NBSocket.shared.manager.status == .connected {
            NBSocket.shared.manager.disconnect()
            disconnectDate = Date()
        }
        
    }
    func applicationWillEnterForeground(_ application: UIApplication) {
        guard let tabbarVC = UIApplication.shared.keyWindow?.rootViewController!.presentedViewController as? MainTabBarViewController else {
            TTLog.debug("tabController is not presented!")
            return
        }
        if NBSocket.shared.manager.status == .disconnected {
            
            NBSocket.shared.manager.connect()
            let formatter = DateFormatter.iso8061
            let dateString = formatter.string(from: self.disconnectDate)
            let recReq = NBNetworking.shared.request(url: RequestKind.rpc.requestUrl(url: "operations/reconnect"), params: ["since": dateString])
 
            guard let keyPaths = (recReq.json as AnyObject).value(forKeyPath: "result")! as? [String] else { return }
            do {
                if keyPaths.isEmpty || keyPaths.count == 0 { return }
                for result in keyPaths {
                    guard let contentData = result.data(using: String.Encoding.utf8, allowLossyConversion: true) else { return }
                    let JSON = try JSONSerialization.jsonObject(with: contentData, options: .mutableContainers) as! [String : AnyObject]
                    guard let updateUrlString = (JSON["updateUrl"] as? String) else { return }
 
                    let mapped = Mapper<Generic>().map(JSON: ["itemType":"\(ItemType.fromURL(updateUrlString))", "updateUrl":"\(updateUrlString)", "action":"\((JSON["action"] as! String))", "updatedAt":"\((JSON["updatedAt"] as! String))"])
                    
                    guard let object = mapped!.genericObject else { return }
                    if let viewControllers = tabbarVC.viewControllers {
                        for viewController in viewControllers {
                            let rootNavController = viewController as! UINavigationController
                            for vc in rootNavController.viewControllers {
                                if let switchVC = vc as? UpdateVC {
                                    switch mapped!.action {
                                    case .updated:
                                        switchVC.handleUpdated(newObject: object)
                                    case .deleted:
                                        switchVC.handleDeleted(deletedObject: object)
                                    case .elapsed:
                                        switchVC.handleElapsed(elapsedObject: object)
                                    default:
                                        TTLog.error("unknown actiontype!")
                                        return
                                    }
                                }
                            }
                        }
                    }
                }
            }
            catch let error {
                print("Error parsing json: \(error)")
            }
        
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
        _ = response.notification.request.content.userInfo
        
        if response.actionIdentifier == "viewActionIdentifier" {
            TTLog.debug("view action")
        }
        completionHandler()
    }
}
