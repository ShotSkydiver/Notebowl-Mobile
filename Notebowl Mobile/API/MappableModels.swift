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
    case attachment = "attachments"
    case comment = "comments"
    case like = "likes"
    case notification = "notifications"
    case abuse = "abuses"
}


public enum Action {
    case updated
    case deleted
    case elapsed
    case unknown
}
public enum NotificationType: String {
    case created = "created"
    case updated = "updated"
    case deleted = "deleted"
}
extension ItemType {
    func returnRoute() -> String {
        let route = self.rawValue
        
        return ("https://\(NBClient.baseUrl)/api/v1.0/" + route)
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
    var DEFAULT_LETTER_GRADE_TITLES = ["F", "D", "C", "B", "A"]
    var DEFAULT_LETTER_GRADE_MEDIAN = [30, 65, 75, 85, 95]
    var DEFAULT_LETTER_GRADE_VALUES = [0, 60, 70, 80, 90]
}


class Generic: StaticMappable {
    
    var action: String!
    var itemType: String?
    public var genericObject: Object?
    
    public var actionType: Action {
        if action.contains("updated") { return .updated }
        else if action.contains("elapsed") { return .elapsed }
        else if action.contains("deleted") { return .deleted }
        else {
            TTLog.error("actionType not found!")
            return .unknown
        }
    }
    
    class func objectForMapping(map: Map) -> BaseMappable? {
        if let itemType: String = map["itemType"].value() {
            switch itemType {
            case "User":
                return Response<User>()
            case "Course":
                return Response<Course>()
            case "Assignment":
                return Response<Assignment>()
            case "Grade":
                return Response<Grade>()
            case "Enrollment":
                return Response<Enrollment>()
            case "CourseUser":
                return Response<Enrollment>()
            case "Post":
                return Response<Post>()
            case "Attachment":
                return Response<Attachment>()
            case "AttachmentS3":
                return Response<Attachment>()
            case "Comment":
                return Response<Comment>()
            case "Like":
                return Response<Like>()
            case "Notification":
                return Response<Notification>()
            default:
                return Generic()
            }
        }
        return nil
    }
    init(){
        
    }
    
    func mapping(map: Map) {
        action <- map["action"]
        itemType <- map["itemType"]
    }
}

class Response<T>: Generic where T: Object {
    var updateUrl: T?
    var updatedAt: Date!

    public override init() {}
    
    public required init?(map: Map) { }
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
        updatedAt <- (map["updatedAt"], ISO8601FixedDateTransform())
        updateUrl <- (map["updateUrl"], ObjectTransform<T>(action: self.actionType, update: updatedAt))
        genericObject = updateUrl
    }
}



@objc(Object) public class Object: NSObject, Mappable {
    var parentURL: URL?
    var createdAt: Date!
    var updatedAt: Date!
    var itemType: String!
    var url: URL!
    var resourceKey: String!
    
    class var routeType: ItemType { return .user }
    
    class var endpoint: String { return self.routeType.returnRoute() }
    
    class var classIdentifier: ObjectIdentifier {
        return ObjectIdentifier(self)
    }
    
    class func objectExistsInCache(keyToCompare: String!) -> Bool {
        if NBClient.shared.storedTypes[classIdentifier]!.first(where: { $0.resourceKey == keyToCompare }) != nil {
            return true
        }
        return false
    }
    
    public var firstTimeLoading: Bool!

    public var secondsSinceUpdate: TimeInterval { return self.updatedAt.timeIntervalSinceReferenceDate }
    public var secondsSinceCreation: TimeInterval { return self.createdAt.timeIntervalSinceReferenceDate }
    
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



@objc(User) public class User: Object {

    var firstName: String!
    var lastName: String!
    var email: String?
    var profileUrl: URL!
    var gradMonth: Int?
    var gradYear: Int?
    var university: University?
    
    var fullName: String { return (firstName + " " + lastName) }
    var fullGradDate: String { return (DateComponentsFormatter.monthYear.string(from: (DateComponents(year: gradYear, month: gradMonth))))! }
    
    override class var routeType: ItemType { return .user }
    
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    override public func mapping(map: Map) {
        
        super.mapping(map: map)
        firstName <- map["firstName"]
        lastName <- map["lastName"]
        email <- map["email"]
        gradMonth <- map["gradMonth"]
        gradYear <- map["gradYear"]
        profileUrl <- (map["profileUrl"], URLTransform())
    }
}

@objc(Term) class Term: Object {
    
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
    }
}

@objc(Course) class Course: Object {
    
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
    var courseFullName: String { return (courseCode + ": " + name) }
    
    public var lastUpdated: String?
    public var secondsSinceGradeUpdate: TimeInterval!
    
    public var refreshedOnce: Bool = false

    public var categories: [Category]!
    
    public var enrollmentForUser: Enrollment?
    public var enrollmentExists: Bool!
        
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
        if firstTimeLoading != nil {
            if firstTimeLoading { firstTimeLoading = false }
        }
        
        if NBClient.shared.storedTypes[Enrollment.classIdentifier] != nil {
            enrollmentForUser = NBClient.shared.storedTypes[Enrollment.classIdentifier]?.first(where: { ($0 as! Enrollment).user.resourceKey == NBClient.shared.getCurrentUser().resourceKey }) as? Enrollment
        }
    }
}

@objc(Assignment) public class Assignment: Object {
    
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
    
    override public func mapping(map: Map) {
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
                let yUni: Unicode.Scalar = ";"
                var yCharSet = CharacterSet.init()
                yCharSet.insert(yUni)
                titles = self.parent.gradeScaleTitles.components(separatedBy: yCharSet)
                let tempValues = self.parent.gradeScaleValues.components(separatedBy: yCharSet)
                for item in tempValues {
                    if values.count == tempValues.index(of: item)! {
                        values.append(Int(item)!)
                    }
                    else {
                        values[tempValues.index(of: item)!] = Int(item)!
                    }
                    
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

    }
}

@objc(Category) class Category: Object {
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

@objc(Grade) class Grade: Object {
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

@objc(University) class University: Object {
    
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

@objc(Enrollment) class Enrollment: Object {
    
    var role: String!
    var status: String!
    var user: User!
    var parent: Course?
    var lastAccessDate: Date?
    
    public var statusIsAccepted: Bool {
        if status.contains("Accepted") { return true }
        else { return false }
    }
    
    override class var routeType: ItemType { return .enrollment }
    
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        role <- map["role"]
        status <- map["status"]
 
        user <- (map["_user"], ObjectTransform<User>())
        parent <- (map["_parent"], ObjectTransform<Course>())
        lastAccessDate <- (map["lastAccessDate"], ISO8601FixedDateTransform())
    }
    override public func refresh() {
    }
}

@objc(Post) public class Post: Object {
    
    var editedAt: Date?
    var isAnonymous: Bool!
    var pinned: Bool!
    var text: String?
    var creator: User!
    var owner: Course!
    var parent: URL!
    var related: URL!
    
    public var postLikes: [Like]!
    public var postComments: [Comment]!
    public var postAttachments: [Attachment]!
    public var likedByCurrentUser: Bool!
    public var likeFromCurrentUser: Like?
    
    override class var routeType: ItemType { return .post }
    
    //var parentURL: URL? { return self.parent }
    
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        
        editedAt <- (map["editedAt"], ISO8601FixedDateTransform())
        isAnonymous <- map["isAnonymous"]
        pinned <- map["pinned"]
        text <- map["text"]
        creator <- (map["_creator"], ObjectTransform<User>())
        owner <- (map["_owner"], ObjectTransform<Course>())
        parentURL <- (map["_parent"], URLTransform())
        self.parent = self.parentURL
        related <- (map["_related"], URLTransform())
    }
    
    func updateLikes() {
        self.postLikes = NBClient.shared.storedTypes[Like.classIdentifier]?.filter({ ($0 as! Like).parent == self.url }) as! [Like]
        if postLikes.isEmpty || postLikes == nil {
            likedByCurrentUser = false
            likeFromCurrentUser = nil
        }
        else if postLikes.count > 0 {
            let like = postLikes.first(where: { $0.owner.resourceKey == NBClient.shared.getCurrentUser().resourceKey })
            
            if like != nil {
                likedByCurrentUser = true
                likeFromCurrentUser = like
            }
            else if like == nil {
                likedByCurrentUser = false
                likeFromCurrentUser = nil
            }
        }
    }
    override public func refresh() {
        if self.creator != nil {
            self.creator = NBClient.shared.storedTypes[User.classIdentifier]?.first(where: { ($0 as! User).resourceKey == self.creator.resourceKey }) as! User
        }
        
        self.postComments = NBClient.shared.storedTypes[Comment.classIdentifier]?.filter({ ($0 as! Comment).parent == self.url }) as! [Comment]
        self.postComments = NBClient.shared.initArray(from: self.postComments)
        self.postAttachments = NBClient.shared.storedTypes[Attachment.classIdentifier]?.filter({ ($0 as! Attachment).parent == self.url }) as! [Attachment]
        updateLikes()
    }
}

@objc(Attachment) public class Attachment: Object {
    var fileExt: String!
    var downloadUrl: URL!
    var locationUrl: URL!
    var thumbnailUrl: String?
    var attachmentName: String!
    var attachmentType: String!
    var fileName: String!
    var size: Int!
    var type: String!
    var parent: URL!
    var owner: User?
    
    
    
    override class var routeType: ItemType { return .attachment }
    
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        
        fileExt <- map["extension"]
        downloadUrl <- (map["downloadUrl"], URLTransform())
        locationUrl <- (map["location"], URLTransform())
        thumbnailUrl <- map["thumbnailUrl"]
        attachmentName <- map["attachmentName"]
        attachmentType <- map["attachmentType"]
        type <- map["type"]
        fileName <- map["fileName"]
        size <- map["size"]
        parentURL <- (map["_parent"], URLTransform())
        self.parent = self.parentURL
    }
    
    func getUrlForAvatar() -> URL? {
        let params = ["uuid": UIDevice().uuid]
        let sttt = ("https://\(NBClient.baseUrl)/rpc/v1.0/attachments/" + self.resourceKey + "/download")
        var imageUrl = URL(string: sttt)
        imageUrl?.appendQueryParameters(params)
        return imageUrl
    }
}

@objc(Comment) public class Comment: Object {
    
    var editedAt: Date?
    var isAnonymous: Bool!
    var text: String!
    var creator: User?
    var parent: URL!
    
    public var commentAttachments: [Attachment]!
    public var commentLikes: [Like]!
    public var likedByCurrentUser: Bool!
    public var likeFromCurrentUser: Like?
    
    public var updatedOnce: Bool = false
    
    override class var routeType: ItemType { return .comment }
    
    required public init?(map: Map) {
        super.init(map: map)
    }

    override public func mapping(map: Map) {
        super.mapping(map: map)
        
        editedAt <- (map["editedAt"], ISO8601FixedDateTransform())
        isAnonymous <- map["isAnonymous"]
        text <- map["text"]
        parentURL <- (map["_parent"], URLTransform())
        self.parent = self.parentURL
        creator <- (map["_creator"], ObjectTransform<User>())
    }
    
    public func getAttachments() {
        self.commentAttachments = NBClient.shared.storedTypes[Attachment.classIdentifier]?.filter({ ($0 as! Attachment).parent == self.url }) as! [Attachment]
    }
    public func updateLikes() {
        self.commentLikes = NBClient.shared.storedTypes[Like.classIdentifier]?.filter({ ($0 as! Like).parent == self.url }) as! [Like]
        if commentLikes.isEmpty || commentLikes == nil {
            likedByCurrentUser = false
            likeFromCurrentUser = nil
        }
        else if commentLikes.count > 0 {
            let like = commentLikes.first(where: { $0.owner.resourceKey == NBClient.shared.getCurrentUser().resourceKey })
            
            if like != nil {
                likedByCurrentUser = true
                likeFromCurrentUser = like
            }
            else if like == nil {
                likedByCurrentUser = false
                likeFromCurrentUser = nil
            }
        }
    }
    
    override public func refresh() {
        self.creator = NBClient.shared.storedTypes[User.classIdentifier]?.first(where: { ($0 as! User).resourceKey == self.creator?.resourceKey }) as? User
        updateLikes()
        getAttachments()
    }
}

@objc(Like) public class Like: Object {
    var owner: User!
    var parent: URL!
    
    public var currentUserLiked: Bool { return owner.resourceKey == NBClient.shared.getCurrentUser().resourceKey ? true : false}
    
    override class var routeType: ItemType { return .like }
    
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        
        owner <- (map["_owner"], ObjectTransform<User>())
        parentURL <- (map["_parent"], URLTransform())
        self.parent = self.parentURL
    }
    
    override public func refresh() {
        self.owner = NBClient.shared.storedTypes[User.classIdentifier]?.first(where: { ($0 as! User).resourceKey == self.owner.resourceKey }) as! User
    }
}

@objc(Notification) class Notification: Object {

    var status: String?
    var text: String?
    var type: String!
    var parent: URL!
    var name: String!
    
    public var unseenBool: Bool { return status == nil ? true : false }
    public var unreadBool: Bool { return status == nil || status!.contains("seen") ? true : false }
    public var notificationType: NotificationType { return NotificationType.init(rawValue: type)! }
    
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
        parentURL <- (map["_parent"], URLTransform())
        self.parent = self.parentURL
    }
    
    func getUrlForAvatar() -> URL? {
        let params = ["uuid": UIDevice().uuid]
        let sttt = ("https://\(NBClient.baseUrl)/rpc/v1.0/notifications/" + self.resourceKey + "/getProfilePicture")
        var imageUrl = URL(string: sttt)
        imageUrl?.appendQueryParameters(params)
        return imageUrl
    }
}


@objc(Notification) class Abuse: Object {
    var reason: String!
    var parent: URL!

    override class var routeType: ItemType { return .abuse }
    
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        reason <- map["reason"]
        parent <- (map["_parent"], URLTransform())
    }
}
