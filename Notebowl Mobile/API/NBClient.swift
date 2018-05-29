//
//  NBClient.swift
//  Notebowl Mobile
//
//  Created by Conner Owen on 11/28/17.
//  Copyright © 2017 NoteBowl. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper
import Bugsnag
import SocketIO

class NBClient {
    
    static let shared: NBClient = {
        return NBClient()
    }()
    
    enum Environment: String {
        case Production = "platform.notebowl.com"
        case Staging = "demo.nbstage.com"
    }
    #if DEBUG
    static let baseUrl = Environment.Production.rawValue
    #else
    static let baseUrl = Bundle.main.infoDictionary!["API_BASE_URL_ENDPOINT"] as! String
    #endif
    
    static let socketUrl = "https://socket.\((Environment.Production.rawValue.components(separatedBy: ".")[1])).com/"
    private var currentUser: User!
    public var storedTypes = [ObjectIdentifier: [Object]!]()
    
    private init() { }
    
    func resolveCurrentUser(_ completionHandler: @escaping (() -> Void)) {
        if currentUser == nil {
            TTLog.debug("currentuser nil!")
            
            // let userReq = getUrl(User.endpoint)
            let userReq = NBNetworking.shared.request(url: User.endpoint)
            
            if errorStatusCodes.contains(userReq.statusCode!.rawValue) {
                TTLog.error("error status code! ", userReq.statusCode!)
                logoutUser()
                (UIApplication.shared.keyWindow?.rootViewController as! RootViewController).dismiss(animated: true, completion: nil)
            }
            else {
                let reqJson = (userReq.json as AnyObject).value(forKeyPath: "result")!
                let map = Mapper<User>().map(JSONObject: reqJson)!
                self.currentUser = map
                
                if self.storedTypes[User.classIdentifier] == nil {
                    self.storedTypes[User.classIdentifier] = [self.currentUser]
                }
                else if self.storedTypes[User.classIdentifier]!.first(where: {$0.resourceKey == self.currentUser.resourceKey}) == nil {
                    self.storedTypes[User.classIdentifier]!.append(self.currentUser)
                }
                completionHandler()
            }
        }
        else {
            completionHandler()
        }
    }
    
    func getCurrentUser() -> User {
        return currentUser
    }
    
    public func logoutUser() {
        NBSocket.shared.manager.defaultSocket.removeAllHandlers()
        NBSocket.shared.manager.disconnect()
        let deleteReq = NBNetworking.shared.request(.delete, url: User.endpoint)
        currentUser = nil
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
        if mutableArray is [Comment] {
            mutableArray.sort() { $0.secondsSinceCreation < $1.secondsSinceCreation }
        }
        else if mutableArray is [Post] {
            mutableArray.sort() { $0.secondsSinceCreation > $1.secondsSinceCreation }
        }
        else {
            mutableArray.sort() { $0.secondsSinceCreation > $1.secondsSinceCreation }
        }
        return mutableArray
    }

    public func getMappable<T>(_ someObject: T.Type, filters: String? = "", sortBy: String? = "", limit: String? = "", completionHandler: (([T]?) -> Swift.Void)? = nil) -> [T]? where T: Object {
        var objectResult: [T]?
        
        
        // let group = DispatchGroup()
        
        // group.enter()
        //DispatchQueue.global(qos: .default).async {
        let req = NBNetworking.shared.request(url: someObject.endpoint, params: ["filters": "\(filters!)", "sortBy": sortBy!, "limit": limit!])
            // let req = getUrl(someObject.endpoint, params: ["filters": "\(filters!)", "sortBy": sortBy!, "limit": limit!])  // { r in
        TTLog.debug("getmappable request: ", "\(req.statusCode!) - \(req.url!)")
        if req.statusCode!.isSuccess {
            let nestedData = try? JSONSerialization.data(withJSONObject: (req.json as AnyObject).value(forKeyPath: "result")!)
            objectResult = Mapper<T>().mapArray(JSONString: String(data: nestedData!, encoding: .utf8)!)
        }
                // group.leave()
            // }
        //}

        // group.wait()
        // group.notify(queue: .main) {
        
        // }
        return objectResult
        
        //
        
        
        /*
        let r = Just.get(someObject.routeType.returnRoute(), params: ["filters": "\(filters!)", "sortBy": sortBy!, "limit": limit!, "uuid": UIDevice().uuid])
        TTLog.debug("getmappable request: ", r.url!)
        
        if r.statusCode != 200 || !r.ok {
            let exception = NSException(name:NSExceptionName(rawValue: "URLResponseError"),
                                        reason:"Error \(r.statusCode!): \(r.reason), url: \(r.url!.absoluteString)",
                userInfo:nil)
            Bugsnag.notify(exception)
        }
        if r.ok {
            let nestedData = try? JSONSerialization.data(withJSONObject: (r.json as AnyObject).value(forKeyPath: "result")!)
            objectResult = Mapper<T>().mapArray(JSONString: String(data: nestedData!, encoding: .utf8)!)
        }
        if (completionHandler != nil){
            completionHandler!(objectResult)
        }
        */

        
    }
}
