//
//  ErikViewController.swift
//  NB-Mobile
//
//  Created by Conner Owen on 9/19/17.
//  Copyright © 2017 NoteBowl. All rights reserved.
//

import UIKit

import WebKit
import Luminous
import Deviice

class ErikViewController: UIViewController, WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler {

    //@IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    @IBOutlet weak var loginBarButton: UIBarButtonItem!
    @IBOutlet weak var refreshBarButton: UIBarButtonItem!
    @IBOutlet weak var actionBarButton: UIBarButtonItem!
    //@IBOutlet weak var vcWebView: !
    
    let GLOBAL_TLD = "nbstage.com"
    let domain = "denison.nbstage.com"
    let denisonCas = "denison.nbstage.com/gateway/services/cas/denison/Login"
    
    let PROD_TLD = "notebowl.com"
    let prod_domain = "platform.notebowl.com"

    let fakeUUID = UUID(uuidString: "80BDCB89-5E51-450B-9B96-F15583C1CEFC")!
    
    let fakeDevice = Deviice.custom
    
    var webView: WKWebView!
    let webController = WKUserContentController()
    let webConfig = WKWebViewConfiguration()
    let webDataStore = WKWebsiteDataStore.default() // necessary to define this as an actual variable???
    let webPrefs = WKPreferences()
    
	override func viewDidLoad() {
        super.viewDidLoad()

        
        webView.addObserver(self, forKeyPath: "loading", options: .new, context: nil)
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        
        let customAllowedSet =  CharacterSet(charactersIn:"=&\"#%/<>?@\\^`{|} ").inverted
        var redirectUrl = "https://\(domain)/gateway/services/mobile/register?uuid=\((UIDevice().identifierForVendor!).uuidString)&name=\(AppValues.deviceInfo.model)&os=\(AppValues.deviceOS)&type=\(AppValues.deviceInfo.type)&model=\(AppValues.deviceInfo.identifier)"
        print("redirectUrl: ", redirectUrl)
        redirectUrl = redirectUrl.addingPercentEncoding(withAllowedCharacters: customAllowedSet)!
        let finalDomain = "https://\(domain)/?returnUrl=\(redirectUrl)"
        let finalURL = URL(string: finalDomain)!
        let credDomain = "https://denison.nbstage.com/gateway/services/cas/denison/Login?returnUrl=\(redirectUrl)"
        let credURL = URL(string: credDomain)!

        let request = URLRequest(url: credURL)

        webView.load(request)
        
	}
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print("webView:\(webView) decidePolicyForNavigationAction:\(navigationAction) decisionHandler:\(decisionHandler)")

        
        decisionHandler(WKNavigationActionPolicy.allow)
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        let response = navigationResponse.response
        print("webView:\(webView) decidePolicyForNavigationResponse:\(navigationResponse) decisionHandler:\(decisionHandler)")
        let responseHttp: HTTPURLResponse = navigationResponse.response as! HTTPURLResponse
        
        let responseKind = response.mimeType
        print("response mimeType: ", responseKind ?? "none")
        
        let responseStatus = responseHttp.statusCode
        print("response status code: ", responseStatus)
        
        //print("grabbed cookie value: ", responseHttp.value(forKey: "Set-Cookie") ?? "null")
        //let responseHeaders = responseHttp.allHeaderFields
        
        // notebowl_api    eyJpdiI6Ijd3Y0FGTjJqb2ZSeDI3dVd3S3NZMFE9PSIsInZhbHVlIjoiWlhlUlA4ZEFTaFNvSXJ4T044MWRCR1BtMEUxREQ3Njh1TkxzRzhmSjJGRHRzNVV5MHFKc3JaRjlUYk8yVHVZTUdFT1V2WTNkdFpZdjR0amxhWDFITnc9PSIsIm1hYyI6IjdkMDJiYjFlNmMwYTQ5OGFiMDc5NzdkNWUzMDQ2MDg4ZWM0YzZlMDdjZDQ2ZWFkNmU4MzdmMjNlNjZlNmVmMDIifQ%3D%3D    demo.nbstage.com    /    Session    292 B    ✓    ✓
        
        decisionHandler(WKNavigationResponsePolicy.allow)
        
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        //print("webView:\(webView) didFinishNavigation:\(navigation)")
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        //print("webView:\(webView) didCommitNavigation:\(navigation)")
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        //print("webView:\(webView) didStartProvisionalNavigation:\(navigation)")
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        //webView.evaluateJavaScript("window.name='NG_ENABLE_DEBUG_INFO!'", completionHandler: nil)
    }
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        //print("webView:\(webView) didReceiveServerRedirectForProvisionalNavigation:\(navigation)")
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        //print("webView:\(webView) didFailNavigation:\(navigation) withError:\(error)")
    }
    
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        //print("webView:\(webView) runJavaScriptTextInputPanelWithPrompt:\(prompt) defaultText:\(defaultText) initiatedByFrame:\(frame) completionHandler:\(completionHandler)")
    }
    
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        //print ("challenge: ", challenge.protectionSpace)
        
        //let user = "check_y16"
        //let pass = "(N0t3B0wL@2016)"
        
        let credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
        completionHandler(.performDefaultHandling, credential)
    }
    
    @IBAction func loginBarButtonTapped(_ sender: AnyObject) {
        
        webView.evaluateJavaScript("hookStatus()") { (success, error) in
            print("evaluateJavascript: ", success ?? "success is empty")
        }
        
        //guard let userEmail = emailTextField.text, let userPassword = passwordTextField.text else {
        //    print("no text entered in one or both text fields!")
        //    return
        //}
        /*
        let customAllowedSet =  CharacterSet(charactersIn:"=&\"#%/<>?@\\^`{|} ").inverted
        var redirectUrl = "https://gateway.\(GLOBAL_TLD)/services/mobile/register?uuid=\(deviceUUID.uuidString)&name=\(deviceName)&os=\(deviceVersion)&type=\(deviceType)&model=\(deviceModel)"
        redirectUrl = redirectUrl.addingPercentEncoding(withAllowedCharacters: customAllowedSet)!
        let finalDomain = "https://\(domain)/?returnUrl=\(redirectUrl)"
        let finalURL = URL(string: finalDomain)!
        let testURL = URL(string: "https://demo.nbstage.com")!
         */
        
    }
    
    @IBAction func actionBarButtonTapped(_ sender: AnyObject) {
        print("action tapped: ", self.webView)
    }
    
    @IBAction func refreshBarButtonTapped(_ sender: AnyObject) {
        self.webView.reload()
    }
    
    
    override func loadView() {
        super.loadView()
        
        //clearBrowsingData()
        
        //webController.removeAllUserScripts()
        
        guard let jsPath = Bundle.main.path(forResource: "webapp", ofType: "js") else {
            print("file read error!")
            return
        }
        let js = try? String(contentsOfFile: jsPath, encoding: .utf8)
        print("js file: ", js!)
        let userScript = WKUserScript(source: js!, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
        webController.addUserScript(userScript)
        webController.add(self, name: "debugMessage")
        
        webController.add(self, name: "submit")
        
        webPrefs.javaScriptCanOpenWindowsAutomatically = true
        
        webConfig.userContentController = webController
        webConfig.preferences = webPrefs
        
        
        self.webView = WKWebView(frame: self.view.frame, configuration: webConfig)
        //self.webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        //self.webView.translatesAutoresizingMaskIntoConstraints = false
        self.webView.uiDelegate = self
        self.webView.navigationDelegate = self
        //self.present
        
        self.view.addSubview(self.webView)
    }
    
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        if(message.name == "debugMessage") {
            //self.webView.evaluateJavaScript("hookStatus()", completionHandler: nil);
            
            if let contentBody = message.body as? String {
                print("JS Log: ", contentBody)
            }
        }
        else if(message.name == "submit") {
            print("submit received: ", message.body)
        }
    }

    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let keyPath = keyPath else { return }
        
        switch keyPath {
            
        case "title":
            navigationItem.title = webView.title
            
        case "loading":
            print("loading")
            
        case "estimatedProgress":
            print("estimatedProgress: ", webView.estimatedProgress)
            
        default:
            break
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

	override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

	}

}
