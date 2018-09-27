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
    case assignmentGroupUser = "assignmentGroupUsers"
    case submission = "submissions"
    case assessment = "assessments"
    case assessmentSubmission = "assessmentSubmissions"
    case assessmentQuestion = "assessmentQuestions"
    case assessmentResponse = "assessmentResponses"
    case category = "categories"
    case grade = "grades"
    case university = "universities"
    case enrollment = "enrollments"
    case group = "groups"
    case event = "events"
    case post = "posts"
    case attachment = "attachments"
    case folder = "folders"
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
        return ("https://\(baseUrl)/api/v1.0/" + route)
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
}


class Generic: StaticMappable {
    var action: ActionType = .unknown
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
            case "Submission":
                return Response<Submission>()
            case "Assessment":
                return Response<Assessment>()
            case "AssessmentSubmission":
                return Response<AssessmentSubmission>()
            case "AssessmentQuestion":
                return Response<AssessmentQuestion>()
            case "AssessmentResponse":
                return Response<AssessmentResponse>()
            case "Category":
                return Response<Category>()
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
            case "Folder":
                return Response<Folder>()
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




public class NBModel: Mappable {
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
        if deleteReq.statusCode!.rawValue == 410 {
            NBSocket.shared.updateHandler(itemType: "\(ItemType.fromURL(self.url.absoluteString))", updateUrl: self.url.absoluteString, action: "deleted", updatedAt: "\(self.updatedAt!)")
        }
        else {
            let keyPath = (deleteReq.json as AnyObject).value(forKeyPath: "result")! as! [String : AnyObject]
            NBSocket.shared.updateHandler(itemType: "\(ItemType.fromURL((keyPath["url"] as! String)))", updateUrl: (keyPath["url"] as! String), action: "deleted", updatedAt: (keyPath["updatedAt"] as! String))
        }
    }
    
    public var firstTimeLoading: Bool!
    public var shouldMapParent: Bool!
    
    public var enrollmentForUser: Enrollment?

    public var secondsSinceUpdate: TimeInterval { return self.updatedAt.timeIntervalSinceReferenceDate }
    public var secondsSinceCreation: TimeInterval { return self.createdAt.timeIntervalSinceReferenceDate }
    
    func setPayload() -> [String: Any] { return [:] }
    func save(withCustomPayload: [String: Any]? = nil) -> NBModel? {

        var json: [String: Any] = [:]

        if withCustomPayload != nil {
            json = withCustomPayload!
        }
        else {
            let payloadJson = self.setPayload()
            for item in payloadJson {
                if item.value is NBModel {
                    json += ["_\(item.key)": "\((item.value as! NBModel).url.absoluteString)"]
                }
                else if item.value is Date {
                    json += [item.key: "\((item.value as! Date).toFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ"))"]
                }
                else {
                    json += [item.key: item.value]
                }
            }
        }

        var result: NBResult!

        if self.url != nil {
            result = NBNetworking.shared.request(.put, url: self.url.absoluteString, json: (json as Any))
        }
        else {
            result = NBNetworking.shared.request(.post, url: type(of: self).endpoint, json: (json as Any))
        }
        
        if result.statusCode!.rawValue == 422 {
            return nil
        }

        let keyPath = (result.json as AnyObject).value(forKeyPath: "result")! as! [String : AnyObject]
        let finalObject = NBSocket.shared.updateHandler(itemType: "\(ItemType.fromURL((keyPath["url"] as! String)))", updateUrl: (keyPath["url"] as! String), action: "updated", updatedAt: (keyPath["updatedAt"] as! String))
        return finalObject
    }
    
    public func refresh() { }
    
    public required init?(map: Map) { }
    
    init() { }
    
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
extension NBModel: Hashable {
    public var hashValue: Int {
        return ObjectIdentifier(self).hashValue
    }
    
    public static func == (lhs: NBModel, rhs: NBModel) -> Bool {
        return lhs.resourceKey == rhs.resourceKey
    }
}

public protocol PostsComments {
    var text: String! { get set }
    var editedAt: Date! { get }
    var isAnonymous: Bool! { get }
    var creator: User! { get }

    var attachments: [Attachment]! { get set }
    mutating func saveEditedObjectWithText(newText: String)
}
extension PostsComments {
    public mutating func saveEditedObjectWithText(newText: String) {
        self.text = newText
        (self as! NBModel).save()
    }
}

public protocol WithName {
    var name: String! { get }
    var fullName: String! { get }
    func firstTimeLoaded()
}

public protocol AssignmentAssessment {
    var title: String! { get }
    var desc: String! { get }
    var category: Category! { get }
    var dueDate: Date! { get }
    var availableDate: Date! { get }
    var status: String! { get }
    var sortOrder: Int! { get }
    var userGrade: Grade! { get }
    var gradeScheme: GradeType! { get }
    var gradeString: String! { get }
    var points: Int! { get }
    func getUserGrade() -> String
    func getGradeString()
    func getStatus()
}

extension AssignmentAssessment {

    var isAvailable: Bool { return (availableDate.isInPast || availableDate.isToday) }
    var isPastDue: Bool { return dueDate.isInPast }

    public func getRoundedGradePercent(grade: Double) -> Double {
        let rawPercent = grade / Double(self.points) * 100
        let percentRounded = rawPercent.rounded(toPlaces: ((self as! NBModel).parent as! Course).gradePrecision)
        return percentRounded
    }

    public func getUserGrade() -> String {
        if userGrade == nil { return "Not Graded" }
        guard let gradePoints = userGrade.grade else { return "Not Graded" }

        if self.gradeScheme == .completion {
            return gradePoints == 0 && self.points! > 0 ? "Incomplete" : "Complete"
        }

        else if self.gradeScheme == .percent && ((self as! NBModel).parent as! Course).gradeGPAEnabled {
            var rawPercent = gradePoints / Double(self.points!) * 100
            rawPercent = rawPercent / 100 * 4
            let gpaValue = rawPercent.rounded(toPlaces: ((self as! NBModel).parent as! Course).gradePrecision)
            return String(format: "%.2f", gpaValue)
        }

        else if self.gradeScheme == .percent {
            let percentFormatted = self.getRoundedGradePercent(grade: gradePoints)
            let places = ((self as! NBModel).parent as! Course).gradePrecision
            let formatString = "%.\(places!)f%%"
            return String(format: formatString, percentFormatted)
        }

        else if self.gradeScheme == .letter {
            let percentGrade = self.getRoundedGradePercent(grade: gradePoints)

            var titles: [String] = []
            var values: [Double] = []
            var medians: [Double] = []

            let yUni: Unicode.Scalar = ";"
            var yCharSet = CharacterSet.init()
            yCharSet.insert(yUni)
            let commaCharacter = CharacterSet.init(charactersIn: ",")

            let separated = ((self as! NBModel).parent as! Course).gradeScale.components(separatedBy: yCharSet)

            for gradeSet in separated {
                let parts = gradeSet.components(separatedBy: commaCharacter)
                titles.append(parts[0])
                values.append(Double(parts[1])!)
                medians.append(Double(parts[2])!)
            }

            if (percentGrade < 0) {
                return titles[0].uppercased()
            }

            else {
                for value in values {
                    let currentIndex = values.index(of: value)!
                    let indexAfter = values.index(after: currentIndex)
                    if indexAfter == values.endIndex { return titles[currentIndex].uppercased() }

                    if (percentGrade >= value) && (percentGrade < values[indexAfter]) {
                        if percentGrade != medians[currentIndex] {
                            let percentFormatted = self.getRoundedGradePercent(grade: gradePoints)
                            let formatString = "%.0f%%"
                            let percentString = String(format: formatString, percentFormatted)
                            return (percentString + " (\(titles[currentIndex].uppercased()))")
                        }
                        return titles[currentIndex].uppercased()

                    }
                }
            }
        }
        if gradePoints.isInt {
            return "\(Int(gradePoints))"
        }
        else {
            return "\(gradePoints)"
        }
    }
}

public class User: NBModel {

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

class Term: NBModel {
    
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

class Course: NBModel, WithName {
    var name: String!
    var number: String!
    var subject: String!
    var units: Int?
    var location: String?
    var desc: String?
    var gradeBase: String?
    var gradeCurve: Int?
    var gradePrecision: Int!
    var gradeScale: String!
    var gradeType: String!
    var pointsEnabled: Bool!
    var dropLowestGrade: Bool!
    var weightedGrades: Bool!
    var availableDate: Date!
    var endDate: Date!
    var profileUrl: URL!
    var term: Term!
    public var gradeGPAEnabled: Bool { return gradeBase?.compare("gpa").rawValue == 0 ? true : false }
    public var isAvailable: Bool { return Date().isInRange(date: availableDate, and: endDate, orEqual: true, granularity: .hour ) }
    var courseCode: String { return (subject + " " + number) }
    var fullName: String!
    public var lastUpdated: String?
    public var secondsSinceGradeUpdate: TimeInterval!
    public var refreshedOnce: Bool = false
    public var courseAssignments: [AssignmentAssessment]!
    public var courseCategories: [Category]!
        
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
        gradeScale <- map["gradeScale"]
        gradeType <- map["gradeScheme"]
        pointsEnabled <- map["pointsEnabled"]
        dropLowestGrade <- map["useDropLowest"]
        weightedGrades <- map["useWeightedGrades"]
        availableDate <- (map["availableDate"], ISO8601FixedDateTransform())
        endDate <- (map["endDate"], ISO8601FixedDateTransform())
        profileUrl <- (map["profileUrl"], URLTransform())

        term <- (map["_term"], ObjectTransform<Term>())
        
        fullName = (courseCode + ": " + name)

        courseAssignments = []
        courseCategories = []
    }

    func hexValuesFromGradientHeader() -> [UIColor] {
        if profileUrl.absoluteString.contains("services/generate/profilePicture") {
            let paths = profileUrl.pathComponents
            if let beginningIndex = paths.index(of: "profilePicture") {
                let startHex = paths[paths.index(after: beginningIndex)]
                let endHex = paths[paths.index(after: paths.index(of: startHex)!)]
                let startColor = UIColor(hexString: "\(startHex)")
                let endColor = UIColor(hexString: "\(endHex)")
                return [startColor, endColor]
            }
        }
        else if profileUrl.absoluteString.contains("/latest/images/cover/default/default_") {
            let defaultName = profileUrl.deletingPathExtension().lastPathComponent
            if let defaults = Gradients.getDefaultGradients() {
                let gradientColor = Gradients.gradientColorWithName(defaults, name: defaultName)
                return [gradientColor!.startColor, gradientColor!.endColor]
            }
        }
        else {
            return [UIColor(hexString: "#BF4458"), UIColor(hexString: "#854D88")]
        }
        return [UIColor(hexString: "#BF4458"), UIColor(hexString: "#854D88")]
    }
    
    func firstTimeLoaded() {
        if firstTimeLoading != nil {
            if firstTimeLoading { firstTimeLoading = false }
        }
    }

    func updateChildren() {
        var assignments = NBClient.shared.storedTypes[Assignment.classIdentifier]?.filter({ $0.parent! == self }) as? [AssignmentAssessment]
        assignments = (assignments == nil ? [] : assignments!)

        let assessments = NBClient.shared.storedTypes[Assessment.classIdentifier]?.filter({ $0.parent! == self }) as? [AssignmentAssessment]
        if assessments != nil { assignments! += assessments! }
        self.courseAssignments = assignments!
        
        let categories = NBClient.shared.storedTypes[Category.classIdentifier]?.filter({ $0.parent! == self }) as? [Category]
        self.courseCategories = (categories == nil ? [] : categories!)
    }
    
    override public func refresh() {
        enrollmentForUser = NBClient.shared.storedTypes[Enrollment.classIdentifier]?.first(where: { (($0 as! Enrollment).parent == self) && (($0 as! Enrollment).user == NBClient.shared.getCurrentUser()) }) as? Enrollment
        updateChildren()
    }
}

public class Assignment: NBModel, AssignmentAssessment {
    public var title: String!
    public var points: Int!
    public var dueDate: Date!
    public var availableDate: Date!
    public var desc: String!
    var gradeOnly: Bool!
    public var gradeScheme: GradeType!
    var type: String!
    var gradesPublished: Bool!
    var allowLateSubmission: Bool!
    public var category: Category!
    public var userGrade: Grade!
    public var gradeString: String!

    public var status: String!
    public var sortOrder: Int!

    public func getStatus() {
        if self.parent?.enrollmentForUser?.role == .professor || self.parent?.enrollmentForUser?.role == .admin {
            if dueDate == nil {
                self.status = "Not Published"
                return
            }
            else if availableDate.isInFuture {
                self.status = "Not Available Yet"
                return
            }
        }

        else {
            if let grade = self.userGrade, grade.grade != nil {
                self.status = "Graded"
                self.sortOrder = 1
                return
            }
            else if let submission = NBClient.shared.storedTypes[Submission.classIdentifier]?.first(where: {$0.parent == self}) as? Submission {
                if submission.submittedLate {
                    self.status = "Submitted Late"
                }
                else {
                    self.status = "Submitted"
                }
                self.sortOrder = 2
                return
            }
        }

        if isPastDue && allowLateSubmission {
            self.status = "Past Due"
            self.sortOrder = 4
        }
        else if !isPastDue && isAvailable {
            self.status = "Open"
            self.sortOrder = 3
        }
        else if isPastDue && !allowLateSubmission {
            self.status = "Closed"
            self.sortOrder = 5
        }
        return
    }
    
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
        gradeOnly <- map["gradeOnly"]
        if gradeOnly {
            desc = ""
        }
        else {
            desc <- map["description"]
        }
        gradeScheme <- (map["gradeScheme"], TransformOf<GradeType, String>(fromJSON: { GradeType(rawValue: $0!) }, toJSON: { $0!.rawValue }))
        type <- map["type"]
        gradesPublished <- map["gradesPublished"]
        allowLateSubmission <- map["lateSubmissionPermitted"]

        category <- (map["_category"], ObjectTransform<Category>())
        userGrade = nil
    }

    public func getGradeString() {
        if let grade = NBClient.shared.storedTypes[Grade.classIdentifier]?.first(where: {$0.parent == self}) as? Grade {
            self.userGrade = grade
        }

        self.gradeString = getUserGrade()
    }

    override public func refresh() {
        getGradeString()
        getStatus()
    }
}

class AssignmentGroup: NBModel {
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

class Submission: NBModel {
    var text: String?

    public var submittedLate: Bool { return createdAt.isAfterDate((self.parent as! Assignment).dueDate, orEqual: false, granularity: .second) }

    override class var routeType: ItemType { return .submission }

    required public init?(map: Map) {
        super.init(map: map)
    }

    override func mapping(map: Map) {
        super.mapping(map: map)

        text <- map["text"]
    }
}

public class Assessment: NBModel, AssignmentAssessment {
    var allowPartialCredit: Bool!
    var answerOrder: String!
    public var availableDate: Date!
    var defaultQuestionPoints: Int!
    public var desc: String!
    public var dueDate: Date!
    var gracePeriod: Int!
    public var gradeScheme: GradeType!
    var gradesPublished: Bool!
    var locked: Bool!
    var permalink: String!
    var permittedSubmissionAttempts: Int!
    var questionOrder: String!
    var questionScheme: String!
    var resultScheme: String!
    var timeLimit: Int!
    public var title: String!
    public var category: Category!

    public var points: Int! {
        let questions = NBClient.shared.storedTypes[AssessmentQuestion.classIdentifier]?.filter({ $0.parent! == self }) as? [AssessmentQuestion]
        var pointsCalculated: Int = 0
        for question in questions! {
            if !question.extraCredit {
                pointsCalculated += question.points
            }
        }
        return pointsCalculated
    }

    public var userGrade: Grade!
    public var gradeString: String!

    public var status: String!
    public var sortOrder: Int!

    public func getStatus() {

        if self.parent?.enrollmentForUser?.role == .professor || self.parent?.enrollmentForUser?.role == .admin {
            if dueDate == nil {
                self.status = "Not Published"
                return
            }
            else if availableDate.isInFuture {
                self.status = "Not Available Yet"
                return
            }
        }

        else {
            if let grade = self.userGrade, grade.grade != nil {
                self.status = "Graded"
                self.sortOrder = 1
                return
            }
            else if let submission = NBClient.shared.storedTypes[AssessmentSubmission.classIdentifier]?.first(where: {$0.parent == self}) as? AssessmentSubmission {
                if let end = submission.endDate {
                    self.status = "Submitted"
                    self.sortOrder = 2
                }
                else {
                    self.status = "In Progress"
                    self.sortOrder = 0
                }
                return
            }
        }
        if isPastDue {
            self.status = "Closed"
            self.sortOrder = 5
        }
        else {
            self.status = "Open"
            self.sortOrder = 3
        }
        return
    }

    override class var routeType: ItemType { return .assessment }

    required public init?(map: Map) {
        super.init(map: map)
    }

    override public func mapping(map: Map) {
        super.mapping(map: map)

        title <- map["title"]
        dueDate <- (map["dueDate"], ISO8601FixedDateTransform())
        availableDate <- (map["availableDate"], ISO8601FixedDateTransform())
        desc <- map["description"]
        gradeScheme <- (map["gradeScheme"], TransformOf<GradeType, String>(fromJSON: { GradeType(rawValue: $0!) }, toJSON: { $0!.rawValue }))
        gradesPublished <- map["gradesPublished"]

        category <- (map["_category"], ObjectTransform<Category>())
        userGrade = nil
    }

    public func getGradeString() {
        if let grade = NBClient.shared.storedTypes[Grade.classIdentifier]?.first(where: {$0.owner == self}) as? Grade {
            self.userGrade = grade
        }
        self.gradeString = getUserGrade()
    }

    override public func refresh() {
        getGradeString()
        getStatus()
    }
}

class AssessmentQuestion: NBModel {
    var questionScheme: String!
    var title: String!
    var points: Int!
    var desc: String?
    var extraCredit: Bool!

    override class var routeType: ItemType { return .assessmentQuestion }

    required public init?(map: Map) {
        super.init(map: map)
    }

    override func mapping(map: Map) {
        super.mapping(map: map)

        questionScheme <- map["questionScheme"]
        title <- map["title"]
        points <- map["points"]
        desc <- map["description"]
        extraCredit <- map["extraCredit"]
    }
}

class AssessmentSubmission: NBModel {
    var startDate: Date!
    var endDate: Date?

    override class var routeType: ItemType { return .assessmentSubmission }

    required public init?(map: Map) {
        super.init(map: map)
    }

    override func mapping(map: Map) {
        super.mapping(map: map)

        startDate <- (map["startDate"], ISO8601FixedDateTransform())
        endDate <- (map["endDate"], ISO8601FixedDateTransform())
    }
}

class AssessmentResponse: NBModel {
    var textContent: String!

    override class var routeType: ItemType { return .assessmentResponse }

    required public init?(map: Map) {
        super.init(map: map)
    }

    override func mapping(map: Map) {
        super.mapping(map: map)

        textContent <- map["textContent"]
    }
}


public class Category: NBModel {
    var title: String!
    var weight: Int!
    var isExtraCredit: Bool!
    var dropLowest: Int!

    override class var routeType: ItemType { return .category }
    
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        
        title <- map["title"]
        weight <- map["weight"]
        isExtraCredit <- map["isExtraCredit"]
        dropLowest <- map["dropLowest"]
    }
}

public class Grade: NBModel {
    var grade: Double?
    
    override class var routeType: ItemType { return .grade }
    
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        grade <- map["grade"]
    }
}

class University: NBModel {
    
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

public class Enrollment: NBModel {
    
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


class Group: NBModel, WithName {

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
    
    func firstTimeLoaded() {
        if firstTimeLoading != nil {
            if firstTimeLoading { firstTimeLoading = false }
        }
    }

    override public func refresh() {
        enrollmentForUser = NBClient.shared.storedTypes[Enrollment.classIdentifier]?.first(where: { (($0 as! Enrollment).parent == self) && (($0 as! Enrollment).user == NBClient.shared.getCurrentUser()) }) as? Enrollment
    }
}

class Event: NBModel {
    
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


public class Post: NBModel, PostsComments {

    public var text: String!
    public var creator: User!
    public var editedAt: Date!
    public var isAnonymous: Bool!

    public var attachments: [Attachment]!

    var pinned: Bool!
    var availableDate: Date?
    
    public var postLikes: [Like]!
    public var postComments: [Comment]!

    public var likedByCurrentUser: Bool!
    public var likeFromCurrentUser: Like?
    
    override class var routeType: ItemType { return .post }
    
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    init(text: String, owner: NBModel?, parent: NBModel?, isAnonymous: Bool, pinned: Bool) {
        super.init()
        self.text = text
        self.owner = owner
        self.parent = parent
        self.isAnonymous = isAnonymous
        self.pinned = pinned
    }
    override func setPayload() -> [String: Any] {
        var payload: [String: Any] = [:]
        payload["text"] = text
        payload["parent"] = self.parent!
        payload["owner"] = self.owner!
        payload["related"] = self.parent!
        payload["isAnonymous"] = self.isAnonymous
        payload["availableDate"] = (self.availableDate != nil ? self.availableDate! : Date())
        payload["pinned"] = self.pinned
        return payload
    }
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        
        editedAt <- (map["editedAt"], ISO8601FixedDateTransform())
        isAnonymous <- map["isAnonymous"]
        pinned <- map["pinned"]

        text <- map["text"]
        if text == nil {
            text = ""
        }

        creator <- (map["_creator"], ObjectTransform<User>())
        availableDate <- (map["availableDate"], ISO8601FixedDateTransform())
        
        postLikes = []
        postComments = []
        attachments = []
        likedByCurrentUser = false
        likeFromCurrentUser = nil
    }
    
    func updateLikes() {
        let likes = NBClient.shared.storedTypes[Like.classIdentifier]?.filter({ ($0 as! Like).parent! == self }) as? [Like]
        self.postLikes = (likes == nil ? [] : likes!)
        if postLikes.isEmpty || postLikes == nil {
            likedByCurrentUser = false
            likeFromCurrentUser = nil
        }
        else if postLikes.count > 0 {
            let like = postLikes.first(where: { $0.owner! == NBClient.shared.getCurrentUser() })
            
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
            self.creator = NBClient.shared.storedTypes[User.classIdentifier]?.first(where: { ($0 as! User) == self.creator! }) as? User
        }
        let comments = NBClient.shared.storedTypes[Comment.classIdentifier]?.filter({ $0.parent! == self }) as? [Comment]
        self.postComments = (comments == nil ? [] : comments!)
 
        let attach = NBClient.shared.storedTypes[Attachment.classIdentifier]?.filter({ $0.parent! == self }) as? [Attachment]
        self.attachments = (attach == nil ? [] : attach!)
        updateLikes()
    }
}

public class Attachment: NBModel {
    var fileExt: String!
    var downloadUrl: URL!
    var locationUrl: URL!
    var thumbnailUrl: String?
    var attachmentName: String!
    var attachmentType: String!
    var fileName: String!
    var size: Int!
    var type: String!
    
    public var fileID: String!
    
    override class var routeType: ItemType { return .attachment }
    
    required public init?(map: Map) {
        super.init(map: map)
    }
    init(file: String, parent: NBModel?) {
        super.init()
        self.fileID = file
        self.parent = parent
    }
    override func setPayload() -> [String: Any] {
        var payload: [String: Any] = [:]
        payload["fileId"] = self.fileID
        payload["parent"] = self.parent!
        payload["attachmentType"] = "S3"
        payload["attachmentName"] = "\(self.fileID ?? "attachment").jpg"
        return payload
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
        let sttt = ("https://\(baseUrl)/rpc/v1.0/attachments/" + self.resourceKey + "/download")
        var imageUrl = URL(string: sttt)
        imageUrl?.appendQueryParameters(params)
        return imageUrl
    }
}

class Folder: NBModel {
    var attachmentName: String!

    override class var routeType: ItemType { return .folder }

    required public init?(map: Map) {
        super.init(map: map)
    }

    override func mapping(map: Map) {
        shouldMapParent = false
        super.mapping(map: map)
        attachmentName <- map["attachmentName"]
    }
}

public class Comment: NBModel, PostsComments {
    
    public var text: String!
    public var creator: User!
    public var editedAt: Date!
    public var isAnonymous: Bool!

    public var attachments: [Attachment]!

    public var commentLikes: [Like]!
    public var likedByCurrentUser: Bool!
    public var likeFromCurrentUser: Like?
    
    public var updatedOnce: Bool = false
    
    override class var routeType: ItemType { return .comment }
    
    required public init?(map: Map) {
        super.init(map: map)
    }
    init(text: String, parent: NBModel?, isAnonymous: Bool?) {
        super.init()
        self.text = text
        self.parent = parent
        self.isAnonymous = isAnonymous
    }
    override func setPayload() -> [String: Any] {
        var payload: [String: Any] = [:]
        payload["text"] = text
        payload["parent"] = self.parent!
        payload["isAnonymous"] = self.isAnonymous
        return payload
    }

    override public func mapping(map: Map) {
        super.mapping(map: map)
        
        editedAt <- (map["editedAt"], ISO8601FixedDateTransform())
        isAnonymous <- map["isAnonymous"]

        text <- map["text"]
        if text == nil {
            text = ""
        }
        
        creator <- (map["_creator"], ObjectTransform<User>())
        
        attachments = []
        commentLikes = []
        likedByCurrentUser = false
        likeFromCurrentUser = nil
    }
    
    public func getAttachments() {
        let attach = NBClient.shared.storedTypes[Attachment.classIdentifier]?.filter({ ($0 as! Attachment).parent! == self }) as? [Attachment]
        self.attachments = (attach == nil ? [] : attach!)
    }
    public func updateLikes() {
        let likes = NBClient.shared.storedTypes[Like.classIdentifier]?.filter({ ($0 as! Like).parent! == self }) as? [Like]
        self.commentLikes = (likes == nil ? [] : likes!)
        if commentLikes.isEmpty || commentLikes == nil {
            likedByCurrentUser = false
            likeFromCurrentUser = nil
        }
        else if commentLikes.count > 0 {
            let like = commentLikes.first(where: { $0.owner! == NBClient.shared.getCurrentUser() })
            
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
        self.creator = NBClient.shared.storedTypes[User.classIdentifier]?.first(where: { ($0 as! User) == self.creator }) as? User
        updateLikes()
        getAttachments()
    }
}

public class Like: NBModel {
    
    public var currentUserLiked: Bool { return owner! == NBClient.shared.getCurrentUser() ? true : false}
    
    override class var routeType: ItemType { return .like }
    
    required public init?(map: Map) {
        super.init(map: map)
    }
    init(parent: NBModel?) {
        super.init()
        self.parent = parent
    }
    override func setPayload() -> [String: Any] {
        var payload: [String: Any] = [:]
        payload["parent"] = self.parent!
        return payload
    }
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
    }
    
    override public func refresh() {
        self.owner = NBClient.shared.storedTypes[User.classIdentifier]?.first(where: { ($0 as! User) == self.owner! })// as! User
    }
}

class Notification: NBModel {

    var status: String?
    var text: String?
    var type: String!
    var name: String!
    
    public var unseenBool: Bool { return status == nil ? true : false }
    public var unreadBool: Bool { return status == nil || status!.contains("seen") ? true : false }
    public var notificationType: NotificationType { return NotificationType.init(rawValue: type)! }
    public var userProfilePicURL: URL { return URL(string: RequestKind.rpc.requestUrl(url: "notifications/" + self.resourceKey + "/getProfilePicture"))!.appendingQueryParameters(["uuid": UIDevice().uuid]) }
    
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


class Abuse: NBModel {
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
    override func setPayload() -> [String: Any] {
        var payload: [String: Any] = [:]
        payload["reason"] = self.reason
        payload["parent"] = self.parent!
        return payload
    }
    
    override func mapping(map: Map) {
        shouldMapParent = false
        super.mapping(map: map)
        reason <- map["reason"]
    }
}

class Setting: NBModel {
    var key: String!
    var value: Bool!
    
    public var group: String { return key.untilFirstCapital }
    
    override class var routeType: ItemType { return .setting }
    
    required public init?(map: Map) {
        super.init(map: map)
    }
    init(key: String, value: Bool) {
        super.init()
        self.key = key
        self.value = value
    }
    override func setPayload() -> [String: Any] {
        var payload: [String: Any] = [:]
        payload["key"] = self.key
        payload["value"] = self.value
        return payload
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        key <- map["key"]
        value <- map["value"]
    }
}

class SettingsDefault: Mappable, Equatable {
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
    
    static func == (lhs: SettingsDefault, rhs: SettingsDefault) -> Bool {
        return lhs.name == rhs.name
    }
}

class MobileSettingsDefault: SettingsDefault {
    required public init?(map: Map) { super.init(map: map) }
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        key <- map["mobile"]
        defaultValue <- map["mobileDefault"]
        findSetting()
    }
}
class EmailSettingsDefault: SettingsDefault {
    required public init?(map: Map) { super.init(map: map) }
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        key <- map["email"]
        defaultValue <- map["emailDefault"]
        findSetting()
    }
}
class WebSettingsDefault: SettingsDefault {
    required public init?(map: Map) { super.init(map: map) }
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        key <- map["web"]
        defaultValue <- map["webDefault"]
        findSetting()
    }
}

struct SettingsGroup {
    var sectionName: String!
    var sectionMobileSettings: [MobileSettingsDefault]!
    var sectionEmailSettings: [EmailSettingsDefault]!
    var sectionWebSettings: [WebSettingsDefault]!
}

class SettingDefaults: Mappable {
    var settingsMobile: [String: [MobileSettingsDefault]]!
    var settingsEmail: [String: [EmailSettingsDefault]]!
    var settingsWeb: [String: [WebSettingsDefault]]!
    var settingsArray = [SettingsGroup?](repeating: nil, count: 4)
    
    var settingsPositions = ["courses", "groups", "clubs", "posts"]
    
    public required init?(map: Map) { }
    
    public func mapping(map: Map) {
        settingsMobile <- map["notifications"]
        settingsEmail <- map["notifications"]
        settingsWeb <- map["notifications"]
        
        for (key,value) in settingsMobile {
            self.settingsArray[settingsPositions.index(of: key)!] = SettingsGroup(sectionName: key, sectionMobileSettings: value, sectionEmailSettings: settingsEmail[key], sectionWebSettings: settingsWeb[key])
        }
    }
}


