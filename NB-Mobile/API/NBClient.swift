//
//  NBClient.swift
//  NB-Mobile
//
//  Created by Conner Owen on 11/28/17.
//  Copyright © 2017 NoteBowl. All rights reserved.
//

import Foundation
import UIKit
import Disk
import ObjectMapper

public class NBClient {
    
    public static let shared = NBClient()
    public static let defaultUrl = "https://demo.nbstage.com/api/v1.0/credentials"

    public var currentUser: User?
    public var deviceToken: String?
    public var loginValidated: Bool = false
    
    private init() { }
    
    public func checkToken() {
            let request = Just.get(NBClient.defaultUrl, params: ["uuid": UIDevice().uuid])
            if (request.ok) {
                self.loginValidated = true
                return
            }
        self.loginValidated = false
        return
    }
    
    public func registerNotificationsToken() {
        let req = Just.get("https://demo.nbstage.com/gateway/services/mobile/notifications/enable", params: ["uuid": UIDevice().uuid, "token": self.deviceToken!])
        print("pushregister req: ", req.url!.absoluteString)
        if (req.ok) {
            print("register ok! ", req.json)
        }
    }
    
    public func getCurrentUser() -> User {
        self.currentUser = self.getMappable(User.self)?.first
        return self.currentUser!
    }
    
    public func logoutUser() {
        let deleteReq = Just.delete(NBClient.defaultUrl, params: ["uuid": UIDevice().uuid])
        if (deleteReq.ok) {
            let defaults = UserDefaults.standard
            defaults.set(false, forKey: "com.notebowl.standalone.userLoggedIn")
        }
    }
    
    public func getMappable<T>(_ someObject: T.Type, filters: String? = "", sortBy: String? = "", limit: String? = "") -> [T]? where T: Object {
        let req = Just.get(someObject.routeType.returnRoute(), params: ["filters": "\(filters!)", "sortBy": sortBy!, "limit": limit!, "uuid": UIDevice().uuid])
        print("req: ", req.url!.absoluteString)
        if (req.ok) {
            let reqJson = req.json
            let nestedJson = (reqJson as AnyObject).value(forKeyPath: "result")
            let nestedData = try? JSONSerialization.data(withJSONObject: nestedJson!)
            let jsonstring = String(data: nestedData!, encoding: .utf8)
            
            let items = Mapper<T>().mapArray(JSONString: jsonstring!)!
            return items
        }
        return []
    }
}
