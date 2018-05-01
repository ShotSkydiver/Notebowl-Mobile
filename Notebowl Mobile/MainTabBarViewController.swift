//
//  MainTabBarViewController.swift
//  Notebowl Mobile
//
//  Created by Conner Owen on 12/19/17.
//  Copyright © 2017 NoteBowl. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore
import ObjectMapper
import SocketIO
import BadgeControl

class MainTabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()
        self.delegate = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let gradColor = UIImage().createGradientImage(size: 40).gradientColor
        
        self.tabBar.items![0].selectedImage = self.tabBar.items![0].image!.filled(withColor: gradColor).withRenderingMode(.alwaysOriginal)
        self.tabBar.items![1].selectedImage = self.tabBar.items![1].image!.filled(withColor: gradColor).withRenderingMode(.alwaysOriginal)
        self.tabBar.items![2].selectedImage = self.tabBar.items![2].image!.filled(withColor: gradColor).withRenderingMode(.alwaysOriginal)
        
        self.tabBar.tintColor = UIImage().createGradientImage(size: 50).gradientColor
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.registerNotifications()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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

class RootNavigationBarVC: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
