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
        let jsonData = content.data(using: .utf8, allowLossyConversion: true)!
        let decoder = JSONDecoder()
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
                self.handleResultContent(content: (result?.content)!)
            }


        /*
        let action : Action<HTMLPage> = open(denisonCasLoginURL)
        //var jsonPageResult: HTMLPage

        action.start { result in
            switch result {
            case .success(let page):
                print("success! htmlPage: ", page.url)
                //dump()

                inspect
                    >>> get(by: .XPathQuery("//[@id='username']"))
                    >>> setAttribute("value", value: user)
                    >>> get(by: .XPathQuery("//[@id='password']"))
                    >>> setAttribute("value", value: pass)
                    >>> get(by: .XPathQuery("//[@id='loginForm']"))
                    >>> submit(then: .wait(5.0))
                    >>> execute("JSON.parse(document.body.textContent)")
                    === { (result: JavaScriptResult?) in
                        print("result: ", String(data: result!, encoding: .utf8))
                    }
                    //>>> map { jsonPageResult = $0 as HTMLPage }
                    //>>> get(by: .XPathQuery("//pre"))
                    //=== { (result: HTMLElement?) in
                        //let resultContent = result!.content!
                        //print("content: ", result!.objectForKey("result"))
                        //let resultData = resultContent.data(using: .utf8)!
                        //print("content as data: ")
                        //let userDecoded = try? JSONDecoder().decode(Users.self, from: resultData)
                        //dump(userDecoded)
                    //}


                    >>> inspect
                    === { (result: HTMLPage?) in
                        if let result = result, let jsonPageResult = jsonPageResult {
                            print("resultjson: ", result.data)
                            print("result: ", String(data: result.data!, encoding: .utf8))


                        }
                        else {
                            print("not equal!")

                        }
                    }



            case .error(let error):
                print("erreeror! ", error.debugDescription)
            }
        }

        print("after action")
        */


    }



    func handleJSONResult(_ result: Result<JavaScriptResult>) {

        switch result {
        case .success(let page):
            print("handleJSONResult success!")

            print("json object: ", String(data: page, encoding: .utf8))
            let userDecoded = Helpers.decodeUserObject(jsonData: page)
            print("user decoded: ", userDecoded)

        case .error(let error):
            print("handleJSONResult error! ", error.debugDescription)
        }
    }

}
/*
extension WKZombie {
    func execute(_ script: JavaScript) -> Action<JavaScriptResult> {

        return Action() { [unowned self] completion in
            self._renderer.executeScript(script, completionHandler: { result, response, error in
                let data = self._handleResponse(result as? Data, response: response, error: error)

                completion(data)
            })
        }
    }
}
*/
