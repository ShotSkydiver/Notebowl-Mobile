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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUser()
    }
    
    @IBAction func logoutButtonPressed() {
        NBClient.shared.logoutUser()
    }
    
    
    func setupUser() {
        
        let user = NBClient.shared.getCurrentUser()
        
        self.userName.text = user.fullName
        self.userUniversity.text = user.university!.name!
        
        let avatarImage = Just.get(user.profileThumbUrl!.absoluteString).content
        self.userImage.image = UIImage(data: avatarImage!)

    }
}
