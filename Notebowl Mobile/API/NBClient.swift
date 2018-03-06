//
//  NBClient.swift
//  Notebowl Mobile
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
    
    private init() { }
    
    public func getCurrentUser() -> User {
        NSLog("doing currentuser")
        if (self.currentUser == nil) {
            NSLog("currentuser null")
            self.currentUser = self.getMappable(User.self)?.first
        }
        return self.currentUser!
    }
    
    public func logoutUser() {
        let deleteReq = Just.delete(NBClient.defaultUrl, params: ["uuid": UIDevice().uuid])
        print("result of delete req: ", deleteReq.statusCode)
        UserDefaults.set(hasUserLoggedIn: false)

    }
    
    public func buildFilterString(from items: [Object]) -> String {
        var urlBuilder: String = ""
        for item in items {
            urlBuilder = (urlBuilder + item.url.absoluteString + ",")
        }
        return urlBuilder
    }
    
    public func initArray<T>(from array: [T]) -> [T]? where T: Object {
        var mutableArray = array
        for item in mutableArray {
            item.refresh()
        }
        mutableArray.sort() { $0.secondsSinceUpdate > $1.secondsSinceUpdate }
        
        return mutableArray
    }

    
    public func getMappable<T>(_ someObject: T.Type, filters: String? = "", sortBy: String? = "", limit: String? = "", completionHandler: (([T]?) -> Swift.Void)? = nil) -> [T]? where T: Object {
        var objectResult: [T]?
        
        let r = Just.get(someObject.routeType.returnRoute(), params: ["filters": "\(filters!)", "sortBy": sortBy!, "limit": limit!, "uuid": UIDevice().uuid])
        print("getmappable request: ", r.url!)
        
        if r.ok {
                let nestedData = try? JSONSerialization.data(withJSONObject: (r.json as AnyObject).value(forKeyPath: "result")!)
                objectResult = Mapper<T>().mapArray(JSONString: String(data: nestedData!, encoding: .utf8)!)
        }
        if (completionHandler != nil){
            completionHandler!(objectResult)
        }
 
        return objectResult
    }
    
}
