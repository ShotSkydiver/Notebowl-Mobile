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



fileprivate enum Query: String {
    var url: URL? {
        switch self {
        case .api:
            return URL(string: self.rawValue)
        case .authorize, .users, .courses:
            return URL(string: Query.api.rawValue + self.rawValue)
        }
    }
    
    case api = "https://demo.nbstage.com/api/v1.0/"
    
    case users = "users"
    case authorize = "credentials"
    
    case courses = "courses"
    
}


public class NBClient {
    
    private class Token: Codable {
        var token: String
        var uuid: String
        
        var debugDetails: NSString {
            return  """
                Saved token:  \(token)
                Device UUID:    \(uuid)
                """ as NSString
        }
        
        var query: [String: Any] {
            return ["token": token, "uuid": uuid]
        }
        
    }
    
    
    
    public static let shared = NBClient()
    
    private var token: Token?
    
    private init() { }
    
    
    public func checkToken() -> Bool {
        self.token = try? Disk.retrieve("currentUser.json", from: .applicationSupport, as: Token.self)
        let request = Just.get(Query.authorize.url!, params: self.token!.query)
        if (request.ok) {
            return true
        }
        return false
    }
    
    public func parseToken(from data: Any?) throws {
        self.token = try? Token(json: (data as! String))
        try? Disk.save(self.token, to: .applicationSupport, as: "currentUser.json")
    }
    
    
    public func getCurrentUser() -> User? {
        let req = Just.get(Query.authorize.url!, params: self.token!.query)
        let user = try? User(data: req.content!)
        return user
    }
    
    public func logoutUser() {
        let deleteReq = Just.delete(Query.authorize.url!, params: self.token!.query)
        if (deleteReq.ok) {
            try? Disk.remove("currentUser.json", from: .applicationSupport)
        }
        
        let webVC = NBAuthViewController()
        UIApplication.shared.keyWindow?.rootViewController?.present(webVC, animated: true, completion: nil)
    }
    
    
    
    public func getAllCourses() -> [Course]? {
        let req = Just.get(Query.courses.url!, params: self.token!.query)
        if (req.ok) {
            let courses = try? [Course](data: req.content!)
            return courses
        }
        return nil
    }
}
