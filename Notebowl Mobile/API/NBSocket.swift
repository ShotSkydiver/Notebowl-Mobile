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
import Bugsnag

struct SendData : SocketData {
    let action: String
    let updateUrl: String
    let itemType: String
    let updatedAt: String
    
    func socketRepresentation() -> SocketData {
        return ["action": action, "updateUrl": updateUrl, "itemType": itemType, "updatedAt": updatedAt]
    }
}

class NBSocket {
    static let shared: NBSocket = {
        return NBSocket()
    }()
    #if DEBUG
    let manager = SocketManager(socketURL: URL(string: socketUrl)!, config: [.log(true),.secure(true),.selfSigned(true),.forceNew(true)])
    #else
    let manager = SocketManager(socketURL: URL(string: socketUrl)!, config: [.log(false),.secure(true),.selfSigned(true),.forceNew(true)])
    #endif
    var currentlyHandling: String? = nil
    private init() { }
    
    func setup() {
        NBSocket.shared.registerHandlers()
        NBSocket.shared.manager.connect()
    }
    
    func registerForUser() {
        manager.defaultSocket.emit("register", "platform:status")
        manager.defaultSocket.emit("register", NBClient.shared.getCurrentUser().resourceKey)
    }
    
    func registerHandlers() {
        manager.defaultSocket.on(clientEvent: .connect) { (data, ackEmitter) in
            self.registerForUser()
        }
        manager.defaultSocket.on(NBClient.shared.getCurrentUser().resourceKey) { (data, emitter) in
            guard let message = data[0] as? String else { return }
            guard let contentData = message.data(using: String.Encoding.utf8, allowLossyConversion: true) else { return }
            let JSON = try! JSONSerialization.jsonObject(with: contentData, options: .mutableContainers) as! [String : AnyObject]
            guard let updateUrl = JSON["updateUrl"] as? String else { fatalError() }
            if let itemType = ItemType.fromURL(updateUrl) {
                _ = self.updateHandler(itemType: "\(itemType)", updateUrl: "\(updateUrl)", action: "\((JSON["action"] as! String))", updatedAt: "\((JSON["updatedAt"] as! String))")
            }
        }
    }
    
    func updateHandler(itemType: String, updateUrl: String, action: String, updatedAt: String) -> NBModel? {
        let mapped = Mapper<Generic>().map(JSON: ["itemType":"\(itemType)", "updateUrl":"\(updateUrl)", "action":"\(action)", "updatedAt":"\(updatedAt)"])
        guard let object = mapped!.genericObject else { return nil }
        
        if ["Enrollment","CourseUser","GroupUser"].contains(object.itemType.capitalised) {
            if (object as! Enrollment).user.resourceKey != NBClient.shared.getCurrentUser().resourceKey {
                return nil
            }
        }
        
        guard let tabbarVC = UIApplication.shared.keyWindow?.rootViewController!.presentedViewController as? MainTabBarViewController else { return nil }
        if let viewControllers = tabbarVC.viewControllers {
            for viewController in viewControllers {
                let rootNavController = viewController as! UINavigationController
                for vc in rootNavController.viewControllers {
                    if let switchVC = vc as? UpdateVC {
                        switch mapped!.action {
                        case .updated:
                            switchVC.handleUpdated(newObject: object)
                        case .deleted:
                            switchVC.handleDeleted(deletedObject: object)
                        case .elapsed:
                            switchVC.handleElapsed(elapsedObject: object)
                        default:
                            return nil
                        }
                        
                    }
                }
            }
        }
        return object
    }
}
