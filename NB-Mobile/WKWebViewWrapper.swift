//
//  WKWebViewWrapper.swift
//  NB-Mobile
//
//  Created by Conner Owen on 9/19/17.
//  Copyright © 2017 NoteBowl. All rights reserved.
//

import Foundation
import WebKit

class WKWebViewWrapper: NSObject, WKScriptMessageHandler {
    
    var wkWebView: WKWebView

    init(forWebView webView: WKWebView) {
        wkWebView = webView
        super.init()

	}
    
    let eventNames = ["imagechanged", "documentReady", "updateApplicationState"]
    
    var eventFunctions : Dictionary<String, (String)->Void> = Dictionary<String, (String)->Void>()

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if let contentBody = message.body as? String{
            if let eventFunction = eventFunctions[message.name]{
                eventFunction(contentBody)
            }
        }
    }
    
    func setUpPlayerAndEventDelegation() {
        let controller = WKUserContentController()
        wkWebView.configuration.userContentController = controller
        
        for eventname in eventNames {
            controller.add(self, name: eventname)
            eventFunctions[eventname] = { _ in }
            
            wkWebView.evaluateJavaScript("$(#email).on('documentReady', function(event, isSuccess) { window.webkit.messageHandlers.\(eventname).postMessage(JSON.stringify(isSuccess)) }", completionHandler: nil)

        }
        wkWebView.evaluateJavaScript("$scope.loginData", completionHandler: nil)
    }

}
