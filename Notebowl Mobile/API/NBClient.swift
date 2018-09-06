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
import SwipeCellKit

class NBClient {
    
    static let shared: NBClient = {
        return NBClient()
    }()
    
    enum Environment: String {
        case Production = "platform.notebowl.com"
        case Local = "demo.notebowl.xyz"
        case Jenkins = "demoo.notebowl.xyz"
    }
    #if DEBUG
    static let baseUrl = Environment.Production.rawValue
    static let socketUrl = "https://\(Environment.Production.rawValue)/socket.io/"
    #else
    static let baseUrl = Environment.Production.rawValue
    static let socketUrl = "https://socket.\((Environment.Production.rawValue.components(separatedBy: ".")[1])).com/"
    #endif
    private var currentUser: User!
    public var storedTypes = [ObjectIdentifier: [NBModel]]()
    
    
    private init() { }

    func resolveCurrentUser(_ force: Bool = true) -> Bool {
        if currentUser == nil || force {
            let userTest = NBNetworking.shared.request(url: User.endpoint)
            if userTest.statusCode == nil { return false }
            if !userTest.statusCode!.isSuccess { return false }
            guard let userReq = NBClient.shared.getMappable(User.self) else { return false }
            if let finalUser = userReq.first {
                setCurrentUser(user: finalUser)
                Bugsnag.configuration()!.setUser(finalUser.resourceKey, withName: finalUser.fullName, andEmail: finalUser.email!)
                Bugsnag.addAttribute("uuid", withValue: "\(UIDevice().uuid)", toTabWithName: "user")
                return true
            }
        }
        else if currentUser != nil { return true }
        
        return false
    }
    
    func getCurrentUser() -> User {
        return currentUser
    }
    func setCurrentUser(user: User) {
        currentUser = user
    }
 
    public func resetApp(andLogoutUser logout: Bool) {
        if NBSocket.shared.manager.status == .connected {
            NBSocket.shared.manager.disconnect()
            NBSocket.shared.manager.defaultSocket.removeAllHandlers()
        }
        if logout {
            let delReq = NBNetworking.shared.request(.delete, url: User.endpoint)
            guard let nullResult = (delReq.json as AnyObject).value(forKeyPath: "result") as? NSNull else { fatalError() }
        }
        currentUser = nil
        NBClient.shared.storedTypes = [ObjectIdentifier: [NBModel]]()
        let rootViewController = UIApplication.shared.keyWindow?.rootViewController as! RootViewController
        rootViewController.dismiss(animated: true, completion: nil)
    }
    
    public func doEnrollmentRequests() -> String? {
        let reqEnroll = NBNetworking.shared.request(url: Enrollment.endpoint, params: ["filters": "[\"_user:IN:\(NBClient.shared.getCurrentUser().url.absoluteString)\"]"])
        let nestedJson = (reqEnroll.json as AnyObject).value(forKeyPath: "result")!

        var coursesFilter: String = ""
        var groupsFilter: String = ""
        var combinedUrlsFilter: String = ""
        
        guard let keyPaths = nestedJson as? [[String: Any]] else { return "" }
        for key in keyPaths {
            let urlString = (key["_parent"] as! String)
            let objectType = ItemType.fromURL(urlString)
            let resKey = URL(string: urlString)!.lastPathComponent
            objectType == .course ? (coursesFilter = (coursesFilter + resKey + ",")) : (objectType == .group ? (groupsFilter = (groupsFilter + resKey + ",")) : TTLog.debug("neither course nor group!"))
            combinedUrlsFilter = (combinedUrlsFilter + urlString + ",")
        }
        let courseReq = NBClient.shared.getMappable(Course.self, filters: "[\"resourceKey:IN:\(coursesFilter)\"]")
        let groupReq = NBClient.shared.getMappable(Group.self, filters: "[\"resourceKey:IN:\(groupsFilter)\"]")
        
        let mappy = Mapper<Enrollment>().mapArray(JSONArray: keyPaths)
        let storedEnrolls = NBClient.shared.storeObjectsInCache(mappy)

        return combinedUrlsFilter
    }
    
    
    public func buildFilterArray(from items: [NBModel]) -> [String] {
        var filterArray = [String]()
        for item in items {
            filterArray.append(item.url.absoluteString)
        }
        return filterArray
    }
    
    public func reinitCache(refresh: Bool? = true) {
        for objectType in NBClient.shared.storedTypes {
            var newArray = objectType.value
            newArray = initArray(from: newArray, refresh: refresh)!
        }
    }
    
    public func initArray<T>(from array: [T], refresh: Bool? = true) -> [T]? where T: NBModel {
        var mutableArray = array
        if refresh! {
            for item in mutableArray {
                item.refresh()
                if item is WithName { (item as! WithName).firstTimeLoaded() }
            }
        }
        
        if mutableArray is [Comment] {
            mutableArray.sort() { $0.secondsSinceCreation < $1.secondsSinceCreation }
        }
        else if mutableArray is [Course] {
            mutableArray.sort() { $0.secondsSinceUpdate > $1.secondsSinceUpdate }
        }

        else {
            mutableArray.sort() { $0.secondsSinceCreation > $1.secondsSinceCreation }
        }
        return mutableArray
    } 

    public func requireByResourceKeys<T>(_ object: T.Type, keys: [String]) -> [T]? where T: NBModel {
        var filterString: String = ""
        for key in keys {
            filterString = (filterString + key + ",")
        }
        let req = NBClient.shared.getMappable(object, filters: "[\"resourceKey:IN:\(filterString)\"]")
        return req
    }
    public func requireByReferences<T>(_ object: T.Type, property: String, values: [NBModel]) -> [T]? where T: NBModel {
        var filterString: String = ""
        for value in values {
            filterString = (filterString + value.url.absoluteString + ",")
        }
        let req = NBClient.shared.getMappable(object, filters: "[\"\(property):IN:\(filterString)\"]")
        return req
    }

    public func requireByReference<T>(_ object: T.Type, property: String, value: NBModel) -> [T]? where T: NBModel {
        let filterString = "_\(property)"
        let req = NBClient.shared.getMappable(object, filters: "[\"\(filterString):IN:\(value.url.absoluteString)\"]")
        return req
    }

    public func getMappable<T>(_ someObject: T.Type, url: String? = nil, filters: String? = "", sortBy: String? = "", limit: String? = "", completionHandler: (([T]?) -> Void)? = nil) -> [T]? where T: NBModel {
        var objectResult: [T]?
        let requestURL: String = url != nil ? url! : someObject.endpoint
    
        let result = NBNetworking.shared.request(url: requestURL, params: ["filters": "\(filters!)", "sortBy": sortBy!, "limit": limit!])
        
        if result.statusCode == nil {
            NBClient.shared.sendBugsnagException(fromResult: result)
            return nil
        }
        else if !result.statusCode!.isSuccess {
            NBClient.shared.sendBugsnagException(fromResult: result)
            return nil
        }
        else {
            TTLog.debug("getmappable request: ", "\(result.statusCode!) - \(result.url!)")
            let nestedData = try? JSONSerialization.data(withJSONObject: (result.json as AnyObject).value(forKeyPath: "result")!)
            let mapped = Mapper<T>().mapArray(JSONString: String(data: nestedData!, encoding: .utf8)!)
            objectResult = NBClient.shared.storeObjectsInCache(mapped)
        }
        return objectResult
    }
  
    
    func storeObjectsInCache<T>(_ objects: [T]?) -> [T]? where T: NBModel {
        if objects == nil { return nil }
        
        var newObjectArray = [T]()
        for object in objects! {
            if let objectExists = NBClient.shared.storedTypes[T.classIdentifier]?.first(where: {$0 == object}) {
                if object.updatedAt.timeIntervalSinceReferenceDate > objectExists.updatedAt.timeIntervalSinceReferenceDate {
                    object.firstTimeLoading = false
                    TTLog.debug("new object is more recent than existing object!")
                    NBClient.shared.storedTypes[T.classIdentifier]![NBClient.shared.storedTypes[T.classIdentifier]!.index(of: objectExists)!] = object
                    newObjectArray.append(object)
                }
                else {
                    objectExists.firstTimeLoading = false
                    TTLog.debug("return existing object!")
                    newObjectArray.append((objectExists as! T))
                }
            }
            else {
                object.firstTimeLoading = true
                
                if !NBClient.shared.storedTypes.has(key: T.classIdentifier) {
                    NBClient.shared.storedTypes[T.classIdentifier] = [object]
                }
                else {
                    NBClient.shared.storedTypes[T.classIdentifier]!.append(object)
                }
                newObjectArray.append(object)
            }
        }
        if !(objects?.isEmpty)! || (objects?.count)! > 0 {
            NBClient.shared.storedTypes[T.classIdentifier]! = NBClient.shared.initArray(from: NBClient.shared.storedTypes[T.classIdentifier]!, refresh: false)!
            newObjectArray = NBClient.shared.initArray(from: newObjectArray, refresh: false)!
        }
        return newObjectArray
    }
    
    func sendBugsnagException(fromResult: NBResult) {
        var exception: NSException!
        if fromResult.statusCode == nil || fromResult.error != nil {
            exception = NSException(name:NSExceptionName(rawValue: "URLResponseError"), reason:"Error statusCode is nil: \(fromResult.error!), url: \(fromResult.url!.absoluteString)", userInfo:NBClient.shared.storedTypes)
        }
        else {
            TTLog.debug("getmappable error: ", "\(fromResult.statusCode!) - \(fromResult.url!)")
            exception = NSException(name:NSExceptionName(rawValue: "URLResponseError"), reason:"Error \(fromResult.statusCode!): \(fromResult.statusCode!.localizedReasonPhrase), url: \(fromResult.url!.absoluteString)", userInfo:NBClient.shared.storedTypes)
        }
        Bugsnag.notify(exception)
    }
    
    
    func delay(_ delay: Double, closure:@escaping () -> Void) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
}
