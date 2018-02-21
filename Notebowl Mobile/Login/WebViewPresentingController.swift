//
//  WebViewPresentingController.swift
//  Notebowl Mobile
//
//  Created by Conner Owen on 1/28/18.
//  Copyright © 2018 NoteBowl. All rights reserved.
//

import Foundation
import UIKit


@available(iOS 11.0, *)
class WebViewPresentingController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.performSegue(withIdentifier: "presentModal", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier! == "presentModal" {
            
            guard let webViewRootNavController = segue.destination as? UINavigationController, let progressWebVC = webViewRootNavController.topViewController as? ProgressWebViewController else {
                return
            }
            
            progressWebVC.url = URL(string: ("https://demo.nbstage.com/bulletin?returnUrl=" + UIDevice().deviceQuery))
            progressWebVC.userAgent = "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36"
            progressWebVC.websiteTitleInNavigationBar = true
            progressWebVC.tintColor = UIColor(named: "Notebowl Blue")
            progressWebVC.doneBarButtonItemPosition = .none
            progressWebVC.toolbarItemTypes = [.back, .forward, .reload, .activity]
            
            progressWebVC.delegate = self
            
        }
    }
}

@available(iOS 11.0, *)
extension WebViewPresentingController: ProgressWebViewControllerDelegate {
    
    func progressWebViewController(_ controller: ProgressWebViewController, didFinish url: URL) {
        print("progresswebview didfinish: ", controller.url!.absoluteString)
        
        var components = URLComponents(url: controller.url!.absoluteURL, resolvingAgainstBaseURL: false)
        let pathComponents = components!.path
        if (pathComponents == "/gateway/services/mobile/register") {
            print("dismiss controller")
            
            DispatchQueue.main.async {
                controller.dismiss(animated: true, completion: nil)
            }
            
            let defaults = UserDefaults.standard
            defaults.set(true, forKey: "com.notebowl.standalone.userLoggedIn")
            NBClient.shared.registerNotificationsToken()
            let delegate = UIApplication.shared.delegate as! AppDelegate
            delegate.finishedPresentingOnboarding()
            
            
        }
    }
}
