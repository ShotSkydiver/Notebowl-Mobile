//
//  MappableModels.swift
//  NB-Mobile
//
//  Created by Conner Owen on 1/10/18.
//  Copyright © 2018 NoteBowl. All rights reserved.
//

import Foundation
import ObjectMapper

public enum ItemType: String {
    case user = "credentials"
    case course = "courses"
    case assignment = "assignments"
    case grade = "grades"
    case university = "universities"
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
        profileUrl <- (map["profileUrl"], URLTransform())
        profileThumbUrl <- (map["profileThumbUrl"], URLTransform())
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
    
    public var userCourseGrade: String?
    public var lastUpdated: String?
    public var secondsSinceUpdate: TimeInterval?
    
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
    
    public func refreshGrades() {
        let courseAssignments = NBClient.shared.getMappable(Assignment.self, filters: "[\"_parent:IN:\(self.url.absoluteString)\"]")
        
        var assignmentsUrls: String = ""
        var maximumPoints = 0.0, userPoints = 0.0
        
        for assignment in courseAssignments! {
            assignment.currentGrade()
            
            if ((assignment.userGrade == 0.0) || (assignment.userGrade == nil)) {
                
            }
            else {
                maximumPoints += assignment.points!
                userPoints += assignment.userGrade!
            }
            
            assignmentsUrls = (assignmentsUrls + assignment.url.absoluteString + ",")
        }
        
        var finalGrade = (userPoints/maximumPoints)
        finalGrade = (finalGrade*100.0)
        
        if (finalGrade.isNaN) {
            self.userCourseGrade = "-"
        }
        else {
            self.userCourseGrade = String(format: "%.1f%%", finalGrade)
        }
        let recentGrade = NBClient.shared.getMappable(Grade.self, filters: "[\"_parent:IN:\(assignmentsUrls)\"]", sortBy: "updatedAt:desc", limit: "1")
        
        if (recentGrade?.first != nil) {
            self.lastUpdated = recentGrade?.first!.updatedAt?.relativelyFormatted
            self.secondsSinceUpdate = recentGrade?.first!.updatedAt.timeIntervalSinceReferenceDate
        }
        else {
            self.lastUpdated = self.updatedAt?.relativelyFormatted
            self.secondsSinceUpdate = self.updatedAt.timeIntervalSinceReferenceDate
        }
    }
}

class Assignment: Object {
    
    var title: String!
    var points: Double?
    var dueDate: Date?
    var availableDate: Date?
    var desc: String?
    
    var userGrade: Double?
    
    override class var routeType: ItemType { return .assignment }
    
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        title <- map["title"]
        points <- (map["points"], TransformOf<Double, Int>(fromJSON: { Double(exactly: $0!)! }, toJSON: { $0.map { Int(exactly: $0)! } }))
        dueDate <- (map["dueDate"], ISO8601FixedDateTransform())
        availableDate <- (map["availableDate"], ISO8601FixedDateTransform())
        desc <- map["description"]
    }
    
    public func currentGrade() {
        let current = (NBClient.shared.getMappable(Grade.self, filters: "[\"_parent:IN:\(self.url.absoluteString)\"]", sortBy: "updatedAt:desc", limit: "1"))
        guard let firstGrade = current?.first else {
            print("grade null!")
            self.userGrade = 0.0
            return
        }
        self.userGrade = firstGrade.grade?.doubleValue

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

class Post: Object {
    
    var editedAt: Date?
    var isAnonymous: Bool!
    var pinned: Bool!
    var text: String?
    var _creator: User?
    var _parent: Course?
    
    public var secondsSinceUpdate: TimeInterval { return self.updatedAt.timeIntervalSinceReferenceDate}
    
    public var postLikes: [Like]?
    public var postComments: [Comment]?
    
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
        _parent <- (map["_parent"], ObjectTransform<Course>())
    }
}

class Comment: Object {
    
    var editedAt: Date?
    var isAnonymous: Bool!
    var text: String?
    var _creator: User?
    var _parent: Post?
    
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
        _parent <- (map["_parent"], ObjectTransform<Post>())
    }
}

class Like: Object {
    
    var _parent: Post?
    var _owner: User?
    
    override class var routeType: ItemType { return .like }
    
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        _parent <- (map["_parent"], ObjectTransform<Post>())
        _owner <- (map["_owner"], ObjectTransform<User>())
    }
}

class Notification: Object {
    
    var status: String?
    var text: String?
    var type: String?
    var _parent: Post?
    var name: String?
    
    override class var routeType: ItemType { return .notification }
    
    public var secondsSinceUpdate: TimeInterval { return self.updatedAt.timeIntervalSinceReferenceDate}
    
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        name <- map["name"]
        status <- map["status"]
        text <- map["text"]
        type <- map["type"]
        _parent <- (map["_parent"], ObjectTransform<Post>())
    }

}
