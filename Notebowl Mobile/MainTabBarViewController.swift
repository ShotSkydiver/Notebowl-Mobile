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

class MainTabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    var hasAppeared: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()
        self.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        TTLog.testing("tabbarVC willappear")
        super.viewWillAppear(animated)
        
        let gradColor = UIImage().createGradientImage(size: 40).gradientColor
        
        self.tabBar.items![0].selectedImage = self.tabBar.items![0].image!.filled(withColor: gradColor).withRenderingMode(.alwaysOriginal)
        self.tabBar.items![1].selectedImage = self.tabBar.items![1].image!.filled(withColor: gradColor).withRenderingMode(.alwaysOriginal)
        self.tabBar.items![2].selectedImage = self.tabBar.items![2].image!.filled(withColor: gradColor).withRenderingMode(.alwaysOriginal)
        
        self.tabBar.items![2].badgeColor = #colorLiteral(red: 0.2310000062, green: 0.6510000229, blue: 0.8859999776, alpha: 1)
        
        self.tabBar.tintColor = UIImage().createGradientImage(size: 50).gradientColor
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.registerNotifications()
        
        if !hasAppeared {
            loadAllTabs()
        }
    }
    
    func loadAllTabs() {
        hasAppeared = true
        let rootViews: [RootNavigationBarVC] = (self.viewControllers as! [RootNavigationBarVC])
 
            if let homeVC = rootViews[0].topViewController as? HomeFeedViewController {
                if let coursesVC = rootViews[1].topViewController as? CoursesTableViewController {
                    coursesVC.courses = homeVC.courses
                    let _ = coursesVC.view
                }
                if let notifsVC = rootViews[2].topViewController as? NotificationsTableViewController {
                    notifsVC.notifications = NBClient.shared.getMappable(Notification.self, filters: "[\"text:IS_NULL:false\"]", sortBy: "createdAt:desc")!
                    let unreads = notifsVC.notifications.filter({ $0.unseenBool == true })
                    if unreads.count > 0 {
                        self.tabBar.items![2].badgeValue = String(format: "%d", (unreads.count))
                    }
                    let _ = notifsVC.view
                }
            
                homeVC.bgView.showViewAnimated(false)
            }
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
