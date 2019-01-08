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
            guard let metadata = Mapper<MetadataSocket>().map(JSONString: message) else {
                return
            }
            let dataObject = metadata.dataType.dataObject

            if let existingObject = type(of: dataObject).getCache().first(where: { $0.resourceKey == metadata.updateUrl.lastPathComponent }) {
                if metadata.action == .deleted {
                    NBClient.shared.decacheMappable(object: existingObject)
                } else if metadata.updatedAt > existingObject.updatedAt {
                    type(of: dataObject).getSingular(objectUrl: metadata.updateUrl.absoluteString, forceRefresh: true)
                }
            } else if metadata.action == .updated {
                type(of: dataObject).getSingular(objectUrl: metadata.updateUrl.absoluteString, forceRefresh: true)
            }
        }
    }
}
