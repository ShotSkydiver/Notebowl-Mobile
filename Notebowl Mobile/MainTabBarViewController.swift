//
//  MainTabBarViewController.swift
//  Notebowl Mobile
//
//  Created by Conner Owen on 12/19/17.
//  Copyright © 2017 NoteBowl. All rights reserved.
//

import Foundation
import UIKit

class MainTabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = UIColor.darkGray
        UINavigationBar.appearance().tintColor = UIColor.groupTableViewBackground
        //UINavigationBar.appearance().bar = #colorLiteral(red: 0.2039999962, green: 0.2820000052, blue: 0.3650000095, alpha: 1)
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
