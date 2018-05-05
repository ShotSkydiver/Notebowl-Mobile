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
        TTLog.debug("client shared init")
        let instance = NBClient()
        instance.getCurrentUser()
        return instance
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
    public var currentUserPic: UIImage!

    public var storedTypes = [ObjectIdentifier: [Object]!]()
    
    private init() { }
    
    func getCurrentUser() -> User {
        if currentUser == nil {
            let req = Just.get(User.routeType.returnRoute(), params: ["uuid": UIDevice().uuid])
            if req.statusCode != 200 {
                fatalError()
            }
            let reqJson = (req.json as AnyObject).value(forKeyPath: "result")!
            let map = Mapper<User>().map(JSONObject: reqJson)!
            
            currentUser = map
            
            if storedTypes[User.classIdentifier] == nil {
                storedTypes[User.classIdentifier] = [currentUser]
            }
            else if storedTypes[User.classIdentifier]!.first(where: {$0.resourceKey == currentUser.resourceKey}) == nil {
                storedTypes[User.classIdentifier]!.append(currentUser)
            }
        }
        else {
            if let storedUser = storedTypes[User.classIdentifier]!.first(where: { $0.resourceKey == currentUser.resourceKey }) {
                currentUser = storedUser as! User
            }
        }
        return currentUser
    }
    
    public func uploadToFiles(attachment: UIImage) -> String {
        
        let postUrl = ("https://\(NBClient.baseUrl)/rpc/v1.0/files/upload")
        let attReq = Just.post(
            postUrl,
            params: ["uuid": UIDevice().uuid],
            files:["files[]":.data("attachment.jpg", attachment.compressedData()!, "image/jpeg")])
        let res = (attReq.json as AnyObject).value(forKeyPath: "result")
        let fileid = (res as AnyObject).value(forKeyPath: "fileId") as! String
        TTLog.debug("OK! ", fileid)
        return fileid
    }
    
    public func logoutUser() {
        NBSocket.shared.manager.defaultSocket.removeAllHandlers()
        NBSocket.shared.manager.disconnect()
        let deleteReq = Just.delete(User.routeType.returnRoute(), params: ["uuid": UIDevice().uuid])
        if deleteReq.ok {
            currentUser = nil
            UserDefaults.set(hasUserLoggedIn: false)
        }
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
        /*
        if mutableArray is [Course] {
            mutableArray.sort() { ($0 as! Course).secondsSinceGradeUpdate > ($1 as! Course).secondsSinceGradeUpdate }
        }
        */
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
 
        return objectResult
    }
}
