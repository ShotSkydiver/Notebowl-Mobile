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
    let manager = SocketManager(socketURL: URL(string: socketUrl)!, config: [.log(false), .secure(true), .selfSigned(true), .forceNew(true), .sessionDelegate(NBNetworking.shared)])
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
            guard let message = data[0] as? String else {
                return
            }
            guard let contentData = message.data(using: String.Encoding.utf8, allowLossyConversion: true) else { return }
            let JSON = try! JSONSerialization.jsonObject(with: contentData, options: .mutableContainers) as! [String: AnyObject]
            guard let updateUrl = JSON["updateUrl"] as? String, let action = JSON["action"] as? String else {
                return
            }

            if action == "updated" {
                let mapped = Mapper<Generic>().map(JSONString: message)
            } else if action == "deleted" {
                NBClient.shared.decacheMappable(object: updateUrl)
            }
        }
    }
}
