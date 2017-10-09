//
//  WKZombieViewController.swift
//  NB-Mobile
//
//  Created by Conner Owen on 10/3/17.
//  Copyright © 2017 NoteBowl. All rights reserved.
//

import Foundation
import UIKit
import Disk
import WebKit
import WKZombie


class WKLoginViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loginButton: UIButton!

    var snapshots = [Snapshot]()

    override func viewDidLoad() {
        super.viewDidLoad()

        Logger.enabled = true
        WKZombie.sharedInstance.snapshotHandler = { [weak self] snapshot in
            self?.snapshots.append(snapshot)
        }

        activityIndicator.startAnimating()
        snapshots.removeAll()

        //loginDemo(user: "bob.smith@notebowl.com", pass: "notebowlbeta")
        loginDenison(user: "check_y16", pass: "(N0t3B0wL@2016)")

        self.activityIndicator.stopAnimating()
            

    }

    func loginDemo(user: String, pass: String) {


    }
    
    func loginDenison(user: String, pass: String) {

        let redirectUrl = "/api/v1.0/credentials"
        let denisonCasLogin = "https://denison.nbstage.com/gateway/services/cas/denison/Login?returnUrl=\(redirectUrl)"
        let denisonCasLoginURL = URL(string: denisonCasLogin)!
        //var resultContent: String?
        open(then: .wait(2.0))(denisonCasLoginURL)
            >>> get(by: .XPathQuery("//*[@id='username']"))
            >>> setAttribute("value", value: user)
            >>> get(by: .XPathQuery("//*[@id='password']"))
            >>> setAttribute("value", value: pass)
            >>> get(by: .XPathQuery("//*[@id='loginForm']"))
            >>> submit(then: .wait(5.0))
            >>> get(by: .XPathQuery("//body"))
            === { (result: HTMLElement?) in
                Helpers.decodeUserObject(jsonString: (result?.content)!)
            }

    }


}

