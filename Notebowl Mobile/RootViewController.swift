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
import Siren

class RootViewController: UIViewController {
    var shouldLoad: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()
        Siren.shared.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if !(UserDefaults.hasUserLoggedIn) {
            self.performSegue(withIdentifier: "presentLoginView", sender: nil)
        }
        else if UserDefaults.hasUserLoggedIn {
            Siren.shared.checkVersion(checkType: .immediately)
            loadLoggedIn()
        }
    }

    func loadLoggedIn() {
        let gotUserSuccess = NBClient.shared.resolveCurrentUser(true)
        if gotUserSuccess {
            self.performSegue(withIdentifier: "presentTabBarView", sender: nil)
        }
        else if !gotUserSuccess {
            UserDefaults.set(hasUserLoggedIn: false)
            self.performSegue(withIdentifier: "presentLoginView", sender: nil)
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier! == "presentLoginView" {
            guard let webViewRootNavController = segue.destination as? UINavigationController, let progressWebVC = webViewRootNavController.topViewController as? ProgressWebViewController else { return }
            progressWebVC.url = URL(string: ("https://\(baseUrl)/bulletin?returnUrl=" + UIDevice().deviceQuery))
            progressWebVC.userAgent = "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3514.2 Safari/537.36"
            progressWebVC.websiteTitleInNavigationBar = false
            progressWebVC.bypassedSSLHosts = trustedHosts
            progressWebVC.navigationItem.title = "Notebowl Login"
            progressWebVC.tintColor = #colorLiteral(red: 0.04705882353, green: 0.4823529412, blue: 0.7568627451, alpha: 1)
            progressWebVC.doneBarButtonItemPosition = .none
            progressWebVC.toolbarItemTypes = []
            progressWebVC.disableZoom = false
            progressWebVC.headers = ["browser": "in-app browser"]
            progressWebVC.delegate = self
            progressWebVC.extendedLayout = true
        }
    }
}

extension RootViewController: ProgressWebViewControllerDelegate {
    func progressWebViewController(_ controller: ProgressWebViewController, didFinish url: URL) {
        var components = URLComponents(url: controller.url!.absoluteURL, resolvingAgainstBaseURL: false)
        let pathComponents = components!.path
        if (pathComponents == "/gateway/services/mobile/register") {
            UserDefaults.set(hasUserLoggedIn: true)
            controller.dismiss(animated: true, completion: nil)
        }
    }
}

extension RootViewController: SirenDelegate {
    func sirenDidDetectNewVersionWithoutAlert(title: String, message: String, updateType: UpdateType) {
        loadLoggedIn()
    }

    func sirenLatestVersionInstalled() {
        loadLoggedIn()
    }
}
