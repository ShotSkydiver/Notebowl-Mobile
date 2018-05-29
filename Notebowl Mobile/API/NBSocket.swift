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
    }
}
