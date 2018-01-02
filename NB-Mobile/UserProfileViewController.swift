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
    
    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userUniversity: UILabel!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
    private var didSetup: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if (!NBClient.shared.loginValidated) {
            self.notLoggedIn()
        }
        else if (!self.didSetup) {
            self.setupUser()
        }
    }
    
    @IBAction func logoutButtonPressed() {
        NBClient.shared.logoutUser()
        self.didSetup = false
        let webVC = NBAuthViewController()
        self.present(webVC, animated: true, completion: nil)
    }
    
    func notLoggedIn() {
        self.placeholderLabel.isHidden = false
        self.userName.isHidden = true
        self.userImage.isHidden = true
        
        let webVC = NBAuthViewController()
        
        self.present(webVC, animated: true, completion: nil)
        
    }
    
    func setupUser() {
        self.placeholderLabel.isHidden = true
        self.userName.isHidden = false
        self.userImage.isHidden = false
        
        let user = NBClient.shared.getCurrentUser()!
        
        self.userName.text = user.name
        
        self.userUniversity.text = user.university.first?.name
        
        let avatarImage = Just.get(user.profileThumbUrl).content
        if avatarImage != nil {
            self.userImage.image = UIImage(data: avatarImage!)
        }
        else { print("avatarImage is nil!") }
       
        self.didSetup = true
    }
}
