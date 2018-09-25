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
import Siren

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var disconnectDate: Date!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if Config.isDebug { TTLog.testing("uuid: ", "\(UIDevice().uuid)") }
        
        UNUserNotificationCenter.current().delegate = self
        application.registerForRemoteNotifications()
        
        setupUserDefaults()
        setupLibraries()
        
        return true
    }
    
    func setupUserDefaults() {
        let defaults = UserDefaults.standard
        if defaults.object(forKey: UserDefaults.Keys.HasUserLoggedIn) == nil {
            UserDefaults.set(hasUserLoggedIn: false)
        }
    }
    
    func setupLibraries() {
        Bugsnag.start(withApiKey: "572ce3fbfa0c590dcfbc69519080d42e")
        
        let siren = Siren.shared
        if Config.appConfiguration == .Debug { siren.debugEnabled = true }
        siren.alertType = .force
        siren.majorUpdateAlertType = .force
        siren.minorUpdateAlertType = .force
        siren.patchUpdateAlertType = .option
        siren.revisionUpdateAlertType = .option
        siren.forceLanguageLocalization = .english
        
        if Config.appConfiguration == .TestFlight || Config.appConfiguration == .Debug { _ = FeedbackSlack.setup("xoxb-342245113713-XuL04z8fKmrwO5QXCBHQgWCi", slackChannel: "#dev-mobile-feedback", subjects: ["Bug","Question","Looks good!"]) }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        let token = tokenParts.joined()
        TTLog.debug("Device Token: \(token)")
        _ = NBNetworking.shared.request(url: RequestKind.mobile.requestUrl(url: "notifications/enable"), params: ["token": token, "uuid": UIDevice().uuid])
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        TTLog.debug("fail ", error.localizedDescription)
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        let aps = userInfo["aps"] as! [String: AnyObject]
        TTLog.debug("aps fg: ", aps)
    }
    
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        Siren.shared.checkVersion(checkType: .daily)
    }
    
    func applicationWillResignActive(_ application: UIApplication) { }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        if NBSocket.shared.manager.status == .connected {
            NBSocket.shared.manager.disconnect()
            disconnectDate = Date()
        }
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        Siren.shared.checkVersion(checkType: .immediately)

        guard let tabbarVC = UIApplication.shared.keyWindow?.rootViewController!.presentedViewController as? MainTabBarViewController else { return }
        
        if NBSocket.shared.manager.status == .disconnected {
            NBSocket.shared.manager.connect()
            let formatter = DateFormatter.iso8061
            let dateString = formatter.string(from: self.disconnectDate)
            let recReq = NBNetworking.shared.request(url: RequestKind.rpc.requestUrl(url: "operations/reconnect"), params: ["since": dateString])
 
            guard let keyPaths = (recReq.json as AnyObject).value(forKeyPath: "result")! as? [String] else { return }
            if keyPaths.isEmpty || keyPaths.count == 0 { return }
            
            var doAppReset: Bool = false
            let enrollments = keyPaths.filter( {$0.contains("enrollment")} )
            if !enrollments.isEmpty || enrollments.count > 0 {
                var possibleNewEnrollments: [String] = []

                if NBClient.shared.storedTypes[Enrollment.classIdentifier] != nil {
                    let cachedEnrollments = (NBClient.shared.storedTypes[Enrollment.classIdentifier]! as! [Enrollment]).filter({ $0.user == NBClient.shared.getCurrentUser() })
                    for socketResponse in enrollments {
                        if cachedEnrollments.contains(where: { socketResponse.contains($0.resourceKey) }) {
                            if socketResponse.contains("deleted") {
                                NBClient.shared.resetApp(andLogoutUser: false)
                                return
                            }
                        }
                        else if socketResponse.contains("updated") {
                            let otherUsersCachedEnrollments = (NBClient.shared.storedTypes[Enrollment.classIdentifier]! as! [Enrollment]).filter({ $0.user != NBClient.shared.getCurrentUser() })
                            if !otherUsersCachedEnrollments.contains(where: { socketResponse.contains($0.resourceKey) }) {
                                doAppReset = true
                                possibleNewEnrollments.append(socketResponse)
                            }
                        }
                    }
                }
                else {
                    doAppReset = true
                }
                
                if !possibleNewEnrollments.isEmpty {
                    var objectsToUpdate: [NBModel] = []
                    for enrollment in possibleNewEnrollments {
                        guard let contentData = enrollment.data(using: String.Encoding.utf8, allowLossyConversion: true) else { return }
                        let JSON = try! JSONSerialization.jsonObject(with: contentData, options: .mutableContainers) as! [String : AnyObject]
                        guard let updateUrlString = (JSON["updateUrl"] as? String) else { return }
                        let mapped = Mapper<Generic>().map(JSON: ["itemType":"\(ItemType.fromURL(updateUrlString))", "updateUrl":"\(updateUrlString)", "action":"\((JSON["action"] as! String))", "updatedAt":"\((JSON["updatedAt"] as! String))"])
                        guard let object = mapped!.genericObject else { return }
                        
                        objectsToUpdate.append(object)
                    }
                    if !objectsToUpdate.contains(where: { ($0 as! Enrollment).user == NBClient.shared.getCurrentUser() }) {
                        doAppReset = false
                    }
                }
                
                if doAppReset {
                    NBClient.shared.resetApp(andLogoutUser: false)
                    return
                }
            }
            
            do {
                for result in keyPaths {
                    guard let contentData = result.data(using: String.Encoding.utf8, allowLossyConversion: true) else { return }
                    let JSON = try JSONSerialization.jsonObject(with: contentData, options: .mutableContainers) as! [String : AnyObject]
                    guard let updateUrlString = (JSON["updateUrl"] as? String) else { return }
                    let mapped = Mapper<Generic>().map(JSON: ["itemType":"\(ItemType.fromURL(updateUrlString))", "updateUrl":"\(updateUrlString)", "action":"\((JSON["action"] as! String))", "updatedAt":"\((JSON["updatedAt"] as! String))"])
                    guard let object = mapped!.genericObject else { return }
 
                    if ["Enrollment","CourseUser","GroupUser"].contains(object.itemType.capitalised) {
                        if (object as! Enrollment).user.resourceKey != NBClient.shared.getCurrentUser().resourceKey {
                            TTLog.debug("ignore")
                            continue
                        }
                    }
                    
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
                                        continue
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
