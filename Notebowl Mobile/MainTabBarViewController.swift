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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()
        
        self.delegate = self
 
        // self.tabBar.selectedItem!.selectedImage = self.tabBar.selectedItem!.selectedImage!.filled(withColor: UIColor(patternImage: grad))
        
        // UINavigationBar.appearance().tintColor = UIColor.groupTableViewBackground
        
        // registerSocketHandler()
        
        
        
        self.tabBar.items![2].badgeColor = #colorLiteral(red: 0.2310000062, green: 0.6510000229, blue: 0.8859999776, alpha: 1)
        
        let notifications = NBClient.shared.getMappable(Notification.self, filters: "[\"text:IS_NULL:false\"]", sortBy: "updatedAt:desc")!
        
        if NBClient.shared.storedTypes[Notification.classIdentifier] == nil {
            NBClient.shared.storedTypes[Notification.classIdentifier] = notifications
        }
        else {
            for notification in notifications {
                if NBClient.shared.storedTypes[Notification.classIdentifier]!.first(where: {$0.resourceKey == notification.resourceKey}) == nil {
                    NBClient.shared.storedTypes[Notification.classIdentifier]!.append(notification)
                }
            }
        }
        
        let unreads = NBClient.shared.storedTypes[Notification.classIdentifier]?.filter({ ($0 as! Notification).statusBool == false }) as! [Notification]
        self.tabBar.items![2].badgeValue = String(format: "%d", (unreads.count))
    }
    
    func registerSocketHandler() {
        /*
        NBSocket.shared.socket.on(NBClient.shared.getCurrentUser().resourceKey) { (data, ackEmitter) in
            TTLog.info("socket tabs: on response: ", data)
            guard let message = data[0] as? String else { return }
            if let data = message.data(using: .utf8) {
                do {
                    let JSON = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String : AnyObject]
                    TTLog.warning("socket: mapping response")
                    let mapped = Mapper<Generic>().map(JSON: JSON)!
                    TTLog.warning("socket: mapped! ", mapped)
                    
                    if (mapped.itemType?.contains("Notification"))! {
                        TTLog.info("notification!")
                        
                        var badgeVal = Int((self.tabBar.items![2].badgeValue)!)
                        badgeVal = badgeVal! + 1
                        DispatchQueue.main.async {
                            self.tabBarController?.tabBar.items![2].badgeValue = String(format: "%d", badgeVal!)
                        }
                    }
                    else {
                        TTLog.info("something else!")
                    }
                }
                catch let error {
                    print("Error parsing json: \(error)")
                }
            }
        }
        */
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let gradColor = UIImage().createGradientImage(size: 40).gradientColor
        
        self.tabBar.items![0].selectedImage = self.tabBar.items![0].image!.filled(withColor: gradColor).withRenderingMode(.alwaysOriginal)
        self.tabBar.items![1].selectedImage = self.tabBar.items![1].image!.filled(withColor: gradColor).withRenderingMode(.alwaysOriginal)
        self.tabBar.items![2].selectedImage = self.tabBar.items![2].image!.filled(withColor: gradColor).withRenderingMode(.alwaysOriginal)
        
        self.tabBar.tintColor = UIImage().createGradientImage(size: 50).gradientColor
        // self.tabBar.unselectedItemTintColor = UIColor.darkGray
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
        
        // self.navigationBar.barTintColor = UIColor.clear
        
        
        
        
        
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
