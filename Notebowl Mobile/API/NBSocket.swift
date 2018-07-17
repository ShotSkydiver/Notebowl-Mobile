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
    
    let manager = SocketManager(socketURL: URL(string: NBClient.socketUrl)!, config: [.log(true),.secure(true),.selfSigned(true),.forceNew(true)])
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
            TTLog.socket("connected")
            self.registerForUser()
        }
        manager.defaultSocket.on(NBClient.shared.getCurrentUser().resourceKey) { (data, emitter) in
            guard let message = data[0] as? String else { return }
            self.updateHandler(message: message)
        }
    }
    
    func updateHandler(message: String) {
        if let contentData = message.data(using: String.Encoding.utf8, allowLossyConversion: true) {
            do {
                
                let JSON = try JSONSerialization.jsonObject(with: contentData, options: .mutableContainers) as! [String : AnyObject]
                guard let updateUrlString = (JSON["updateUrl"] as? String) else { fatalError() }
                guard let updatedAtString = (JSON["updatedAt"] as? String) else { fatalError() }

                let mapped = Mapper<Generic>().map(JSON: ["itemType":"\(ItemType.fromURL(updateUrlString))", "updateUrl":"\(updateUrlString)", "action":"\((JSON["action"] as! String))", "updatedAt":"\(updatedAtString)"])
                
                guard let object = mapped!.genericObject else { return }
                
                if ["Enrollment","CourseUser","GroupUser"].contains(object.itemType.capitalised) {
                    if (object as! Enrollment).user.resourceKey != NBClient.shared.getCurrentUser().resourceKey {
                        TTLog.debug("enrollment object is NOT current user's")
                        if (object as! Enrollment).parent?.enrollmentForUser == nil {
                            TTLog.debug("current user isn't even enrolled in this course/group!")
                            return
                        }
                        else if !((object as! Enrollment).parent?.enrollmentForUser?.userRoleIsImportant)! {
                            TTLog.debug("current user's enrollment role is NOT professor or admin, ignoring this socket response")
                            return
                        }
                        else {
                            TTLog.debug("current user is either a professor or admin for this course/group, allowing socket response")
                        }
                    }
                    else {
                        TTLog.debug("enrollment object is current user's")
                    }
                }
                
                guard let tabbarVC = UIApplication.shared.keyWindow?.rootViewController!.presentedViewController as? MainTabBarViewController else {
                    TTLog.debug("tabController is not presented!")
                    return
                }
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
                                    TTLog.error("unknown actiontype!")
                                    return
                                }

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
