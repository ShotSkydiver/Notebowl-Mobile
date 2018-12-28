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
import PKHUD

class LoadingViewController: UIViewController {
    var loadingView: NBLoadingView!
    var bgView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        addLoadingView()
        loadingView.accessibilityIdentifier = "loadingView"
    }

    func addLoadingView() {
        self.loadingView = NBLoadingView()
        self.bgView = UIView(loadingView: self.loadingView)
        self.view.addSubview(bgView)
    }

    func showLoading(show: Bool) {
        self.loadingView.showLoadView(show)
        self.bgView.showViewAnimated(show)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
}

class MainTabBarViewController: UITabBarController, UITabBarControllerDelegate {
    var hasAppeared: Bool = false
    var loadingVC: LoadingViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        loadingVC = LoadingViewController()

        self.tabBar.items![2].accessibilityIdentifier = "notificationsItem"
        HUD.dimsBackground = true
        HUD.allowsInteraction = false
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let gradColor = UIImage().createGradientImage(size: 40).gradientColor
        self.tabBar.items![0].selectedImage = self.tabBar.items![0].image!.filled(withColor: gradColor).withRenderingMode(.alwaysOriginal)
        self.tabBar.items![1].selectedImage = self.tabBar.items![1].image!.filled(withColor: gradColor).withRenderingMode(.alwaysOriginal)
        self.tabBar.items![2].selectedImage = self.tabBar.items![2].image!.filled(withColor: gradColor).withRenderingMode(.alwaysOriginal)
        self.tabBar.items![2].badgeColor = #colorLiteral(red: 0.04705882353, green: 0.4823529412, blue: 0.7568627451, alpha: 1)

        self.tabBar.tintColor = UIImage().createGradientImage(size: 50).gradientColor
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if !hasAppeared {
            loadAllTabs()
        }
    }

    func loadAllTabs() {
        hasAppeared = true
        self.present(loadingVC, animated: false, completion: nil)
        DispatchQueue.main.async {
            self.getData()
            let rootViews: [RootNavigationBarVC] = (self.viewControllers as! [RootNavigationBarVC])
            if let homeVC = rootViews[0].topViewController as? HomeFeedViewController {
                let _ = (rootViews[1].topViewController as! CoursesTableViewController).view
                let _ = (rootViews[2].topViewController as! NotificationsTableViewController).view
                homeVC.reloadTable()
                homeVC.bulletinTableView.alpha = 1.0
                homeVC.navigationController?.setNavigationBarHidden(false, animated: false)
                self.tabBar.isHidden = false
                self.loadingVC.dismiss(animated: true, completion: {
                    homeVC.afterFullyLoaded()
                })
            }
        }
    }

    func getData() {
        let setting = NBClient.shared.getMappable(Setting.self)
        let notifs = NBClient.shared.getMappable(Notification.self, filters: "[\"text:IS_NULL:false\"]", sortBy: "createdAt:desc")
        let filter = NBClient.shared.doEnrollmentRequests()
        if let retrievedPosts = NBClient.shared.getMappable(Post.self, filters: "[\"_parent:IN:\(filter)\"]", sortBy: "createdAt:desc", limit: "10"), !retrievedPosts.isEmpty {
            let postComments = NBClient.shared.requireByReferences(Comment.self, property: "_parent", values: retrievedPosts)
            let threadedComments = NBClient.shared.requireByReferences(Comment.self, property: "_parent", values: postComments)
            var combinedFilter = (retrievedPosts as [NBModel])
            combinedFilter.append(contentsOf: (postComments as [NBModel]))
            combinedFilter.append(contentsOf: (threadedComments as [NBModel]))
            let likes = NBClient.shared.requireByReferences(Like.self, property: "_parent", values: combinedFilter)
            let attachments = NBClient.shared.requireByReferences(Attachment.self, property: "_parent", values: combinedFilter)
        }
        NBClient.shared.reinitCache()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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

    override var prefersStatusBarHidden: Bool {
        return false
    }
}

extension UINavigationController {

    func setNavigationBarTransparent(_ transparent: Bool, animated: Bool) {
        UIView.animate(withDuration: (animated ? 0.33 : 0)) {
            if transparent {
                self.navigationBar.setBackgroundImage(UIImage(), for: .default)
                self.navigationBar.shadowImage = UIImage()
                self.navigationBar.backgroundColor = UIColor.clear
                self.navigationBar.barTintColor = UIColor.clear
            }
            else {
                self.navigationBar.setBackgroundImage(nil, for: .default)
            }
        }
    }
}

class AnimatedNavBarViewController: UITableViewController {

    private var _preferredStyle = UIStatusBarStyle.lightContent
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return _preferredStyle
        }
        set {
            _preferredStyle = newValue
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }

    override func viewDidLoad() {
        modalPresentationCapturesStatusBarAppearance = true
    }

    override func willMove(toParent parent: UIViewController?) {
        if let last = self.navigationController?.viewControllers.last as? AnimatedNavBarViewController{
            if last == self && self.navigationController!.viewControllers.count > 1{
                if let parent = self.navigationController!.viewControllers[self.navigationController!.viewControllers.count - 2] as? AnimatedNavBarViewController{
                    parent.setNavigationColors()
                }
            }
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        if let parent = navigationController?.viewControllers.last as? AnimatedNavBarViewController{
            parent.animateNavigationColors()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        self.setNavigationColors()
    }

    func animateNavigationColors(){
        self.setBeforePopNavigationColors()
        transitionCoordinator?.animate(alongsideTransition: { [weak self](context) in
            self?.setNavigationColors()
            }, completion: nil)
    }

    func setBeforePopNavigationColors() {
    }

    func setNavigationColors(){
    }
}
