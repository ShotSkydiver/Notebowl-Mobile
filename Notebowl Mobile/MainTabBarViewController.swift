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
    
    var loadingView: NBLoadingView!
    var bgView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()
        self.delegate = self
        addLoadingView()
    }
    
    func addLoadingView() {
        self.loadingView = NBLoadingView()
        self.bgView = UIView(loadingView: self.loadingView)
        self.view.addSubview(bgView)
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
        self.loadingView.showLoadView(true)
        self.bgView.showViewAnimated(true)
        
        DispatchQueue.main.async {
            self.getData()
            let rootViews: [RootNavigationBarVC] = (self.viewControllers as! [RootNavigationBarVC])
            if let homeVC = rootViews[0].topViewController as? HomeFeedViewController {
                let _ = (rootViews[1].topViewController as! CoursesTableViewController).view
                let _ = (rootViews[2].topViewController as! NotificationsTableViewController).view
                homeVC.reloadTable()
                self.bgView.showViewAnimated(false)
            }
        }
    }
    
    func getData() {
        _ = NBClient.shared.getMappable(Setting.self)!
        _ = NBClient.shared.getMappable(Notification.self, filters: "[\"text:IS_NULL:false\"]")!
        _ = NBClient.shared.requireByReference(Enrollment.self, property: "user", value: NBClient.shared.getCurrentUser())!
        let postsFilter = NBClient.shared.storedTypes[Enrollment.classIdentifier]?.filter( { $0.parent is Course || $0.parent is Group } ).compactMap({ $0.parent!.url.absoluteString }).joined(separator: ",")
        let retrievedPosts = NBClient.shared.getMappable(Post.self, filters: "[\"_parent:IN:\(postsFilter!)\"]", sortBy: "createdAt:desc", limit: "10")!
        let postComments = NBClient.shared.requireByReferences(Comment.self, property: "_parent", values: retrievedPosts)!
        let combinedFilter = Array(Set((retrievedPosts as [NBModel]) + (postComments as [NBModel])))
        _ = NBClient.shared.requireByReferences(Like.self, property: "_parent", values: combinedFilter)
        _ = NBClient.shared.requireByReferences(Attachment.self, property: "_parent", values: combinedFilter)
        NBClient.shared.reinitCache()
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
