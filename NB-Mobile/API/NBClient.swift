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

fileprivate enum BaseURL: String {
    case api = "https://demo.nbstage.com/api/v1.0/"
    case credentials = "credentials"
}

public class NBClient {
    
    public static let shared = NBClient()
    
    private var token: Token?
    public var currentUser: User?
    
    public var loginValidated: Bool = false
    
    private init() { }
    
    
    public func checkToken() {
        if Disk.exists("currentUser.json", in: .applicationSupport) {
            self.token = try? Disk.retrieve("currentUser.json", from: .applicationSupport, as: Token.self)
            let request = Just.get((BaseURL.api.rawValue + BaseURL.credentials.rawValue), params: self.token!.query)
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
    
    
    public func getCurrentUser() {
        let req = Just.get((BaseURL.api.rawValue + BaseURL.credentials.rawValue), params: self.token!.query)
        if (req.ok) {
            
            do {
                let reqJson = req.json
                let nestedJson = (reqJson as AnyObject).value(forKeyPath: "result")
                let itemType = (nestedJson as AnyObject).value(forKey: "itemType")
                
                print("nestedjson: ", itemType!)
                
                self.currentUser = try User(data: req.content!)
            }
            catch {
                print("error! ", error.localizedDescription)
            }
        }
    }
    
    
    public func logoutUser() {
        let deleteReq = Just.delete((BaseURL.api.rawValue + BaseURL.credentials.rawValue), params: self.token!.query)
        if (deleteReq.ok) {
            try? Disk.remove("currentUser.json", from: .applicationSupport)
        }

    }
    
    /*
 
         func getter (attrib): {BaseCollection]? {
         
         if let class = Static.indexClass(ucfirst(class)) {
         var collectionRef = new BaseCollection();
         load(collectionRef)
         return collectionRef as! [class.self]
         }
         }
 
     */
    
    
    public func get<T>(_ objectsOfType: T.Type, urlToGet: String? = nil, filters: String? = "", sortBy: String? = "", limit: String? = "") -> [NBProtocol]? where T: NBProtocol {
        let genericUrl = (BaseURL.api.rawValue + objectsOfType.routeName)
        
        let req = Just.get((urlToGet ?? genericUrl), params: ["filters": "\(filters!)", "sortBy": sortBy!, "limit": limit!, "token": self.token!.token, "uuid": self.token!.uuid])
        print("req: ", req.url!.absoluteString)
        
        if (req.ok) {
            
            guard let items = try? [T](data: req.content!) else {
                let item = try? T(data: req.content!)
                return [item!]
            }
            return items
        }
        return []
    }
    
}
