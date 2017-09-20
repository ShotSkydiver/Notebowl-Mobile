//
//  TestViewController.swift
//  NB-Mobile
//
//  Created by Conner Owen on 9/18/17.
//  Copyright © 2017 NoteBowl. All rights reserved.
//

import UIKit
import DeviceKit
import WKZombie
import Alamofire

class TestViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    @IBOutlet weak var loginButton : UIButton!

    let GLOBAL_TLD = "nbstage.com"
    let domain = "demo.nbstage.com"
    
    let browser = WKZombie.sharedInstance
    
    
    //var loginURL: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Logger.enabled = true
        
        
        
        //var device: Device!
        //var deviceUUID: UUID!
        //#if TARGET_IPHONE_SIMULATOR
        //device = Device.iPhone8Plus
        //deviceUUID = UUID(uuidString: "930784DA-0047-4E77-A30F-617B915C114A")
        //#else
        //device = Device()
        //deviceUUID = UIDevice().identifierForVendor!
        //#endif
        
        
        
        //loginURL = URL(string: finalDomain)
        
        //print("final domain: ", loginURL)
        
        
        
        //webView.loadRequest(URLRequest.init(url: URL.init(string: finalDomain)!))
        
        /*
        let configuration = URLSessionConfiguration.default
        let sessionManager = Alamofire.SessionManager(configuration: configuration)
        
        let parameters: Parameters = ["email": "bob.smith@notebowl.com", "password": "notebowlbeta"]
        
        sessionManager.request("https://demo.nbstage.com/api/v1.0/credentials", method: .post, parameters: parameters).responseData { (resData) in
            print(resData.response)
        }
        */
	}
    
    private func setUIEnabled(enabled: Bool) {
        emailTextField.isEnabled = enabled
        passwordTextField.isEnabled = enabled
        loginButton.isEnabled = enabled
    }
    
    
    @IBAction func loginButtonTouched(_ button: UIButton) {
        guard let userEmail = emailTextField.text, let userPassword = passwordTextField.text else {
            print("no text entered in one or both text fields!")
            return
        }
        setUIEnabled(enabled: false)
        loadingSpinner.startAnimating()
        
        let deviceUUID = UIDevice().identifierForVendor!
        let deviceName = "Oprah Winfrey4"
        let deviceVersion = "10.2"
        let deviceType = "iPhone 7 Plus"
        let deviceModel = "iPhone"
        let customAllowedSet =  CharacterSet(charactersIn:"=&\"#%/<>?@\\^`{|} ").inverted
        var redirectUrl = "https://gateway.\(GLOBAL_TLD)/services/mobile/register?uuid=\(deviceUUID.uuidString)&name=\(deviceName)&os=\(deviceVersion)&type=\(deviceType)&model=\(deviceModel)"
        redirectUrl = redirectUrl.addingPercentEncoding(withAllowedCharacters: customAllowedSet)!
        let finalDomain = "https://\(domain)/?returnUrl=\(redirectUrl)"
        let finalURL = URL(string: finalDomain)!
        let testURL = URL(string: "https://demo.nbstage.com/api/v1.0/credentials")!
        //let action : Action<HTMLPage> = browser.open(URL(string: finalDomain)!)
        browser.userAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Safari/604.1.38"
        doLogin(testURL, email: userEmail, password: userPassword)
    }
    
    
    func doLogin(_ url: URL, email: String, password: String) {
        
        
        
        /*
        open(url)
            >>* get(by: .id("email"))
            >>> setAttribute("value", value: email)
            >>> execute("document.querySelector('#email').value='bob.smith@notebowl.com'")
            >>> inspect
            >>* get(by: .XPathQuery("//form[1]"))
            >>> submit(then: .wait(5.0))
            >>* get(by: .id("password"))
            >>> setAttribute("value", value: password)
            
            === handleResult
        */
        
        let validateEmail = URL(string: "https://demo.nbstage.com/rpc/v1.0/validateEmail/bob.smith@notebowl.com")!
        let validateAnyEmail = URL(string: "https://demo.nbstage.com/bulletin?email=bob.smith@notebowl.com")!
        /*
        let validateAction : Action<HTMLPage> = browser.open(validateEmail)
        validateAction.start { result in
            switch result {
            case .success(let page): print("email valid, ", page.debugDescription)// process page
            case .error(let error): print("email not valid, ", error.debugDescription) // handle error
            }
        }
        */
        
         open(validateAnyEmail)
            // >>> execute("email.value=\(email)")
            // >>> execute("document.querySelector('#email').jQuery3210035860870252813592.$ngModelController.$modelValue='bob.smith@notebowl.com'")
            //>>> execute("document.querySelector('#email').value='bob.smith@notebowl.com'")
            
            //>>> execute(
            
            //>>> execute("angular.element($('#email')).triggerHandler('input')")
            //>>> execute("angular.element(document.querySelector('form')).triggerHandler('submit')")
            //>>> inspect
            //>>> execute("$scope.loginData.email ")
            // >>> inspect
            //>>> execute("$('#password').jQuery3210035860870252813592.$ngModelController.$modelValue='notebowlbeta'")
            //>>> execute("$('#password').jQuery3210035860870252813592.$ngModelController.$$rawModelValue='notebowlbeta'")
            
            
            >>> get(by: .XPathQuery("//*[@id='email']"))
            
            //>>> setAttribute("value", value: email)
            
            //>>* get(by: .id("password"))
            //>>> setAttribute("value", value: password)
            //>>> execute("angular.element(document.querySelector('form')).triggerHandler('submit')")
            //>>> execute("document.querySelector('#password').value='notebowlbeta'")
            
            //>>> execute("$('#password').value = 'notebowlbeta'")
            //>>> execute("$('#password').triggerHandler('input')")
            
            //>>> execute("$('form').triggerHandler('submit')")
            //>>> inspect
            
            === handleResult2
        
        
    }
    
    func handleResult(_ result: HTMLPage?) {
        print("result: ", result ?? "fuck")
        
        dump()
        
        //open(URL(string: "https://demo.nbstage.com/api/v1.0/credentials")!)
        //let creds : Action<HTMLPage> = browser.open(URL(string: "https://demo.nbstage.com/api/v1.0/credentials")!)
        //creds.start { result in
        //    print("cred api call result: ", result.debugDescription)
        //}
        
        
        
    }
    
    func handleResult2(_ result: Action<HTMLForm>.ResultType) {
        
        //Result<HTMLForm>
        switch result {
            case .success(let value): print("ttt", value.debugDescription)
            case .error(let error): self.handleError(error)
        }
    }
    
    
    func handleError(_ error: ActionError) {
        clearCache()
        dump()
        
        inspect >>> execute("document.title") === { [weak self] (result: JavaScriptResult?) in
            let title = result ?? "<Unknown>"
            let alert = UIAlertController(title: "Error On Page:", message: "\"\(title)\"", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self?.present(alert, animated: true) {
                //self?.setUserInterfaceEnabled(enabled: true)
                //self?.activityIndicator.stopAnimating()
            }
        }
    }

	override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

	}

	override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

	}

}
