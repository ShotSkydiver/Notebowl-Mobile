//
//  MainTabBarViewController.swift
//  Notebowl Mobile
//
//  Created by Conner Owen on 12/19/17.
//  Copyright © 2017 NoteBowl. All rights reserved.
//

import Foundation
import UIKit
import Tamamushi

class MainTabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()
        
        let grad = createGradientImage()
        
        UITabBar.appearance().tintColor = UIColor(patternImage: grad)
        self.tabBar.items![0].selectedImage = self.tabBar.items![0].selectedImage?.filled(withColor: UIColor(patternImage: grad))
        UINavigationBar.appearance().tintColor = UIColor.groupTableViewBackground
        
        self.delegate = self
        self.tabBar.items![2].badgeColor = #colorLiteral(red: 0.2310000062, green: 0.6510000229, blue: 0.8859999776, alpha: 1)
        let unreads = NBClient.shared.getMappable(Notification.self, filters: "[\"_status:IS_NULL:true\"]", sortBy: "updatedAt:desc")!
        print("unread notifs: ", unreads.count)
        self.tabBar.items![2].badgeValue = String(format: "%d", (unreads.count))
    }
    
    func createGradientImage() -> UIImage {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [#colorLiteral(red: 0.2310000062, green: 0.6510000229, blue: 0.8859999776, alpha: 1).cgColor, #colorLiteral(red: 0.3249999881, green: 0.7139999866, blue: 0.4350000024, alpha: 1).cgColor]
        
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        let frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        gradientLayer.frame = frame
        
        UIGraphicsBeginImageContext(gradientLayer.frame.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return outputImage!
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
