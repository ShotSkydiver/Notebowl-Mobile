//
//  NBSocket.swift
//  Notebowl Mobile
//
//  Created by Conner Owen on 4/18/18.
//  Copyright © 2018 Notebowl. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper
import Bugsnag
import Kingfisher
import Disk
import SocketIO

public class NBSocket {
    
    public static let shared = NBSocket()

    public let socketUrl = "https://socket.\((NBClient.Environment.Production.rawValue.components(separatedBy: ".")[1])).com/"
    
    public var socketConfig: SocketIOClientConfiguration = [
        .log(true),
        .secure(true),
        .selfSigned(true),
        .forceNew(true)
    ]
    public var socket: SocketIOClient!
    public var socketManager: SocketManager!
    
    private init() { }
    
    
    public func setupSocket() {
        TTLog.warning("setup socket")
        socketManager = SocketManager(socketURL: URL(string: socketUrl)!, config: socketConfig)
        socket = socketManager.defaultSocket
        registerHandlers()
        socketManager.connect()
    }
    
    public func registerForUser() {
        TTLog.warning("registerforuser: ", socketManager.status)
        socket.emit("register", "platform:status")
        socket.emit("register", NBClient.shared.getCurrentUser().resourceKey)
    }
    
    public func registerHandlers() {
        TTLog.warning("register socket handlers")
        
        socket.on(clientEvent: .connect) { (data, ackEmitter) in
            TTLog.warning("socket connected")
            self.registerForUser()
        }
        
        socket.on(NBClient.shared.getCurrentUser().resourceKey) { (data, ackEmitter) in
            TTLog.warning("socket received resourcekey")
            guard let message = data[0] as? String else { return }
            if let data = message.data(using: .utf8) {
                do {
                    let JSON : [String:AnyObject] = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String : AnyObject]
                    print("We've successfully parsed the message into a Dictionary! Yay!\n\(JSON)")
                    let action: String = JSON["action"] as! String
                    let itemType: String = JSON["itemType"] as! String
                    let updateUrl: String = JSON["updateUrl"] as! String
                    let updatedAt: String = JSON["updatedAt"] as! String
                    print("parsed: ", action, ", ", itemType, ", ", updateUrl, ", ", updatedAt)
                }
                catch let error {
                    print("Error parsing json: \(error)")
                }
            }
        }
        socket.on("platform:status") { (data, ackEmitter) in
            TTLog.warning("socket received platform status, ", data)
        }
        
        // socket.onAny {print("Got event: \($0.event), with items: \($0.items!)")}
    }
    
    
}
