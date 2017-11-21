//
//  NBAuthViewController.swift
//  NB-Mobile
//
//  Created by Conner Owen on 10/14/17.
//  Copyright © 2017 NoteBowl. All rights reserved.
//

import UIKit
import WebKit
import Luminous
import Deviice


public class NBAuthViewController: UIViewController {
    private var completion: (Token?) -> Void

    private var webView: WKWebView!
    private let decoder = JSONDecoder()

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public init(completion: @escaping (_ mobileToken: Token?) -> Void) {
        self.completion = completion
        super.init(nibName: nil, bundle: nil)
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

    func endAuthentication(token: Token?) {
        self.completion(token)
    }
}

extension NBAuthViewController: WKNavigationDelegate, WKUIDelegate {

    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {

        webView.evaluateJavaScript("document.contentType") { (response, error) in
            let responseString = response as? String
            if (responseString!.compare("application/json") == .orderedSame) {
                print("contentType is json!")

                webView.evaluateJavaScript("document.body.innerText") { (data, error) in
                    let dataString = data as! String

                        guard let tokenResponseJson = try? self.decoder.decode(TokenResponse.self, from: dataString.data(using: .utf8)!) else {
                            return
                        }
                    
                        self.endAuthentication(token: tokenResponseJson.result)


                }
            }
        }
    }
}
