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
import Kingfisher
import Disk
import SocketIO

public class NBClient {
    
    public static let shared = NBClient()
    
    #if DEBUG
    enum Environment: String {
        case Production = "platform.notebowl.com"
        case Staging = "demo.nbstage.com"
    }
    public let baseUrl = Environment.Production.rawValue
    #else
    public let baseUrl = Bundle.main.infoDictionary!["API_BASE_URL_ENDPOINT"] as! String
    #endif
 
    public static let defaultUrl = "https://\(NBClient.shared.baseUrl)/api/v1.0/credentials"
    public var currentUser: User?
    public var currentUserPic: UIImage!
    public var userProfilePicURL: URL!
    
    public var storedTypes = [ObjectIdentifier: [Object]!]()
    
    private init() { }
    
    public func getCurrentUser(force: Bool? = false) -> User {
        NSLog("doing currentuser ")
        if (self.currentUser == nil) || (force)! {
            NSLog("currentuser null")
            self.currentUser = self.getMappable(User.self)?.first
        }
        return self.currentUser!
    }
    
    public func updateUserAvatar(image: UIImage? = nil) {
        if image != nil {
            self.currentUserPic = image!
            try? Disk.save(image!, to: .caches, as: "profilepic.jpg")
        }
        else if image == nil {
            if Disk.exists("profilepic.jpg", in: .caches) {
                let localImage = try? Disk.retrieve("profilepic.jpg", from: .caches, as: UIImage.self)
                self.currentUserPic = localImage!
            }
            else {
                let req = Just.get(NBClient.shared.currentUser!.profileUrl)
                if req.ok {
                    TTLog.debug("userimage req ok")
                    let finalImg = UIImage(data: req.content!)
                    self.currentUserPic = finalImg!
                    try? Disk.save(finalImg!, to: .caches, as: "profilepic.jpg")
                }
            }
        }
    }
    
    public func uploadToFiles(attachment: UIImage) -> String {
        
        let postUrl = ("https://\(NBClient.shared.baseUrl)/rpc/v1.0/files/upload")
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
        let deleteReq = Just.delete(NBClient.defaultUrl, params: ["uuid": UIDevice().uuid])
        if deleteReq.ok {
            try? Disk.remove("profilepic.jpg", from: .caches)
            NBClient.shared.currentUser = nil
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
        mutableArray.sort() { $0.secondsSinceUpdate > $1.secondsSinceUpdate }
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
