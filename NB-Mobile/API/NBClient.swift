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


fileprivate enum NotebowlQuery: String {
    var url: URL? {
        switch self {
        case .api:
            return URL(string: self.rawValue)
        case .authorize, .users:
            return URL(string: NotebowlQuery.api.rawValue + self.rawValue)
        }
    }
    
    case api = "https://demo.nbstage.com/api/v1.0/"

    case users = "users"
    case authorize = "credentials"
    

}



public class NBClient {
    

    private class NotebowlToken: Codable {
        var token: String
        var uuid: String
        
        
        var debugDetails: NSString {
            return  """
                Saved token:  \(token)
                Device UUID:    \(uuid)
                """ as NSString
        }
        
    }
    
    public static let shared = NBClient()
    
    private var token: NotebowlToken?
    
    
    private init() { }
    
    
    public func writeToken() throws {
        try? Disk.save(self.token, to: .applicationSupport, as: "currentUser.json")
    }
    
    
    public func checkToken() -> Bool {
        self.token = try? Disk.retrieve("currentUser.json", from: .applicationSupport, as: NotebowlToken.self)
        var request = Just.get((NotebowlQuery.authorize.url?.absoluteString)!, params:["token": self.token!.token, "uuid": self.token!.uuid])
        if (request.ok) {
            return true
        }
        return false
    }
    
    
    public func parseToken(from data: Any?) -> Bool {
        self.token = try? NotebowlToken(json: (data as! String))
        if let token = self.token {
            return true
        }
        return false
    }
    
    
    
}
