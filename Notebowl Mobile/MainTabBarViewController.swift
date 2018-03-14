//
//  MainTabBarViewController.swift
//  Notebowl Mobile
//
//  Created by Conner Owen on 12/19/17.
//  Copyright © 2017 NoteBowl. All rights reserved.
//

import Foundation
import UIKit
import Bugsnag

class MainTabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = UIColor.darkGray
        UINavigationBar.appearance().tintColor = UIColor.groupTableViewBackground
        self.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.registerNotifications()
        
        
        
    }

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if selectedViewController == nil || viewController == selectedViewController {
            return false
        }
        
        let fromView = selectedViewController!.view
        let toView = viewController.view
        
        UIView.transition(from: fromView!, to: toView!, duration: 0.3, options: [.transitionCrossDissolve], completion: nil)
        
        return true
    }
}
