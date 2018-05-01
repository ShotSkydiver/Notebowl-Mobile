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
        /*
        socket.on(NBClient.shared.getCurrentUser().resourceKey) { (data, ackEmitter) in
            TTLog.warning("socket received resourcekey")
            guard let message = data[0] as? String else { return }
            if let data = message.data(using: .utf8) {
                do {
                    let JSON : [String:AnyObject] = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String : AnyObject]
                    /*
                    let action: String = JSON["action"] as! String
                    let itemType: String = JSON["itemType"] as! String
                    let updateUrl: String = JSON["updateUrl"] as! String
                    let updatedAt: String = JSON["updatedAt"] as! String
                    */
                    
                    let mapped = Mapper<Generic>().map(JSON: JSON)!
                    TTLog.warning("socket: mapped! ", mapped)
                    
                    if (mapped.itemType?.contains("Notification"))! {
                        
                    }
                }
                catch let error {
                    print("Error parsing json: \(error)")
                }
            }
        }
        */
        /*
        manager.defaultSocket.on("platform:status") { (data, ackEmitter) in
            TTLog.warning("socket received platform status, ", data)
        }
        */
        // manager.defaultSocket.onAny {TTLog.testing("Got event: \($0.event), with items: \($0.items!)")}
    }
    
    
}
