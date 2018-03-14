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

public enum GradeType: String {
    case points = "Points"
    case completion = "(In)complete"
    case percent = "Percentage"
    case letter = "Letter Grade"
}

public struct DefaultValues {
    var DEFAULT_CURVE_AMOUNT = 0
    var DEFAULT_GRADING_PRECISION = 1
    // static let DEFAULT_GRADING_TYPE =
    var DEFAULT_LETTER_GRADE_TITLES = ["F", "D", "C", "B", "A"]
    var DEFAULT_LETTER_GRADE_MEDIAN = [30, 65, 75, 85, 95]
    var DEFAULT_LETTER_GRADE_VALUES = [0, 60, 70, 80, 90]
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
    var gradeBase: String?
    var gradeCurve: Int?
    var gradePrecision: Int!
    var customGradeScale: Bool!
    var gradeScaleTitles: String!
    var gradeScaleValues: String!
    var gradeType: String!
    var pointsEnabled: Bool!
    var dropLowestGrade: Bool!
    var weightedGrades: Bool!
    var availableDate: Date!
    var endDate: Date!
    
    public var gradeGPAEnabled: Bool { return gradeBase?.compare("gpa").rawValue == 0 ? true : false }
    public var isAvailable: Bool { return Date().isBetween(availableDate, endDate, includeBounds: true) }
    
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
        gradeBase <- map["gradeBase"]
        gradeCurve <- map["gradeCurveAmount"]
        gradePrecision <- map["gradePrecision"]
        customGradeScale <- map["gradeScaleCustom"]
        gradeScaleTitles <- map["gradeScaleTitles"]
        gradeScaleValues <- map["gradeScaleValues"]
        gradeType <- map["gradeType"]
        pointsEnabled <- map["pointsEnabled"]
        dropLowestGrade <- map["useDropLowest"]
        weightedGrades <- map["useWeightedGrades"]
        availableDate <- (map["availableDate"], ISO8601FixedDateTransform())
        endDate <- (map["endDate"], ISO8601FixedDateTransform())
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
    var dueDate: Date!
    var availableDate: Date!
    var desc: String?
    var gradeOnly: Bool!
    var gradeType: GradeType!
    var gradesPublished: Bool!
    var allowLateSubmission: Bool!
    var category: URL!
    var parent: Course!
    
    public var gradeString: String!
    public var isAvailable: Bool { return (availableDate.isInPast || availableDate.isInToday) }
    public var isPastDue: Bool { return dueDate.isInPast }
    public var getStatus: String { return isPastDue && !allowLateSubmission ? "Closed" : "Open" }
    
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
        gradeOnly <- map["gradeOnly"]
        gradeType <- (map["gradeType"], TransformOf<GradeType, String>(fromJSON: { GradeType(rawValue: $0!) }, toJSON: { $0!.rawValue }))
        gradesPublished <- map["gradesPublished"]
        allowLateSubmission <- map["lateSubmissionPermitted"]
        parent <- (map["_parent"], ObjectTransform<Course>())
        category <- (map["_category"], URLTransform())
    }
    
    public func getGradeString() {
        self.gradeString = getUserGrade()
    }
    
    func getRoundedGradePercent(grade: Double) -> Double {
        let rawPercent = grade / Double(self.points!) * 100
        let percentRounded = rawPercent.rounded(toPlaces: self.parent.gradePrecision)
        return percentRounded
    }
    
    public func getUserGrade() -> String {
        guard let userGrade = NBClient.shared.getMappable(Grade.self, filters: "[\"_parent:IN:\(self.url.absoluteString)\"]")?.first else { return "-" }
        guard let gradePoints = userGrade.grade else { return "-" }

        if self.gradeType == .completion {
            return gradePoints == 0 && self.points! > 0 ? "Incomplete" : "Complete"
        }
            
        else if self.gradeType == .percent && self.parent.gradeGPAEnabled {
            var rawPercent = gradePoints / Double(self.points!) * 100
            rawPercent = rawPercent / 100 * 4
            let gpaValue = rawPercent.rounded(toPlaces: self.parent.gradePrecision)
            return String(format: "%.2f", gpaValue)
        }
            
        else if self.gradeType == .percent {
            let percentFormatted = self.getRoundedGradePercent(grade: gradePoints)
            return String(format: "%.2f", percentFormatted)
        }
          
        
        else if self.gradeType == .letter {
            let percentGrade = self.getRoundedGradePercent(grade: gradePoints)
            
            var titles = DefaultValues().DEFAULT_LETTER_GRADE_TITLES
            var values = DefaultValues().DEFAULT_LETTER_GRADE_VALUES
            
            if (self.parent.customGradeScale) {
                let yUni: Unicode.Scalar = "ÿ"
                var yCharSet = CharacterSet.init()
                yCharSet.insert(yUni)
                titles = self.parent.gradeScaleTitles.components(separatedBy: yCharSet)
                let tempValues = self.parent.gradeScaleValues.components(separatedBy: yCharSet)
                for item in tempValues {
                    values[tempValues.index(of: item)!] = Int(item)!
                }
            }
            
            if (percentGrade < 0) {
                return titles[0].uppercased()
            }
            else {
                for value in values {
                    let indexAfter = values.index(after: values.index(of: value)!)
                    if ((Int(percentGrade) >= value) && (Int(percentGrade) < values[indexAfter])) {
                        return titles[values.index(of: value)!].uppercased()
                    }
                }
            }
            return "error!"
        }
        
        return "\(Int(gradePoints))"
        
        
        // for percentage grades
        // rawPercent = ( userGrade.grade / self.points ) * 100
        // round rawPercent value using grade precision value from course
        // self.gradeString = formatted rawPercent
        
            // for percentage grades when displaying grades as gpa is enabled
            //
        
        
        // for letter grades
        // rawPercent = ( userGrade.grade / self.points ) * 100
        // round rawPercent value using grade precision value from course
        // check if course is using a custom grading scale
            // handle custom grading scale by parsing title and value strings from course
        // if rawPercent value is 0 or less than 0
            // self.gradeString = "F"
        // else iterate through a for loop that compares each letter grade (A, B, C,) to the rawPercent
            // self.gradeString = whichever letter grade matches our rawPercent value
        
        
        
        // for complete grades
        // if userGrade.grade == self.points
            // self.gradeString = "Complete"
        // else if userGrade.grade == 0
            // self.gradeString = "Incomplete"
        
        
        // for handling when points are disabled for this course
        // self.gradeString = "-"
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
    var grade: Double?
    
    override class var routeType: ItemType { return .grade }
    
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        grade <- map["grade"]
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
    var _creator: User?
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
        if !isAnonymous {
            _creator <- (map["_creator"], ObjectTransform<User>())
        }
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
