//
//  MainTabBarViewController.swift
//  NB-Mobile
//
//  Created by Conner Owen on 12/19/17.
//  Copyright © 2017 NoteBowl. All rights reserved.
//

import Foundation
import UIKit

class MainTabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            UITabBar.appearance().tintColor = UIColor(named: "Notebowl Blue")
        } else { }
        
        self.delegate = self
    }

}
