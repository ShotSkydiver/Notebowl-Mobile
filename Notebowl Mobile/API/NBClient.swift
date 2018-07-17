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
        case Local = "demo.notebowl.xyz"
    }

    static let baseUrl = Environment.Production.rawValue
    static let socketUrl = "https://socket.\((Environment.Production.rawValue.components(separatedBy: ".")[1])).com/"
    private var currentUser: User!
    public var storedTypes = [ObjectIdentifier: [NBModel]]()
    
    private init() { }
    
    func resolveCurrentUser(_ force: Bool? = false) -> Bool {
        if currentUser == nil || force! {
            TTLog.debug("currentuser nil!")
            print("app uuid:", UIDevice().uuid)
            let userTest = NBNetworking.shared.request(url: User.endpoint)
            if !userTest.statusCode!.isSuccess {
                return false
            }
            guard let userReq = NBClient.shared.getMappable(User.self) else {
                return false
            }

            if let finalUser = userReq.first {
                setCurrentUser(user: finalUser)
                return true
            }
            else {
                return false
            }
        }
        return true
    }
    
    func getCurrentUser() -> User {
        return currentUser
    }
    func setCurrentUser(user: User) {
        currentUser = user
    }
    
    public func logoutUser() {
        if NBSocket.shared.manager.status == .connected {
            NBSocket.shared.manager.defaultSocket.removeAllHandlers()
            NBSocket.shared.manager.disconnect()
        }
        _ = NBNetworking.shared.request(.delete, url: User.endpoint)
        currentUser = nil
        UserDefaults.set(hasUserLoggedIn: false)
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
        TTLog.debug("getmappable request: ", "\(result.statusCode!) - \(result.url!)")
        if !result.statusCode!.isSuccess || result.statusCode!.isServerError || result.statusCode!.isClientError {
            let exception = NSException(name:NSExceptionName(rawValue: "URLResponseError"), reason:"Error \(result.statusCode!): \(result.statusCode!.localizedReasonPhrase), url: \(result.url!.absoluteString)", userInfo:NBClient.shared.storedTypes)
            
            Bugsnag.notify(exception) { report in
                report.addMetadata(["uuid":"\(UIDevice().uuid)"], toTabWithName: "user")
            }
        }
            
        else {
            let nestedData = try? JSONSerialization.data(withJSONObject: (result.json as AnyObject).value(forKeyPath: "result")!)
            objectResult = Mapper<T>().mapArray(JSONString: String(data: nestedData!, encoding: .utf8)!)
            var newObjectArray = [T]()
            for object in objectResult! {
                
                if let objectExists = NBClient.shared.storedTypes[T.classIdentifier]?.first(where: {$0.resourceKey == object.resourceKey.lastPathComponent }) {
                    if object.updatedAt.timeIntervalSinceReferenceDate > objectExists.updatedAt.timeIntervalSinceReferenceDate {
                        TTLog.debug("new object is more recent than existing object!")
                        NBClient.shared.storedTypes[T.classIdentifier]![NBClient.shared.storedTypes[T.classIdentifier]!.index(of: objectExists)!] = object
                        newObjectArray.append(object)
                    }
                    else {
                        TTLog.debug("return existing object!")
                        newObjectArray.append((objectExists as! T))
                    }
                    
                }
                else {
                    object.firstTimeLoading = true
                    
                    if !NBClient.shared.storedTypes.has(key: T.classIdentifier) {
                        NBClient.shared.storedTypes[T.classIdentifier] = [object]
                    }
                    else if !NBClient.shared.storedTypes[T.classIdentifier]!.contains(where: {$0.resourceKey == object.resourceKey}) {
                        NBClient.shared.storedTypes[T.classIdentifier]!.append(object)
                    }
                    newObjectArray.append(object)
                }
            }
            if !(objectResult?.isEmpty)! || (objectResult?.count)! > 0 {
                NBClient.shared.storedTypes[T.classIdentifier]! = NBClient.shared.initArray(from: NBClient.shared.storedTypes[T.classIdentifier]!, refresh: false)!
                newObjectArray = NBClient.shared.initArray(from: newObjectArray, refresh: false)!
            }
            return newObjectArray
        }
        
        
        return objectResult
    }
    
    
    func delay(_ delay: Double, closure:@escaping () -> Void) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
}
