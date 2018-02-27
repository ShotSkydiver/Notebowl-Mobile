//
//  RootViewController.swift
//  Notebowl Mobile
//
//  Created by Conner Owen on 2/27/18.
//  Copyright © 2018 Notebowl. All rights reserved.
//

import Foundation
import UIKit
import ProgressWebViewController

class RootViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("\n\nview appearing\n\n")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("\n\nview appeared\n\n")
        // let isUserLoggedIn = UserDefaults.standard.bool(forKey: "com.notebowl.standalone.userLoggedIn")
        
        if !(UserDefaults.hasUserLoggedIn) {
            print("hasuserloggedin false")
            self.presentLogin()
        }
            
        else if UserDefaults.hasUserLoggedIn {
            print("hasuserloggedin true")
            _ = NBClient.shared.getCurrentUser()
            
            self.presentMainTabView()

            // registerNotifications()
        }
    }
    
    
    func presentLogin() {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let onboarding = storyboard.instantiateViewController(withIdentifier: "progressViewLoginNavController") as! UINavigationController
        let progressWebVC = onboarding.topViewController as! ProgressWebViewController
        
        progressWebVC.url = URL(string: ("https://demo.nbstage.com/bulletin?returnUrl=" + UIDevice().deviceQuery))
        progressWebVC.userAgent = "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36"
        progressWebVC.websiteTitleInNavigationBar = false
        progressWebVC.navigationItem.title = "Notebowl Login"
        progressWebVC.tintColor = #colorLiteral(red: 0.2310000062, green: 0.6510000229, blue: 0.8859999776, alpha: 1)
        progressWebVC.doneBarButtonItemPosition = .none
        progressWebVC.toolbarItemTypes = [.flexibleSpace]
        progressWebVC.disableZoom = true
        progressWebVC.headers = ["browser": "in-app browser"]
        progressWebVC.delegate = self
        
        self.present(onboarding, animated: true) {
            print("present webview complete")
            
        }

    }

    
    func presentMainTabView() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBar = mainStoryboard.instantiateViewController(withIdentifier: "mainTabBarVC") as! MainTabBarViewController
        self.present(tabBar, animated: true) {
            let delegate = UIApplication.shared.delegate as! AppDelegate
            delegate.registerNotifications()
        }
    }
    
    func logoutUser() {
        // self.dismiss(animated: <#T##Bool#>, completion: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>)
    }
}


extension RootViewController: ProgressWebViewControllerDelegate {
    
    func progressWebViewController(_ controller: ProgressWebViewController, didFinish url: URL) {
        print("progresswebview didfinish: ", controller.url!.absoluteString)
        var components = URLComponents(url: controller.url!.absoluteURL, resolvingAgainstBaseURL: false)
        let pathComponents = components!.path
        if (pathComponents == "/gateway/services/mobile/register") {
            
            UserDefaults.set(hasUserLoggedIn: true)
            // NBClient.shared.registerNotificationsToken()
            controller.dismiss(animated: true, completion: nil)
            // }
            
            
            /*
             let delegate = UIApplication.shared.delegate as! AppDelegate
             delegate.finishedPresentingOnboarding()
             */
        }
    }
}
