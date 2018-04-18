//
//  RootViewController.swift
//  Notebowl Mobile
//
//  Created by Conner Owen on 2/27/18.
//  Copyright © 2018 Notebowl. All rights reserved.
//

import Foundation
import UIKit
import Bugsnag
import SocketIO

class RootViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !(UserDefaults.hasUserLoggedIn) {
            self.performSegue(withIdentifier: "presentLoginView", sender: nil)
        }
            
        else if UserDefaults.hasUserLoggedIn {
            self.performSegue(withIdentifier: "presentTabBarView", sender: nil)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier! == "presentLoginView" {
            guard let webViewRootNavController = segue.destination as? UINavigationController, let progressWebVC = webViewRootNavController.topViewController as? ProgressWebViewController else {
                return
            }
            progressWebVC.url = URL(string: ("https://\(NBClient.shared.baseUrl)/bulletin?returnUrl=" + UIDevice().deviceQuery))
            progressWebVC.userAgent = "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36"
            progressWebVC.websiteTitleInNavigationBar = false
            progressWebVC.navigationItem.title = "Notebowl Login"
            progressWebVC.tintColor = #colorLiteral(red: 0.2310000062, green: 0.6510000229, blue: 0.8859999776, alpha: 1)
            progressWebVC.doneBarButtonItemPosition = .none
            progressWebVC.toolbarItemTypes = []
            progressWebVC.disableZoom = false
            progressWebVC.headers = ["browser": "in-app browser"]
            progressWebVC.delegate = self
            progressWebVC.extendedLayout = true
           
        }
  
        
        else if segue.identifier! == "presentTabBarView" {
            TTLog.debug("segue id tabbarview")
            _ = NBClient.shared.getCurrentUser()
            NBClient.shared.updateUserAvatar()
            
            let delegate = UIApplication.shared.delegate as! AppDelegate
            delegate.startBugsnag(user: NBClient.shared.getCurrentUser())
            
            NBSocket.shared.setupSocket()
            // NBSocket.shared.registerForUser()
        }
    }
}


extension RootViewController: ProgressWebViewControllerDelegate {
    
    func progressWebViewController(_ controller: ProgressWebViewController, didFinish url: URL) {
        TTLog.debug("progresswebview didfinish: ", controller.url!.absoluteString)
        var components = URLComponents(url: controller.url!.absoluteURL, resolvingAgainstBaseURL: false)
        let pathComponents = components!.path
        if (pathComponents == "/gateway/services/mobile/register") {
            _ = NBClient.shared.getCurrentUser()
            UserDefaults.set(hasUserLoggedIn: true)

            controller.dismiss(animated: true, completion: nil)
        }
    }
}
