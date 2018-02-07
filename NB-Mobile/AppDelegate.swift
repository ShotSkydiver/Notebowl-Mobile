//
//  AppDelegate.swift
//  NB-Mobile
//
//  Created by Conner Owen on 9/5/17.
//  Copyright © 2017 NoteBowl. All rights reserved.
//

import UIKit
import UserNotifications


@available(iOS 11.0, *)
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var initialRootController: UIViewController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        let defaults = UserDefaults.standard
        
        if let prefsFile = Bundle.main.url(forResource: "DefaultPreferences", withExtension: "plist"),
            let prefsDict = NSDictionary(contentsOf: prefsFile) as? [String: Any] {
            defaults.register(defaults: prefsDict)
        }
        
        let isUserLoggedIn = defaults.bool(forKey: "com.notebowl.standalone.userLoggedIn")
        
        if !isUserLoggedIn {
            self.presentLogin()
        }
        else if (isUserLoggedIn) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (_, _) in }
            application.registerForRemoteNotifications()
        }
        
        return true
    }

    func presentLogin() {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let onboarding = storyboard.instantiateViewController(withIdentifier: "initialLoginController") as! WebViewPresentingController
        self.initialRootController = self.window?.rootViewController
        self.window?.rootViewController = onboarding
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (_, _) in }
        UIApplication.shared.registerForRemoteNotifications()
    }
    func finishedPresentingOnboarding() {
        self.window?.rootViewController = initialRootController
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        let token = tokenParts.joined()
        print("Device Token: \(token)")
        
        NBClient.shared.deviceToken = token
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("fail ", error.localizedDescription)
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        let aps = userInfo["aps"] as! [String: AnyObject]
        print("aps fg: ", aps)
 
    }
}

@available(iOS 11.0, *)
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        print("willpresent ", userInfo)
        
        completionHandler([.alert])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        let aps = userInfo["aps"] as! [String: AnyObject]
        
        if response.actionIdentifier == "viewActionIdentifier" {
            print("view action")
        }

        completionHandler()
    }
}
