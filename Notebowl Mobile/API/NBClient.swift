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
import moa

public class NBClient {
    
    public static let shared = NBClient()
    public var baseUrl: String = "platform.notebowl.com"
    public static let defaultUrl = "https://\(NBClient.shared.baseUrl)/api/v1.0/credentials"
    public var currentUser: User?
    public var currentUserPic: UIImage!
    public var userProfilePicURL: URL!
 
    private init() { }
    
    public func getCurrentUser(force: Bool? = false) -> User {
        NSLog("doing currentuser")
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
                    print("userimage req ok")
                    let finalImg = UIImage(data: req.content!)
                    self.currentUserPic = finalImg!
                    try? Disk.save(finalImg!, to: .caches, as: "profilepic.jpg")
                }

            }
        }
        
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
        print("getmappable request: ", r.url!)
        
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
