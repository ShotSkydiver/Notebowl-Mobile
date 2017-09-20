//
//  ErikViewController.swift
//  NB-Mobile
//
//  Created by Conner Owen on 9/19/17.
//  Copyright © 2017 NoteBowl. All rights reserved.
//

import UIKit
import DeviceKit
import SwiftyJSON
import WebKit

class ErikViewController: UIViewController {

    //@IBOutlet weak var emailTextField: UITextField!
    //@IBOutlet weak var passwordTextField: UITextField!
    //@IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    //@IBOutlet weak var outputLabel: UILabel!
    @IBOutlet weak var loginButton : UIButton!
    @IBOutlet weak var webViewContainer : UIView!
    
    let GLOBAL_TLD = "nbstage.com"
    let domain = "demo.nbstage.com"
    
    let deviceUUID = UIDevice().identifierForVendor!
    let deviceName = "Oprah Winfrey2"
    let deviceVersion = "10.2"
    let deviceType = "iPhone 7 Plus"
    let deviceModel = "iPhone"
    
    //var provider: AlamofireProvider!
    //var service: Service!
    
    
	override func viewDidLoad() {
        super.viewDidLoad()
        
        //provider = AlamofireProvider.init(manager: SessionManager.default)
        //service = Service(baseURL: "https://demo.nbstage.com", standardTransformers: [.text, .image], networking: provider)
       
        
	}
    

    
    @IBAction func loginButtonTouched(_ button: UIButton) {
        //guard let userEmail = emailTextField.text, let userPassword = passwordTextField.text else {
        //    print("no text entered in one or both text fields!")
        //    return
        //}
        
        
        let customAllowedSet =  CharacterSet(charactersIn:"=&\"#%/<>?@\\^`{|} ").inverted
        var redirectUrl = "https://gateway.\(GLOBAL_TLD)/services/mobile/register?uuid=\(deviceUUID.uuidString)&name=\(deviceName)&os=\(deviceVersion)&type=\(deviceType)&model=\(deviceModel)"
        redirectUrl = redirectUrl.addingPercentEncoding(withAllowedCharacters: customAllowedSet)!
        let finalDomain = "https://\(domain)/?returnUrl=\(redirectUrl)"
        let finalURL = URL(string: finalDomain)!
        let testURL = URL(string: "https://demo.nbstage.com")!
        
    }
    
    

	override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let wkConfig = WKWebViewConfiguration()
        
        let wkData = WKWebsiteDataStore.default()
        
        let wkCookies = wkData.httpCookieStore
        wkConfig.websiteDataStore = wkData
        wkCookies.getAllCookies { (cookie) in
            print("a cookie: ", cookie.content())
            
        }
        let wkPrefs = WKPreferences()
        wkPrefs.javaScriptCanOpenWindowsAutomatically = true
        wkPrefs.javaScriptEnabled = true
        wkConfig.preferences = wkPrefs
        
        wkConfig.suppressesIncrementalRendering = false
        
        let wkWebView = WKWebView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: webViewContainer.frame.height), configuration: wkConfig)
        wkWebView.customUserAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Safari/604.1.38"
        
        view.addSubview(wkWebView)
        
        wkWebView.load(URLRequest(url: URL(string: "https://demo.nbstage.com/bulletin?email=bob.smith@notebowl.com")!))
        //wkWebView.load(URLRequest(url: URL(string: "https://demo.nbstage.com/bulletin")!))
        
        wkWebView.evaluateJavaScript("$('#password').value = 'notebowlbeta')", completionHandler: <#T##((Any?, Error?) -> Void)?##((Any?, Error?) -> Void)?##(Any?, Error?) -> Void#>)
        
        
        //let wrapper = WKWebViewWrapper(forWebView: wkWebView)
        
        /*wrapper.eventFunctions["documentReady"] = {
            result in
            print("test: ", result)
        }*/
        
	}

	override func viewDidAppear(_ animated: Bool) {
        	super.viewDidAppear(animated)
        
	}

}
