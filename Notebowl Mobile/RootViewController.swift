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
            let gotUserSuccess = NBClient.shared.resolveCurrentUser(true)
            if gotUserSuccess {
                TTLog.debug("gotUserSuccess")
                self.performSegue(withIdentifier: "presentTabBarView", sender: nil)
            }
            else if !gotUserSuccess {
                TTLog.debug("did not gotUserSuccess")
                UserDefaults.set(hasUserLoggedIn: false)
                self.performSegue(withIdentifier: "presentLoginView", sender: nil)
            }
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
            progressWebVC.url = URL(string: ("https://\(NBClient.baseUrl)/bulletin?returnUrl=" + UIDevice().deviceQuery))
            progressWebVC.userAgent = "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/68.0.3418.2 Safari/537.36"
            progressWebVC.websiteTitleInNavigationBar = false
            progressWebVC.bypassedSSLHosts = ["demo.notebowl.xyz"]
            progressWebVC.navigationItem.title = "Notebowl Login"
            progressWebVC.tintColor = #colorLiteral(red: 0.04705882353, green: 0.4823529412, blue: 0.7568627451, alpha: 1)
            progressWebVC.doneBarButtonItemPosition = .none
            progressWebVC.toolbarItemTypes = []
            progressWebVC.disableZoom = false
            progressWebVC.headers = ["browser": "in-app browser"]
            progressWebVC.delegate = self
            progressWebVC.extendedLayout = true
        }
            
        else if segue.identifier! == "presentTabBarView" {
            Bugsnag.configuration()!.setUser(NBClient.shared.getCurrentUser().resourceKey, withName: NBClient.shared.getCurrentUser().fullName, andEmail: NBClient.shared.getCurrentUser().email!)
            NBSocket.shared.setup()
        }
    }
}


extension RootViewController: ProgressWebViewControllerDelegate {
    
    func progressWebViewController(_ controller: ProgressWebViewController, didFinish url: URL) {
        TTLog.debug("progresswebview didfinish: ", controller.url!.absoluteString)
        var components = URLComponents(url: controller.url!.absoluteURL, resolvingAgainstBaseURL: false)
        let pathComponents = components!.path
        if (pathComponents == "/gateway/services/mobile/register") {
            UserDefaults.set(hasUserLoggedIn: true)
            controller.dismiss(animated: true, completion: nil)
        }
    }
}
