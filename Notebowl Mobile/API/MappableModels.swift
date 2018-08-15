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
    case assignmentGroup = "assignmentGroups"
    case category = "categories"
    case grade = "grades"
    case university = "universities"
    case enrollment = "enrollments"
    case group = "groups"
    case event = "events"
    case post = "posts"
    case attachment = "attachments"
    case comment = "comments"
    case like = "likes"
    case notification = "notifications"
    case abuse = "abuses"
    case setting = "settings"
    
    static func fromURL(_ urlString: String) -> ItemType {
        let urlComponents = URL(string: urlString)!.deletingLastPathComponent()
        let endpoint = urlComponents.lastPathComponent
        if endpoint == "users" { return ItemType(rawValue: "credentials")!}
        return ItemType(rawValue: endpoint)!
    }
}

public enum ActionType: String {
    case updated = "updated"
    case deleted = "deleted"
    case elapsed = "elapsed"
    case unknown = ""
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

public enum UserRole: String {
    case admin = "Admin"
    case professor = "Professor"
    case student = "Student"
    case member = "Member"
}

public struct DefaultValues {
    var DEFAULT_CURVE_AMOUNT = 0
    var DEFAULT_GRADING_PRECISION = 1
    var DEFAULT_LETTER_GRADE_TITLES = ["F", "D", "C", "B", "A"]
    var DEFAULT_LETTER_GRADE_MEDIAN = [30, 65, 75, 85, 95]
    var DEFAULT_LETTER_GRADE_VALUES = [0, 60, 70, 80, 90]
}


class Generic: StaticMappable {
    var action: ActionType! = .unknown
    var itemType: String!
    var updatedAt: Date!
    
    public var genericObject: NBModel?
    public var isManual: Bool = false

    class func objectForMapping(map: Map) -> BaseMappable? {
        if let type: String = map["itemType"].value() {
            switch type.capitalised {
            case "User":
                return Response<User>()
            case "Course":
                return Response<Course>()
            case "Assignment":
                return Response<Assignment>()
            case "AssignmentSubTypeIndividual":
                return Response<Assignment>()
            case "AssignmentSubTypeGroup":
                return Response<Assignment>()
            case "AssignmentSubTypeDiscussionBoard":
                return Response<Assignment>()
            case "AssignmentGroup":
                return Response<AssignmentGroup>()
            case "Grade":
                return Response<Grade>()
            case "Enrollment":
                return Response<Enrollment>()
            case "Group":
                return Response<Group>()
            case "Event":
                return Response<Event>()
            case "CourseUser","GroupUser":
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
            case "Setting":
                return Response<Setting>()
            default:
                return Generic()
            }
        }
        return nil
    }
    init(){
        
    }
    
    func mapping(map: Map) {
        action <- (map["action"], TransformOf<ActionType, String>(fromJSON: { ActionType(rawValue: $0!) }, toJSON: { $0!.rawValue }))
        itemType <- map["itemType"]
        updatedAt <- (map["updatedAt"], ISO8601FixedDateTransform())
    }
}


class Response<T>: Generic where T: NBModel {
    var responseObject: T!

    public override init() {}
    public required init?(map: Map) { }
    
    public override func mapping(map: Map) {
        super.mapping(map: map)

        responseObject <- (map["updateUrl"], ObjectTransform<T>(action: action, update: updatedAt))
        genericObject = responseObject
    }
}




@objc(Object) public class NBModel: NSObject, Mappable {
    var createdAt: Date!
    var updatedAt: Date!
    var itemType: String!
    var url: URL!
    var resourceKey: String!
    var parent: NBModel?
    var owner: NBModel?
    
    class var routeType: ItemType { return .user }
    
    class var endpoint: String { return self.routeType.returnRoute() }
    
    class var classIdentifier: ObjectIdentifier {
        return ObjectIdentifier(self)
    }
    
    func deleteSelf() {
        let deleteReq = NBNetworking.shared.request(.delete, url: self.url.absoluteString)
        var data: Any!
        if deleteReq.statusCode!.rawValue == 410 {
            data = ["itemType":"\(ItemType.fromURL(self.url.absoluteString))", "updateUrl":"\(self.url.absoluteString)", "action":"deleted", "updatedAt":"\(self.updatedAt)"]
        }
        else {
            let keyPath = (deleteReq.json as AnyObject).value(forKeyPath: "result")! as! [String : AnyObject]
            data = ["itemType":"\(ItemType.fromURL((keyPath["url"] as! String)))", "updateUrl":"\((keyPath["url"] as! String))", "action":"deleted", "updatedAt":"\((keyPath["updatedAt"] as! String))"]
        }
        let JSON = try? JSONSerialization.data(withJSONObject: data, options: [])
        let JSONString = String(data: JSON!, encoding: String.Encoding.utf8)
        NBSocket.shared.updateHandler(message: JSONString!)
    }
    
    class func objectExistsInCache(keyToCompare: String!) -> Bool {
        if NBClient.shared.storedTypes[classIdentifier]!.first(where: { $0.resourceKey == keyToCompare }) != nil {
            return true
        }
        return false
    }
    
    public var firstTimeLoading: Bool!
    public var shouldMapParent: Bool!
    
    public var enrollmentForUser: Enrollment?

    public var secondsSinceUpdate: TimeInterval { return self.updatedAt.timeIntervalSinceReferenceDate }
    public var secondsSinceCreation: TimeInterval { return self.createdAt.timeIntervalSinceReferenceDate }
    
    public func save() {  }
    
    public func refresh() { }
    
    public required init?(map: Map) { }
    
    override init() {}
    
    public func mapping(map: Map) {
        if shouldMapParent == nil { shouldMapParent = true }
        createdAt <- (map["createdAt"], ISO8601FixedDateTransform())
        if createdAt == nil { createdAt = Date.distantPast }
        updatedAt <- (map["updatedAt"], ISO8601FixedDateTransform())
        if updatedAt == nil { updatedAt = Date.distantPast }
        itemType <- map["itemType"]
        url <- (map["url"], URLTransform(shouldEncodeURLString: true, allowedCharacterSet: .urlQueryAllowed))
        resourceKey <- map["resourceKey"]

        if shouldMapParent {
            if let parentString = (map.JSON["_parent"] as? String) {
                let parentMap = Mapper<Generic>().map(JSON: ["itemType":"\(ItemType.fromURL(parentString))", "updateUrl":"\(parentString)"])
                parent = parentMap?.genericObject
            }
        }
        if let ownerString = (map.JSON["_owner"] as? String) {
            let ownerMap = Mapper<Generic>().map(JSON: ["itemType":"\(ItemType.fromURL(ownerString))", "updateUrl":"\(ownerString)"])
            owner = ownerMap?.genericObject
        }
    }
}

public protocol WithName {
    var name: String! { get }
    var fullName: String! { get }
}


@objc(User) public class User: NBModel {

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

@objc(Term) class Term: NBModel {
    
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

@objc(Course) class Course: NBModel, WithName {
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
    public var isAvailable: Bool { return Date().isInRange(date: availableDate, and: endDate, orEqual: true, granularity: .hour ) }
    
    var courseCode: String { return (subject + " " + number) }
    var fullName: String!
    
    public var lastUpdated: String?
    public var secondsSinceGradeUpdate: TimeInterval!
    
    public var refreshedOnce: Bool = false

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
        
        fullName = (courseCode + ": " + name)
    }
    
    override public func refresh() {
        if firstTimeLoading != nil {
            if firstTimeLoading { firstTimeLoading = false }
        }
        
        enrollmentForUser = NBClient.shared.storedTypes[Enrollment.classIdentifier]?.first(where: { (($0 as! Enrollment).parent?.resourceKey == self.resourceKey) && (($0 as! Enrollment).user.resourceKey == NBClient.shared.getCurrentUser().resourceKey) }) as? Enrollment
    }
}

@objc(Assignment) public class Assignment: NBModel {
    
    var title: String!
    var points: Int?
    var dueDate: Date!
    var availableDate: Date!
    var desc: String?
    var gradeOnly: Bool!
    var gradeType: GradeType!
    var gradesPublished: Bool!
    var allowLateSubmission: Bool!
    var category: Category!
    
    public var gradeString: String!
    public var isAvailable: Bool { return (availableDate.isInPast || availableDate.isToday) }
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

        category <- (map["_category"], ObjectTransform<Category>())
    }
    
    public func getGradeString() {
        self.gradeString = getUserGrade()
    }
    
    func getRoundedGradePercent(grade: Double) -> Double {
        let rawPercent = grade / Double(self.points!) * 100
        let percentRounded = rawPercent.rounded(toPlaces: (self.parent as! Course).gradePrecision)
        return percentRounded
    }
    
    public func getUserGrade() -> String {
        guard let userGrade = NBClient.shared.requireByReference(Grade.self, property: "parent", value: self)?.first else { return "-" }
        
        guard let gradePoints = userGrade.grade else { return "-" }

        if self.gradeType == .completion {
            return gradePoints == 0 && self.points! > 0 ? "Incomplete" : "Complete"
        }
            
        else if self.gradeType == .percent && (self.parent as! Course).gradeGPAEnabled {
            var rawPercent = gradePoints / Double(self.points!) * 100
            rawPercent = rawPercent / 100 * 4
            let gpaValue = rawPercent.rounded(toPlaces: (self.parent as! Course).gradePrecision)
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
            
            if ((self.parent as! Course).customGradeScale) {
                let yUni: Unicode.Scalar = ";"
                var yCharSet = CharacterSet.init()
                yCharSet.insert(yUni)
                titles = (self.parent as! Course).gradeScaleTitles.components(separatedBy: yCharSet)
                let tempValues = (self.parent as! Course).gradeScaleValues.components(separatedBy: yCharSet)
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

@objc(AssignmentGroup) class AssignmentGroup: NBModel {
    var name: String!
    var locked: Bool!
    
    override class var routeType: ItemType { return .assignmentGroup }
    
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        name <- map["name"]
        locked <- map["locked"]
    }
}

@objc(Category) class Category: NBModel {
    var title: String!
    var weight: Int!
    var isExtraCredit: Bool!
    var dropLowest: Int!

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

@objc(Grade) class Grade: NBModel {
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

@objc(University) class University: NBModel {
    
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

@objc(Enrollment) public class Enrollment: NBModel {
    
    var role: UserRole!
    var status: String!
    var user: User!
    var lastAccessAt: Date?
    
    public var statusIsAccepted: Bool {
        if status.contains("Accepted") { return true }
        else { return false }
    }
    public var userRoleIsImportant: Bool {
        if role == .professor || role == .admin { return true }
        else { return false }
    }
    
    override class var routeType: ItemType { return .enrollment }
    
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        role <- (map["role"], TransformOf<UserRole, String>(fromJSON: { UserRole(rawValue: $0!) }, toJSON: { $0!.rawValue }))
        status <- map["status"]
        user <- (map["_user"], ObjectTransform<User>())

        lastAccessAt <- (map["lastAccessAt"], ISO8601FixedDateTransform())
    }
    override public func refresh() {
    }
}


@objc(Group) class Group: NBModel, WithName {

    var availableDate: Date!
    var category: String?
    var desc: String?
    var location: String?
    var locked: Bool!
    var meeting: String?
    var name: String!
    var orgContact: String?
    var permalink: String!
    var status: String!
    var type: String!
    var website: String?
    var starred: Bool?

    var fullName: String!
    
    override class var routeType: ItemType { return .group }

    required public init?(map: Map) {
        super.init(map: map)
    }

    override func mapping(map: Map) {
        super.mapping(map: map)
        availableDate <- (map["lastAccessAt"], ISO8601FixedDateTransform())

        category <- map["category"]
        desc <- map["description"]
        location <- map["location"]
        locked <- map["locked"]
        meeting <- map["meeting"]
        name <- map["name"]
        fullName = ("Group - " + name)
        orgContact <- map["orgContact"]
        permalink <- map["permalink"]
        status <- map["status"]
        type <- map["type"]
        website <- map["website"]
        starred <- map["starred"]
    }

    override public func refresh() {
        if firstTimeLoading != nil {
            if firstTimeLoading { firstTimeLoading = false }
        }
        
        enrollmentForUser = NBClient.shared.storedTypes[Enrollment.classIdentifier]?.first(where: { (($0 as! Enrollment).parent?.resourceKey == self.resourceKey) && (($0 as! Enrollment).user.resourceKey == NBClient.shared.getCurrentUser().resourceKey) }) as? Enrollment
    }
}

@objc(Event) class Event: NBModel {
    
    var title: String!
    var desc: String?
    var location: String?
    var color: String!
    var priority: String?
    var type: String!
    var allDay: Bool?
    var startDate: Date!
    var endDate: Date!
    
    override class var routeType: ItemType { return .event }
    
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        title <- map["title"]
        desc <- map["description"]
        location <- map["location"]
        type <- map["type"]
        allDay <- map["allDay"]
        startDate <- (map["startDate"], ISO8601FixedDateTransform())
        endDate <- (map["endDate"], ISO8601FixedDateTransform())
    }
    
}


@objc(Post) public class Post: NBModel {
    
    var editedAt: Date?
    var isAnonymous: Bool!
    var pinned: Bool!
    var text: String?
    var creator: User?
    
    public var postLikes: [Like]!
    public var postComments: [Comment]!
    public var postAttachments: [Attachment]!
    public var likedByCurrentUser: Bool!
    public var likeFromCurrentUser: Like?
    
    public var aboutToBeDeleted: Bool!
    public var inMiddleOfRefresh: Bool!
    
    override class var routeType: ItemType { return .post }
    
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
        
        postLikes = []
        postComments = []
        postAttachments = []
        likedByCurrentUser = false
        likeFromCurrentUser = nil
        
        aboutToBeDeleted = false
        inMiddleOfRefresh = false
    }
    
    func updateLikes() {
        let likes = NBClient.shared.storedTypes[Like.classIdentifier]?.filter({ ($0 as! Like).parent!.resourceKey == self.resourceKey }) as? [Like]
        self.postLikes = (likes == nil ? [] : likes!)
        if postLikes.isEmpty || postLikes == nil {
            likedByCurrentUser = false
            likeFromCurrentUser = nil
        }
        else if postLikes.count > 0 {
            let like = postLikes.first(where: { $0.owner!.resourceKey == NBClient.shared.getCurrentUser().resourceKey })
            
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
            self.creator = NBClient.shared.storedTypes[User.classIdentifier]?.first(where: { ($0 as! User).resourceKey == self.creator!.resourceKey }) as? User
        }
        let comments = NBClient.shared.storedTypes[Comment.classIdentifier]?.filter({ $0.parent!.resourceKey == self.resourceKey }) as? [Comment]
        self.postComments = (comments == nil ? [] : comments!)
 
        let attachments = NBClient.shared.storedTypes[Attachment.classIdentifier]?.filter({ $0.parent!.resourceKey == self.resourceKey }) as? [Attachment]
        self.postAttachments = (attachments == nil ? [] : attachments!)
        updateLikes()
    }
}

@objc(Attachment) public class Attachment: NBModel {
    var fileExt: String!
    var downloadUrl: URL!
    var locationUrl: URL!
    var thumbnailUrl: String?
    var attachmentName: String!
    var attachmentType: String!
    var fileName: String!
    var size: Int!
    var type: String!
    
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

    }
    
    func getUrlForAvatar() -> URL? {
        let params = ["uuid": UIDevice().uuid]
        let sttt = ("https://\(NBClient.baseUrl)/rpc/v1.0/attachments/" + self.resourceKey + "/download")
        var imageUrl = URL(string: sttt)
        imageUrl?.appendQueryParameters(params)
        return imageUrl
    }
}

@objc(Comment) public class Comment: NBModel {
    
    var editedAt: Date?
    var isAnonymous: Bool!
    var text: String!
    var creator: User?
    
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
        creator <- (map["_creator"], ObjectTransform<User>())
        
        commentAttachments = []
        commentLikes = []
        likedByCurrentUser = false
        likeFromCurrentUser = nil
    }
    
    public func getAttachments() {
        let attachments = NBClient.shared.storedTypes[Attachment.classIdentifier]?.filter({ ($0 as! Attachment).parent!.resourceKey == self.resourceKey }) as? [Attachment]
        self.commentAttachments = (attachments == nil ? [] : attachments!)
    }
    public func updateLikes() {
        let likes = NBClient.shared.storedTypes[Like.classIdentifier]?.filter({ ($0 as! Like).parent!.resourceKey == self.resourceKey }) as? [Like]
        self.commentLikes = (likes == nil ? [] : likes!)
        if commentLikes.isEmpty || commentLikes == nil {
            likedByCurrentUser = false
            likeFromCurrentUser = nil
        }
        else if commentLikes.count > 0 {
            let like = commentLikes.first(where: { $0.owner!.resourceKey == NBClient.shared.getCurrentUser().resourceKey })
            
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
        updatedOnce = true
        self.creator = NBClient.shared.storedTypes[User.classIdentifier]?.first(where: { ($0 as! User).resourceKey == self.creator?.resourceKey }) as? User
        updateLikes()
        getAttachments()
    }
}

@objc(Like) public class Like: NBModel {
    
    public var currentUserLiked: Bool { return owner!.resourceKey == NBClient.shared.getCurrentUser().resourceKey ? true : false}
    
    override class var routeType: ItemType { return .like }
    
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
    }
    
    override public func refresh() {
        self.owner = NBClient.shared.storedTypes[User.classIdentifier]?.first(where: { ($0 as! User).resourceKey == self.owner!.resourceKey })// as! User
    }
    

}

@objc(Notification) class Notification: NBModel {

    var status: String?
    var text: String?
    var type: String!
    var name: String!
    
    public var unseenBool: Bool { return status == nil ? true : false }
    public var unreadBool: Bool { return status == nil || status!.contains("seen") ? true : false }
    public var notificationType: NotificationType { return NotificationType.init(rawValue: type)! }
    public var userProfilePicURL: URL { return URL(string: RequestKind.rpc.requestUrl(url: "notifications/" + self.resourceKey + "/getProfilePicture"))! }
    
    override class var routeType: ItemType { return .notification }
        
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        shouldMapParent = false
        super.mapping(map: map)
        
        name <- map["name"]
        status <- map["status"]
        text <- map["text"]
        type <- map["type"]
    }

}


@objc(Abuse) class Abuse: NBModel {
    var reason: String!

    override class var routeType: ItemType { return .abuse }
    
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    init(reason: String, parent: NBModel?) {
        super.init()
        self.reason = reason
        self.parent = parent
    }
    
    override public func save() {
        let payload: Any? = ["reason": "\(reason)", "_parent": "\(parent!.url.absoluteString)"]
        _ = NBNetworking.shared.request(.post, url: Abuse.endpoint, json: payload)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        reason <- map["reason"]
    }
}

@objc(Setting) class Setting: NBModel {
    var key: String!
    var value: Bool!
    
    override class var routeType: ItemType { return .setting }
    
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        key <- map["key"]
        value <- map["value"]
    }
}

class SettingsDefault: Mappable {
    var name: String!
    var help: String?
    var rootId: String!
    var group: String!
    var type: String!
    
    var key: String!
    var defaultValue: Bool!
    
    var userSetting: Setting?

    public required init?(map: Map) { }
    
    public func mapping(map: Map) {
        name <- map["name"]
        help <- map["help"]
        rootId <- map["rootId"]
        group <- map["group"]
        type <- map["type"]
    }
    
    public func findSetting() { userSetting = NBClient.shared.storedTypes[Setting.classIdentifier]?.first(where: { ($0 as! Setting).key == self.key }) as? Setting }
}

class MobileSettingsDefault: SettingsDefault {

    required public init?(map: Map) {
        super.init(map: map)
    }
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        key <- map["mobile"]
        defaultValue <- map["mobileDefault"]
        findSetting()
    }

}

class EmailSettingsDefault: SettingsDefault {

    required public init?(map: Map) {
        super.init(map: map)
    }
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        key <- map["email"]
        defaultValue <- map["emailDefault"]
        findSetting()
    }
 
}

struct SettingsGroup {
    var sectionName: String!
    var sectionMobileSettings: [MobileSettingsDefault]!
    var sectionEmailSettings: [EmailSettingsDefault]!
}

class SettingDefaults: Mappable {
    var settingsMobile: [String: [MobileSettingsDefault]]!
    var settingsEmail: [String: [EmailSettingsDefault]]!
    var settingsArray = [SettingsGroup?](repeating: nil, count: 4)
    
    var settingsPositions = ["courses", "groups", "clubs", "posts"]
    
    public required init?(map: Map) { }
    
    public func mapping(map: Map) {
        settingsMobile <- map["notifications"]
        settingsEmail <- map["notifications"]
        
        for (key,value) in settingsMobile {
            self.settingsArray[settingsPositions.index(of: key)!] = SettingsGroup(sectionName: key, sectionMobileSettings: value, sectionEmailSettings: settingsEmail[key])
        }
    }
}


