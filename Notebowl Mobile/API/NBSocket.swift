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

struct SendData: SocketData {
    let itemType: ItemType
    let updateUrl: String
    let action: String
    let updatedAt: String
}

class NBSocket {
    static let shared: NBSocket = {
        return NBSocket()
    }()
    #if DEBUG
    let manager = SocketManager(socketURL: URL(string: socketUrl)!, config: [.log(true), .secure(true), .selfSigned(true), .forceNew(true), .sessionDelegate(NBNetworking.shared)])
    #else
    let manager = SocketManager(socketURL: URL(string: socketUrl)!, config: [.log(false), .secure(true), .selfSigned(true), .forceNew(true)])
    #endif

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
            let JSON = try! JSONSerialization.jsonObject(with: contentData, options: .mutableContainers) as! [String: AnyObject]

            if let updateUrl = JSON["updateUrl"] as? String, let itemType = ItemType.fromURL(updateUrl), let action = JSON["action"] as? String, let updatedAt = JSON["updatedAt"] as? String {
                let newResponse = SendData(itemType: itemType, updateUrl: updateUrl, action: action, updatedAt: updatedAt)
                _ = self.updateHandler(itemType: "\(newResponse.itemType)", updateUrl: "\(newResponse.updateUrl)", action: "\(newResponse.action)", updatedAt: "\(newResponse.updatedAt)")
            }
        }
    }

    func updateHandler(itemType: String, updateUrl: String, action: String, updatedAt: String) -> NBModel? {
        let mapped = Mapper<Generic>().map(JSON: ["itemType": "\(itemType)", "updateUrl": "\(updateUrl)", "action": "\(action)", "updatedAt": "\(updatedAt)"])
        guard let object = mapped!.genericObject else { return nil }

        if mapped?.action == .updated {
            NotificationCenter.default.post(name: NSNotification.Name("ModelDidBeginUpdating\(object.itemType.className)"), object: nil, userInfo: ["object": object])
            NotificationCenter.default.post(name: NSNotification.Name("ModelDidFinishUpdating\(object.itemType.className)"), object: nil, userInfo: ["object": object])
        } else if mapped?.action == .deleted {
            NotificationCenter.default.post(name: NSNotification.Name("ModelWillDelete\(object.itemType.className)"), object: nil, userInfo: ["object": object])
            NotificationCenter.default.post(name: NSNotification.Name("ModelDidBeginDeleting\(object.itemType.className)"), object: nil, userInfo: ["object": object])
            NotificationCenter.default.post(name: NSNotification.Name("ModelDidFinishDeleting\(object.itemType.className)"), object: nil, userInfo: ["object": object])
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
