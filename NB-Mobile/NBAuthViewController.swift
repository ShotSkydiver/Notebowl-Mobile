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

        let loginUrl = ("https://demo.nbstage.com/bulletin?returnUrl=" + UIDevice().deviceQuery)
        let finalUrl = URL(string: loginUrl)!
        
        webView.load(URLRequest(url: finalUrl))
    }

}

extension NBAuthViewController: WKNavigationDelegate, WKUIDelegate {
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("document.contentType") { (response, error) in
            if ((response as! String) == ("application/json")) {
                webView.evaluateJavaScript("document.body.textContent") { (data, error) in
                    if (NBClient.shared.parseToken(from: data)) {
                        try? NBClient.shared.writeToken()
                    }
                    
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
}
