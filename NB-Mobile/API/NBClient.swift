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
    
    public var token: Token?
    public var currentUser: User?
    
    public var loginValidated: Bool = false
    
    private init() { }
    
    public func checkToken() {
        if Disk.exists("currentUser.json", in: .applicationSupport) {
            self.token = try? Disk.retrieve("currentUser.json", from: .applicationSupport, as: Token.self)
            let request = Just.get(NBClient.defaultUrl, params: self.token!.query)
            if (request.ok) {
                self.loginValidated = true
                return
            }
        }
        self.loginValidated = false
        return
    }
    
    public func parseToken(from data: Any?) throws {
        self.token = try? Token(json: (data as! String))
        try? Disk.save(self.token, to: .applicationSupport, as: "currentUser.json")
        self.loginValidated = true
    }
    
    
    public func getCurrentUser() -> User {
        self.currentUser = self.getMappable(User.self)?.first
        return self.currentUser!
    }
    
    public func logoutUser() {
        let deleteReq = Just.delete(NBClient.defaultUrl, params: self.token!.query)
        if (deleteReq.ok) {
            try? Disk.remove("currentUser.json", from: .applicationSupport)
        }
    }
    
    public func getMappable<T>(_ someObject: T.Type, filters: String? = "", sortBy: String? = "", limit: String? = "") -> [T]? where T: Object {
        let req = Just.get(someObject.routeType.returnRoute(), params: ["filters": "\(filters!)", "sortBy": sortBy!, "limit": limit!, "token": self.token!.token, "uuid": self.token!.uuid])
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
