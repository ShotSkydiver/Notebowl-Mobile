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
    
    
    public func getCurrentUser() -> User? {
        let req = Just.get((BaseURL.api.rawValue + BaseURL.credentials.rawValue), params: self.token!.query)
        if (req.ok) {
            do {
                let user = try User(data: req.content!)
                return user
            }
            catch {
                print("error! ", error.localizedDescription)
            }
        }
        return nil
    }
    
    
    
    public func logoutUser() {
        let deleteReq = Just.delete((BaseURL.api.rawValue + BaseURL.credentials.rawValue), params: self.token!.query)
        if (deleteReq.ok) {
            try? Disk.remove("currentUser.json", from: .applicationSupport)
        }
        
        let webVC = NBAuthViewController()
        UIApplication.shared.keyWindow?.rootViewController?.present(webVC, animated: true, completion: nil)
    }
    
    public func get<T>(_ objectsOfType: T.Type) -> [NBItem]? where T: NBItem {
        let req = Just.get((BaseURL.api.rawValue + objectsOfType.routeName), params: self.token!.query)
        
        if (req.ok) {
            let items = try? [T](data: req.content!)
            return items
        }
        return []
    }
}
