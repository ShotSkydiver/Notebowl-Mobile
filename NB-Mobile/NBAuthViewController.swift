//
//  NBAuthViewController.swift
//  NB-Mobile
//
//  Created by Conner Owen on 10/14/17.
//  Copyright © 2017 NoteBowl. All rights reserved.
//

import Foundation
import UIKit
import WebKit


public class NBAuthViewController: UIViewController {
    private var webView: WKWebView!

    required public init?(coder aDecoder: NSCoder) {
        webView = WKWebView()
        super.init(coder: aDecoder)
        webView.navigationDelegate = self
    }

    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        webView = WKWebView()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        webView.navigationDelegate = self
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.websiteDataStore = .default()
        webView = WKWebView(frame: view.bounds, configuration: webConfiguration)
        webView.navigationDelegate = self
        if #available(iOS 11.0, *) {
            webView.scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            webView.scrollView.isScrollEnabled = false
        }
        
        self.view.addSubview(webView)

        let loginUrl = ("https://demo.nbstage.com/bulletin?returnUrl=" + Helpers.buildMobileRegisterQuery())
        let finalUrl = URL(string: loginUrl)!
        
        webView.load(URLRequest(url: finalUrl))
    }

}

extension NBAuthViewController: WKNavigationDelegate, WKUIDelegate {

    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {

        webView.evaluateJavaScript("document.contentType") { (response, error) in
            let responseString = response as? String
            if (responseString! == ("application/json")) {

                webView.evaluateJavaScript("document.body.textContent") { (data, error) in
                    guard error == nil else { fatalError(error!.localizedDescription) }

                    do {
                        let dataString = data as! String
                        let tokenJson = try Token(json: dataString, keyPath: "result")
                        try Helpers.saveToDisk(token: tokenJson)
                        self.dismiss(animated: true, completion: nil)
                        return
                    }
                    catch let error as NSError {
                        fatalError("""
                            Domain: \(error.domain)
                            Code: \(error.code)
                            Description: \(error.localizedDescription)
                            Failure Reason: \(error.localizedFailureReason ?? "")
                            Suggestions: \(error.localizedRecoverySuggestion ?? "")
                            """)
                    }
                    
                }
            }
        }
    }
}
