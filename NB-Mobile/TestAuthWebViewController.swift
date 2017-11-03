//
//  TestAuthWebViewController.swift
//  NB-Mobile
//
//  Created by Conner Owen on 10/14/17.
//  Copyright © 2017 NoteBowl. All rights reserved.
//

import UIKit
import Disk
import PKHUD

class TestAuthWebViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        loginUser()
    }

    @IBAction func loginButtonTapped(_ sender: AnyObject) {

    }


    func loginUser() {
        let webkitAuthVC = NBAuthViewController() { (mobileToken) in
            guard let mobileToken = mobileToken else {
                print("login failed!")
                HUD.flash(.error, delay: 1.0)
                return
            }
            let saveToken = Helpers.saveTokenToDisk(currentToken: mobileToken)
            if (saveToken) {
                print("mobiletoken save to disk success! ", mobileToken.token)
            }
            
            self.dismiss(animated: true, completion: {
                HUD.flash(.success, delay: 1.0)
            })
        }

        webkitAuthVC.modalPresentationStyle = .fullScreen
        webkitAuthVC.modalTransitionStyle = .coverVertical
        present(webkitAuthVC, animated: true, completion: nil)
    }

}
