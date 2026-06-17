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
        siren.rulesManager = RulesManager(majorUpdateRules: .critical, minorUpdateRules: .annoying, patchUpdateRules: .default, revisionUpdateRules: .relaxed)
        siren.wail { (results, error) in
            if let error = error, error.localizedDescription != KnownError.noUpdateAvailable.localizedDescription {
                Bugsnag.notifyError(error)
            }
        }
    }

    func setupLibraries() {
        Bugsnag.start(withApiKey: "xxxxxxxxxxxxxxxxxxxxxxxxxx")

        if Config.appConfiguration == .TestFlight || Config.appConfiguration == .Debug { _ = FeedbackSlack.setup("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx", slackChannel: "#dev-mobile-feedback", subjects: ["Bug", "Question", "Looks good!"]) }

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
        Bugsnag.notifyError(error)
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
        if NBSocket.shared.manager.status == .disconnected {
            NBSocket.shared.manager.connect()
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {}
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let _ = notification.request.content.userInfo
        completionHandler([.alert])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        _ = response.notification.request.content.userInfo
        completionHandler()
    }
}
