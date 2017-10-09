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
        loginDenison(user: "check_y16", pass: "(N0t3B0wL@2016)")

        self.activityIndicator.stopAnimating()
            

    }

    func loginDemo(user: String, pass: String) {


    }

    func handleResultContent(content: String) {
        print("result content: ", content, " END")
        let jsonData = content.data(using: .utf8)!
        let decoder = JSONDecoder()
        //let formatter = DateFormatter()
        //formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSxxx"
        //formatter.timeZone = TimeZone(secondsFromGMT: 0)
        //formatter.locale = Locale(identifier: "en_US_POSIX")
        //decoder.dateDecodingStrategy = .formatted(formatter)
        do {
            let users = try decoder.decode(Users.self, from: jsonData)
            print("success! ", users.result)
        }
        catch {
            print("error!")
        }

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
                //self.handleResultContent(content: (result?.content)!)
            }

    }


}

