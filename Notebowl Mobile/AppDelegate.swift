//
//  AppDelegate.swift
//  Notebowl Mobile
//
//  Created by Conner Owen on 9/5/17.
//  Copyright © 2017 NoteBowl. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications
import Bugsnag
import FeedbackSlack
import Tamamushi
import ObjectMapper
import SocketIO
import Siren
import SwiftyBeaver
import Kingfisher

let log = SwiftyBeaver.self

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var disconnectDate: Date!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        setupLog()
        setupUserDefaults()
        setupLibraries()
        setupSiren()

        return true
    }

    func setupLog() {
        let console = ConsoleDestination()
        #if DEBUG
        console.asynchronously = false
        console.minLevel = .debug
        #else
        console.asynchronously = true
        console.minLevel = .warning
        #endif
        log.addDestination(console)
    }

    func setupUserDefaults() {
        let defaults = UserDefaults.standard
        if defaults.object(forKey: UserDefaults.Keys.HasUserLoggedIn) == nil {
            UserDefaults.set(hasUserLoggedIn: false)
        }
    }

    func setupSiren() {
        let siren = Siren.shared
        if Config.appConfiguration == .Debug { siren.debugEnabled = true }
        siren.rulesManager = RulesManager(majorUpdateRules: .critical, minorUpdateRules: .annoying, patchUpdateRules: .default, revisionUpdateRules: .relaxed)
        siren.wail { (results, error) in
            if let error = error {
                Bugsnag.notifyError(error)
            }
        }
    }

    func setupLibraries() {
        Bugsnag.start(withApiKey: "572ce3fbfa0c590dcfbc69519080d42e")

        if Config.appConfiguration == .TestFlight || Config.appConfiguration == .Debug { _ = FeedbackSlack.setup("xoxb-342245113713-XuL04z8fKmrwO5QXCBHQgWCi", slackChannel: "#dev-mobile-feedback", subjects: ["Bug", "Question", "Looks good!"]) }

        ImageDownloader.default.trustedHosts = Set(trustedHosts)
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        let token = tokenParts.joined()
        _ = NBNetworking.shared.request(url: RequestKind.mobile.requestUrl(url: "notifications/enable"), params: ["token": token, "uuid": UIDevice().uuid])
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        log.debug(error.localizedDescription)
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return true
    }

    func application(_ application: UIApplication, willContinueUserActivityWithType userActivityType: String) -> Bool {
        return true
    }

    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) { }
    func applicationWillResignActive(_ application: UIApplication) { }

    func applicationDidEnterBackground(_ application: UIApplication) {
        if NBSocket.shared.manager.status == .connected {
            NBSocket.shared.manager.disconnect()
            disconnectDate = Date()
        }
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        guard let tabbarVC = UIApplication.shared.keyWindow?.rootViewController!.presentedViewController as? MainTabBarViewController else { return }
        if NBSocket.shared.manager.status == .disconnected {
            NBSocket.shared.manager.connect()
            let formatter = DateFormatter.iso8061
            let dateString = formatter.string(from: self.disconnectDate)
            let recReq = NBNetworking.shared.request(url: RequestKind.rpc.requestUrl(url: "operations/reconnect"), params: ["since": dateString])

            guard let keyPaths = (recReq.json as AnyObject).value(forKeyPath: "result")! as? [String] else { return }
            if keyPaths.isEmpty || keyPaths.count == 0 { return }

            var doAppReset: Bool = false
            let enrollments = keyPaths.filter({$0.contains("enrollment")})
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
                        } else if socketResponse.contains("updated") {
                            let otherUsersCachedEnrollments = (NBClient.shared.storedTypes[Enrollment.classIdentifier]! as! [Enrollment]).filter({ $0.user != NBClient.shared.getCurrentUser() })
                            if !otherUsersCachedEnrollments.contains(where: { socketResponse.contains($0.resourceKey) }) {
                                doAppReset = true
                                possibleNewEnrollments.append(socketResponse)
                            }
                        }
                    }
                } else {
                    doAppReset = true
                }

                if !possibleNewEnrollments.isEmpty {
                    var objectsToUpdate: [NBModel] = []
                    for enrollment in possibleNewEnrollments {
                        guard let contentData = enrollment.data(using: String.Encoding.utf8, allowLossyConversion: true) else { return }
                        let JSON = try! JSONSerialization.jsonObject(with: contentData, options: .mutableContainers) as! [String: AnyObject]
                        guard let updateUrlString = (JSON["updateUrl"] as? String), let itemType = ItemType.fromURL(updateUrlString) else { return }

                        let mapped = Mapper<Generic>().map(JSON: ["itemType": "\(itemType)", "updateUrl": "\(updateUrlString)", "action": "\((JSON["action"] as! String))", "updatedAt": "\((JSON["updatedAt"] as! String))"])
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
                    let JSON = try JSONSerialization.jsonObject(with: contentData, options: .mutableContainers) as! [String: AnyObject]
                    guard let updateUrlString = (JSON["updateUrl"] as? String), let itemType = ItemType.fromURL(updateUrlString) else { return }
                    let mapped = Mapper<Generic>().map(JSON: ["itemType": "\(itemType)", "updateUrl": "\(updateUrlString)", "action": "\((JSON["action"] as! String))", "updatedAt": "\((JSON["updatedAt"] as! String))"])
                    guard let object = mapped!.genericObject else { return }
                    if ["Enrollment", "CourseUser", "GroupUser"].contains(object.itemType.className) {
                        if (object as! Enrollment).user.resourceKey != NBClient.shared.getCurrentUser().resourceKey {
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
            } catch let error {
                print("Error parsing json: \(error)")
            }
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        log.debug("will terminate!")
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let _ = notification.request.content.userInfo
        completionHandler([.alert])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        _ = response.notification.request.content.userInfo

        if response.actionIdentifier == "viewActionIdentifier" {
            log.debug("view action")
        }
        completionHandler()
    }
}
