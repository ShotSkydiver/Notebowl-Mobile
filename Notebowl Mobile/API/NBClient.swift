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
import HTTPStatusCodes

class NBClient {
    static let shared: NBClient = {
        return NBClient()
    }()

    private var currentUser: User!
    public var storedTypes = [ItemType: [NBModel]]()

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
        } else if currentUser != nil { return true }

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
        NBClient.shared.storedTypes = [ItemType: [NBModel]]()
        let rootViewController = UIApplication.shared.keyWindow?.rootViewController as! RootViewController
        rootViewController.dismiss(animated: true, completion: nil)
    }

    public func doEnrollmentRequests() -> String {
        let reqEnroll = NBNetworking.shared.request(url: Enrollment.endpoint, params: ["filters": "[\"_user:IN:\(NBClient.shared.getCurrentUser().url.absoluteString)\"]"])
        let nestedJson = (reqEnroll.json as AnyObject).value(forKeyPath: "result")

        var coursesFilter: String = ""
        var groupsFilter: String = ""
        var combinedUrlsFilter: String = ""

        guard let keyPaths = nestedJson as? [[String: Any]] else { return "" }
        for key in keyPaths {
            if let urlString = key["_parent"] as? String, let objectType = ItemType.fromURL(urlString) {
                let resKey = URL(string: urlString)!.lastPathComponent
                objectType == .course ? (coursesFilter = (coursesFilter + resKey + ",")) : (objectType == .group ? (groupsFilter = (groupsFilter + resKey + ",")) : log.debug("neither course nor group!"))
                combinedUrlsFilter = (combinedUrlsFilter + urlString + ",")
            }
        }
        _ = NBClient.shared.getMappable(Course.self, filters: "[\"resourceKey:IN:\(coursesFilter)\"]")
        _ = NBClient.shared.getMappable(Group.self, filters: "[\"resourceKey:IN:\(groupsFilter)\"]")

        let mappedEnrollments = Mapper<Enrollment>().mapArray(JSONArray: keyPaths)
        for object in mappedEnrollments {
            storeObjectInCache(object)
        }

        return combinedUrlsFilter
    }

    public func buildFilterString(from items: [NBModel]) -> String {
        var filterString: String = ""
        for item in items {
            filterString = (filterString + item.url.absoluteString + ",")
        }
        return filterString
    }

    public func reinitCache() {
        for objectType in NBClient.shared.storedTypes {
            var newArray = objectType.value
            newArray.refreshAll()
            newArray.sortByDate()
        }
    }

    public func requireByResourceKeys<T>(_ object: T.Type, keys: [String]) -> [T]? where T: NBModel {
        var filterString: String = ""
        for key in keys {
            filterString = (filterString + key + ",")
        }
        let req = NBClient.shared.getMappable(object, filters: "[\"resourceKey:IN:\(filterString)\"]")
        return req
    }

    public func requireByReferences<T>(_ object: T.Type, property: String, values: [NBModel]) -> [T] where T: NBModel {
        var filterString: String = ""
        for value in values {
            filterString = (filterString + value.url.absoluteString + ",")
        }
        guard let req = getMappable(object, filters: "[\"\(property):IN:\(filterString)\"]") else { return [] }
        return req
    }

    public func requireByReference<T>(_ object: T.Type, property: String, value: NBModel) -> [T] where T: NBModel {
        let filterString: String = "_\(property)"
        guard let req = getMappable(object, filters: "[\"\(filterString):IN:\(value.url.absoluteString)\"]") else { return [] }
        return req
    }

    public func cacheMappable<T>(object: T) -> T where T: NBModel {
        let cachedObject = storeObjectInCache(object)

        NotificationCenter.default.post(name: NSNotification.Name("ModelDidBeginUpdating\(cachedObject.itemType.className)"), object: nil, userInfo: ["object": cachedObject])
        NotificationCenter.default.post(name: NSNotification.Name("ModelDidFinishUpdating\(cachedObject.itemType.className)"), object: nil, userInfo: ["object": cachedObject])

        return cachedObject
    }

    public func decacheMappable(object: NBModel) {
        if type(of: object).getCache().contains(object) {
            type(of: object).removeFromCache(object: object)
            NotificationCenter.default.post(name: NSNotification.Name("ModelWillDelete\(object.itemType.className)"), object: nil, userInfo: ["object": object])
            NotificationCenter.default.post(name: NSNotification.Name("ModelDidBeginDeleting\(object.itemType.className)"), object: nil, userInfo: ["object": object])
            NotificationCenter.default.post(name: NSNotification.Name("ModelDidFinishDeleting\(object.itemType.className)"), object: nil, userInfo: ["object": object])
        }
    }

    public func decacheMappable(object: String) {
        if let cachedObject = storedTypes[ItemType.fromURL(object)]?.first(where: { $0.resourceKey == URL(string: object)!.lastPathComponent }) {
            decacheMappable(object: cachedObject)
        }
    }

    public func getMappable<T>(_ someObject: T.Type, url: String? = nil, filters: String! = "", sortBy: String! = "", limit: String! = "") -> [T]! where T: NBModel {
        let requestUrl: String = url ?? someObject.endpoint

        var payload: [String: String] = [:]
        if let filter: String = filters { payload += ["filters": filter] }
        if let sort: String = sortBy { payload += ["sortBy": sort] }
        if let limits: String = limit { payload += ["limit": limits] }

        let result: NBResult = NBNetworking.shared.request(url: requestUrl, params: payload)
        if let resultStatus = result.statusCode, let resultUrl = result.url, resultStatus.isSuccess {
            log.debug("URL Request: \(resultStatus) - \(resultUrl.absoluteString)")

            if let jsonObject = result.json as AnyObject?, let nestedJson = jsonObject.value(forKeyPath: "result"), let nestedData = try? JSONSerialization.data(withJSONObject: nestedJson), let nestedString = String(data: nestedData, encoding: .utf8) {
                guard let mapped: [T] = Mapper<T>().mapArray(JSONString: nestedString) else { return nil }

                var newObjectArray = [T]()

                for object in mapped {
                    let cachedObject = NBClient.shared.cacheMappable(object: object)
                    newObjectArray.append(cachedObject)
                }

                return newObjectArray
            }
        } else {
            NBClient.shared.sendBugsnagException(fromResult: result)
            return []
        }
        return nil
    }

    func storeObjectInCache<T>(_ object: T) -> T where T: NBModel {
        if let pos = storedTypes[T.routeType]?.firstIndex(of: object), let existingObj = storedTypes[T.routeType]?[pos] {
            if object.updatedAt > existingObj.updatedAt {
                storedTypes[T.routeType]![pos] = object
            } else if object.updatedAt <= existingObj.updatedAt, let newObj = existingObj as? T {
                return newObj
            }
        } else {
            if let oldData = storedTypes.updateValue([object], forKey: T.routeType) {
                storedTypes[T.routeType]!.append(contentsOf: oldData)
            }
        }
        storedTypes[T.routeType]!.sortByDate()

        return object
    }

    func sendBugsnagException(fromResult: NBResult) {
        var exception: NSException!
        if fromResult.statusCode == nil, let resultError = fromResult.error as NSError? {
            exception = NSException(name: NSExceptionName(rawValue: "URLResponseError"), reason: "Error statusCode is nil: \(resultError.localizedDescription), url: \(resultError.domain)", userInfo: resultError.userInfo )
        } else if let statusCode: HTTPStatusCode = fromResult.statusCode, let resultUrl: URL = fromResult.url {
            log.debug("getmappable error: \(statusCode) - \(resultUrl.absoluteString)")
            exception = NSException(name: NSExceptionName(rawValue: "URLResponseError"), reason: "Error \(statusCode): \(statusCode.localizedReasonPhrase), url: \(resultUrl.absoluteString)", userInfo: nil)
        }
        Bugsnag.notify(exception)
    }

    func delay(_ delay: Double, closure:@escaping () -> Void) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
}

extension Collection {
    /// SwifterSwift: Performs `each` closure for each element of collection in parallel.
    ///
    ///        array.forEachInParallel { item in
    ///            print(item)
    ///        }
    ///
    /// - Parameter each: closure to run for each element.
    public func forEachInParallel(_ each: (Self.Element) -> Void) {
        let indicesArray = Array(indices)

        DispatchQueue.concurrentPerform(iterations: indicesArray.count) { (index) in
            let elementIndex = indicesArray[index]
            each(self[elementIndex])
        }
    }
}

extension Array {
    mutating func refreshAll() {
        for element in self {
            guard element is NBModel else { fatalError() }
            (element as! NBModel).refresh()
        }
    }

    mutating func sortByDate() {
        if self is [Course] {
            sort() { ($0 as! NBModel).updatedAt > ($1 as! NBModel).updatedAt }
        } else if self is [AssignmentAssessment] {
            sort() { ($0 as! NBModel).updatedAt > ($1 as! NBModel).updatedAt }
        } else if self is [Comment] {
            sort() { ($0 as! NBModel).createdAt < ($1 as! NBModel).createdAt }
        } else if self is [Post] {
            sort() { ($0 as! Post).availableDate > ($1 as! Post).availableDate }
        } else if self is [NBModel] {
            sort() { ($0 as! NBModel).createdAt > ($1 as! NBModel).createdAt }
        }
    }
}

extension Array where Element: Equatable {
    func containSameElements(_ array: [Element]) -> Bool {
        var selfCopy = self
        var secondArrayCopy = array

        while let firstItem = selfCopy.popLast() {
            if let indexOfFirstItem = secondArrayCopy.index(of: firstItem) {
                let secondRemoved = secondArrayCopy.remove(at: indexOfFirstItem)
                if (firstItem as! NBModel).updatedAt.timeIntervalSinceReferenceDate != (secondRemoved as! NBModel).updatedAt.timeIntervalSinceReferenceDate {
                    return false
                }
            } else {
                return false
            }
        }
        return secondArrayCopy.isEmpty
    }
}
