//
//  MappableModels.swift
//  Notebowl Mobile
//
//  Created by Conner Owen on 1/10/18.
//  Copyright © 2018 NoteBowl. All rights reserved.
//

import Foundation
import ObjectMapper

public enum ItemType: String {
    case user = "credentials"
    case term = "terms"
    case course = "courses"
    case assignment = "assignments"
    case category = "categories"
    case grade = "grades"
    case university = "universities"
    case enrollment = "enrollments"
    case post = "posts"
    case comment = "comments"
    case like = "likes"
    case notification = "notifications"
}

extension ItemType {
    func returnRoute() -> String {
        let route = self.rawValue
        
        return ("https://demo.nbstage.com/api/v1.0/" + route)
    }
}

@objc public class Object: NSObject, Mappable {
    
    var createdAt: Date!
    var updatedAt: Date!
    var itemType: String!
    var url: URL!
    var resourceKey: String!
    
    class var routeType: ItemType { return .user }
    
    public var secondsSinceUpdate: TimeInterval { return self.updatedAt.timeIntervalSinceReferenceDate }
    
    public func refresh() { }
    
    public required init?(map: Map) { }
    
    override init() {}
 
    public func mapping(map: Map) {
        createdAt <- (map["createdAt"], ISO8601FixedDateTransform())
        updatedAt <- (map["updatedAt"], ISO8601FixedDateTransform())
        itemType <- map["itemType"]
        url <- (map["url"], URLTransform(shouldEncodeURLString: true, allowedCharacterSet: .urlQueryAllowed))
        resourceKey <- map["resourceKey"]
    }
}

public class User: Object {

    var firstName: String!
    var lastName: String!
    var email: String?
    var profileUrl: URL!
    var profileThumbUrl: URL!
    var university: University?
    
    var fullName: String { return (firstName + " " + lastName) }
    
    override class var routeType: ItemType { return .user }
    
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        firstName <- map["firstName"]
        lastName <- map["lastName"]
        email <- map["email"]
        profileUrl <- (map["profileUrl"], ImageTransform())
        profileThumbUrl <- (map["profileThumbUrl"], ImageTransform())

    }
}

class Term: Object {
    
    var title: String?
    var termStart: Date!
    var termEnd: Date!
    var termAvailable: Date!
    var university: University?
    
    override class var routeType: ItemType { return .term }
    
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        title <- map["title"]
        termStart <- (map["termStart"], ISO8601FixedDateTransform())
        termEnd <- (map["termEnd"], ISO8601FixedDateTransform())
        termAvailable <- (map["termAvailable"], ISO8601FixedDateTransform())
        university <- (map["_university"], ObjectTransform<University>())
    }
}

class Course: Object {
    
    var name: String!
    var number: String!
    var subject: String!
    var units: Int?
    var location: String?
    var desc: String?
    var courseCode: String { return (subject + " " + number) }
    
    public var lastUpdated: String?
    public var secondsSinceGradeUpdate: TimeInterval?

    public var categories: [Category]!
        
    override class var routeType: ItemType { return .course }
    
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        name <- map["name"]
        number <- map["number"]
        subject <- map["subject"]
        units <- map["units"]
        location <- map["location"]
        desc <- map["description"]
    }
    
    override public func refresh() {
        categories = NBClient.shared.getMappable(Category.self, filters: "[\"_parent:IN:\(self.url.absoluteString)\"]")
        
        let assignmentsFilter = NBClient.shared.buildFilterString(from: NBClient.shared.getMappable(Assignment.self, filters: "[\"_parent:IN:\(self.url.absoluteString)\"]")!)
        let recentGrade = NBClient.shared.getMappable(Grade.self, filters: "[\"_parent:IN:\(assignmentsFilter)\"]", sortBy: "updatedAt:desc", limit: "1")
        
        if (recentGrade?.first != nil) {
            self.lastUpdated = recentGrade?.first!.updatedAt?.relativelyFormatted
            self.secondsSinceGradeUpdate = recentGrade?.first!.secondsSinceUpdate
        }
        else {
            self.lastUpdated = self.updatedAt?.relativelyFormatted
            self.secondsSinceGradeUpdate = self.secondsSinceUpdate
        }
    }
}



class Assignment: Object {
    
    var title: String!
    var points: Int?
    var dueDate: Date?
    var availableDate: Date?
    var desc: String?
    var category: URL!
    
    var userGrade: Grade?
    
    override class var routeType: ItemType { return .assignment }
    
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        title <- map["title"]
        points <- map["points"]
        dueDate <- (map["dueDate"], ISO8601FixedDateTransform())
        availableDate <- (map["availableDate"], ISO8601FixedDateTransform())
        desc <- map["description"]
        category <- (map["_category"], URLTransform())
    }
    
    public func getUserGrade() {
        userGrade = NBClient.shared.getMappable(Grade.self, filters: "[\"_parent:IN:\(self.url.absoluteString)\"]")?.first

    }
}

class Category: Object {
    var title: String!
    var weight: Int!
    var isExtraCredit: Bool!
    var dropLowest: Int!
    var parent: Course?

    override class var routeType: ItemType { return .category }
    
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        title <- map["title"]
        weight <- map["weight"]
        isExtraCredit <- map["isExtraCredit"]
        dropLowest <- map["dropLowest"]
    }
}

class Grade: Object {
    var grade: NSDecimalNumber?
    
    override class var routeType: ItemType { return .grade }
    
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        grade <- (map["grade"], NSDecimalNumberTransform())
    }
}

class University: Object {
    
    var profileLogo: String?
    var defaultLogo: String?
    var domain: String?
    var location: String?
    var name: String?
    
    override class var routeType: ItemType { return .university }
    
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        name <- map["name"]
        profileLogo <- map["profileLogo"]
        defaultLogo <- map["defaultLogo"]
        domain <- map["domain"]
        location <- map["location"]
    }
}

class Enrollment: Object {
    
    var role: String?
    var status: String?
    var user: User!
    var parent: Course?
    
    override class var routeType: ItemType { return .enrollment }
    
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        role <- map["role"]
        status <- map["status"]
        user <- map["_user"]
        parent <- map["_parent"]
    }
}

class Post: Object {
    
    var editedAt: Date?
    var isAnonymous: Bool!
    var pinned: Bool!
    var text: String?
    var _creator: User!
    var _parent: Course?
    
    public var postLikes: [Like]?
    public var postComments: [Comment]?
    public var likedByCurrentUser: Bool?
    public var likeFromCurrentUser: Like?
    
    override class var routeType: ItemType { return .post }
    
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        editedAt <- (map["editedAt"], ISO8601FixedDateTransform())
        isAnonymous <- map["isAnonymous"]
        pinned <- map["pinned"]
        text <- map["text"]

        _creator <- (map["_creator"], ObjectTransform<User>())
        _parent <- map["_parent"]
    }
    
    func updateLikes() {
        self.postLikes = NBClient.shared.getMappable(Like.self, filters: "[\"_parent:IN:\(self.url.absoluteString)\"]")
        if postLikes!.count > 0 {
            for like in postLikes! {
                if (like._owner.resourceKey == NBClient.shared.getCurrentUser().resourceKey) {
                    self.likedByCurrentUser = true
                    self.likeFromCurrentUser = like
                }
                else {
                    self.likedByCurrentUser = false
                }
            }
        }
        else if postLikes!.count == 0 {
            self.likedByCurrentUser = false
        }
    }
    
    override public func refresh() {
        print("refresh post")
        self.postLikes = NBClient.shared.getMappable(Like.self, filters: "[\"_parent:IN:\(self.url.absoluteString)\"]")
        self.postComments = NBClient.shared.getMappable(Comment.self, filters: "[\"_parent:IN:\(self.url.absoluteString)\"]")
        
        if postLikes!.count > 0 {
            for like in postLikes! {
                if (like._owner.resourceKey == NBClient.shared.getCurrentUser().resourceKey) {
                    self.likedByCurrentUser = true
                    self.likeFromCurrentUser = like
                }
                else {
                    self.likedByCurrentUser = false
                }
            }
        }
        else if postLikes!.count == 0 {
            self.likedByCurrentUser = false
        }
    }
}

class Comment: Object {
    
    var editedAt: Date?
    var isAnonymous: Bool!
    var text: String?
    var _creator: User?
    
    override class var routeType: ItemType { return .comment }
    
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        editedAt <- (map["editedAt"], ISO8601FixedDateTransform())
        isAnonymous <- map["isAnonymous"]
        text <- map["text"]
        _creator <- (map["_creator"], ObjectTransform<User>())
    }
}

class Like: Object {
    var _owner: User!
    
    override class var routeType: ItemType { return .like }
    
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        _owner <- (map["_owner"], ObjectTransform<User>())
    }
}

class Notification: Object {

    var status: String?
    var text: String?
    var type: String?
    var parent: Object?
    var name: String?
    
    public var statusBool: Bool {
        if status == nil { return false }
        else { return true }
    }
    
    override class var routeType: ItemType { return .notification }
        
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        name <- map["name"]
        status <- map["status"]
        text <- map["text"]
        type <- map["type"]
        parent <- (map["_parent"], ObjectTransform<Object>())
    }
    
    func getUrlForAvatar() -> URL? {
        let params = ["uuid": UIDevice().uuid]
        let sttt = ("https://demo.nbstage.com/rpc/v1.0/notifications/" + self.resourceKey + "/getProfilePicture")
        var imageUrl = URL(string: sttt)
        imageUrl?.appendQueryParameters(params)
        return imageUrl
    }
    
}
