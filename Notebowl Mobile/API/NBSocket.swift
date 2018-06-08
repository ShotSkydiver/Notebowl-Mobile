//
//  NBSocket.swift
//  Notebowl Mobile
//
//  Created by Conner Owen on 4/18/18.
//  Copyright © 2018 Notebowl. All rights reserved.
//

import Foundation
import UIKit
import SocketIO
import ObjectMapper

class NBSocket {
    static let shared: NBSocket = {
        TTLog.debug("socket shared init")
        let instance = NBSocket()
        instance.registerHandlers()
        instance.manager.connect()
        return instance
    }()
    
    let manager = SocketManager(socketURL: URL(string: NBClient.socketUrl)!, config: [.log(true),.secure(true),.selfSigned(true),.forceNew(true)])
    
    private init() { }
    
    func registerForUser() {
        manager.defaultSocket.emit("register", "platform:status")
        manager.defaultSocket.emit("register", NBClient.shared.getCurrentUser().resourceKey)
    }
    
    func registerHandlers() {
        manager.defaultSocket.on(clientEvent: .connect) { (data, ackEmitter) in
            TTLog.socket("connected")
            self.registerForUser()
        }
        
        manager.defaultSocket.on(NBClient.shared.getCurrentUser().resourceKey) { (data, ackEmitter) in
            guard let message = data[0] as? String else { return }
            if let data = message.data(using: .utf8) {
                do {
                    let JSON = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String : AnyObject]
                    let mapped = Mapper<Generic>().map(JSON: JSON)!
                    
                    guard let tabbarVC = UIApplication.shared.keyWindow?.rootViewController!.presentedViewController as? MainTabBarViewController else {
                        TTLog.debug("tabController is not presented!")
                        return
                    }
                    if let viewControllers = tabbarVC.viewControllers {
                        for viewController in viewControllers {
                            let rootNavController = viewController as! UINavigationController
                            for vc in rootNavController.viewControllers {
                                if let switchVC = vc as? UpdateVC {
                                    
                                    switch mapped.actionType {
                                    case .updated:
                                        switchVC.handleUpdated(newObject: mapped.genericObject!)
                                    case .deleted:
                                        switchVC.handleDeleted(deletedObject: mapped.genericObject!)
                                    case .elapsed:
                                        switchVC.handleElapsed(elapsedObject: mapped.genericObject!)
                                    case .unknown:
                                        TTLog.error("unknown actiontype!")
                                        return
                                    }
                                    
                                    switchVC.reloadTableViews()
                                }
                            }
                        }
                    }
                }
                catch let error {
                    print("Error parsing json: \(error)")
                }
            }
        }
    }
}
