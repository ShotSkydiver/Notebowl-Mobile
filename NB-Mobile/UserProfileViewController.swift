//
//  UserProfileViewController.swift
//  NB-Mobile
//
//  Created by Conner Owen on 12/19/17.
//  Copyright © 2017 NoteBowl. All rights reserved.
//

import Foundation
import UIKit

class UserProfileViewController: UIViewController {
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userImage: RoundImageView!
    @IBOutlet weak var userUniversity: UILabel!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
    var loadingView: NBLoadingView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingView = NBLoadingView()
        loadingView?.showLoadView(false)
        self.view.addSubview(loadingView!)
        loadingView?.addUntitled2Animation()
        setupUser()
    }
    
    @IBAction func logoutButtonPressed() {
        NBClient.shared.logoutUser()
    }
    
    func setupUser() {
        loadingView?.showLoadView(true)
        DispatchQueue.main.async {
            let user = NBClient.shared.getCurrentUser()
            
            self.userName.text = user.fullName
            self.userUniversity.text = user.university!.name!
            
            let avatarImage = Just.get(user.profileThumbUrl!.absoluteString).content
            self.userImage.image = UIImage(data: avatarImage!)
            self.loadingView?.showLoadView(false)
        }
    }
}
