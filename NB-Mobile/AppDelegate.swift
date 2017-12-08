//
//  AppDelegate.swift
//  NB-Mobile
//
//  Created by Conner Owen on 9/5/17.
//  Copyright © 2017 NoteBowl. All rights reserved.
//

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        let dictionary = NSDictionary(object: "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36", forKey: "UserAgent" as NSCopying)
        UserDefaults.standard.register(defaults: dictionary as! [String : Any])

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let splashViewController = storyboard.instantiateViewController(withIdentifier: "splashViewController")
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = splashViewController
        window?.makeKeyAndVisible()

        if (NBClient.shared.checkToken()) {
            print("user logged in already!")
            let user = NBClient.shared.getCurrentUser()
            print("user name: ", user?.name)
        }
        else {
            print("user not logged in!")
            let webVC = NBAuthViewController()

            splashViewController.present(webVC, animated: true, completion: nil)
        }
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {

    }

    func applicationDidEnterBackground(_ application: UIApplication) {

    }

    func applicationWillEnterForeground(_ application: UIApplication) {

    }

    func applicationDidBecomeActive(_ application: UIApplication) {

    }

    func applicationWillTerminate(_ application: UIApplication) {

    }

}

