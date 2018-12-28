//
//  MappableModels.swift
//  Notebowl Mobile
//
//  Created by Conner Owen on 1/10/18.
//  Copyright © 2018 NoteBowl. All rights reserved.
//

import Foundation
import ObjectMapper
import Bugsnag
import URLPatterns
import DeckTransition

enum DeepLink {
    case home, bulletin, courses, notifications, groups, clubs, settings
    case bulletinPost(post: String)
    case course(permalink: String)
}

extension DeepLink {
    init?(url: URL) {
        let counted = url.countedPathComponents()
        switch counted {
            case .n0, .n1(""), .n1("bulletin"): self = .bulletin
            case .n2("bulletin", let post): self = .bulletinPost(post: post)
            case .n1("notifications"): self = .notifications
            case .n2("settings", _): self = .settings
            case .n1("groups"): self = .groups
            case .n4("groups", _, "bulletin", let post):   self = .bulletinPost(post: post)
            case .n1("courses"): self = .courses
            case .n2("courses", let permalink): self = .course(permalink: permalink)
            case .n3("courses", let permalink, _):   self = .course(permalink: permalink)
            case .n4("courses", _, "bulletin", let post):   self = .bulletinPost(post: post)
            case .n4("courses", let permalink, _, _):   self = .course(permalink: permalink)
            default: return nil
        }
    }
}

struct DeepLinker {
    static func open(link: DeepLink, animated: Bool = true) -> Bool {
        if let rootVC = UIApplication.shared.keyWindow?.rootViewController as? RootViewController, let tabVC = rootVC.presentedViewController as? MainTabBarViewController {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)

            if tabVC.topestViewController is HomeFeedPostViewController || tabVC.topestViewController is CourseAssignmentsTableView {
                (tabVC.selectedViewController as! RootNavigationBarVC).popViewController(animated: false)
            } else if tabVC.topestViewController is AccountModalViewController || tabVC.topestViewController is CreateNewPostViewController {
                tabVC.topestViewController!.dismiss(animated: true, completion: nil)
            }
            switch link {
            case .home, .bulletin:
                tabVC.selectedIndex = 0
            case .bulletinPost(post: let post):
                tabVC.selectedIndex = 0
                if let postNav = NBClient.shared.storedTypes[Post.classIdentifier]!.first(where: { $0.resourceKey == post }) as? Post {
                    let postDetailVC = storyboard.instantiateViewController(withIdentifier: "postViewController") as! HomeFeedPostViewController
                    postDetailVC.displayedPost = postNav
                    (tabVC.selectedViewController as! RootNavigationBarVC).pushViewController(postDetailVC, animated: false)
                }
            case .courses:
                tabVC.selectedIndex = 1
            case .course(permalink: let course):
                tabVC.selectedIndex = 1
                if let courseNav = NBClient.shared.storedTypes[Course.classIdentifier]!.first(where: { ($0 as! Course).permalink == course }) as? Course {
                    let courseDetailVC = storyboard.instantiateViewController(withIdentifier: "courseAssignmentsTableView") as! CourseAssignmentsTableView
                    courseDetailVC.selectedCourse = courseNav
                    (tabVC.selectedViewController as! RootNavigationBarVC).pushViewController(courseDetailVC, animated: true)
                }
            case .notifications:
                tabVC.selectedIndex = 2
            case .settings:
                NBClient.shared.delay(0.5) {
                    tabVC.topestViewController!.performSegue(withIdentifier: "segueDeck", sender: nil)
                }
            default:
                return false
            }
            return true
        }
        return false
    }
}

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

    static func fromURL(_ urlString: String) -> ItemType! {
        let urlComponents = URL(string: urlString)!.deletingLastPathComponent()
        let endpoint = urlComponents.lastPathComponent

        if endpoint == "users" { return ItemType(rawValue: "credentials") }

        guard let item = ItemType(rawValue: endpoint) else {
            let exception = NSException(name: NSExceptionName(rawValue: "ItemTypeNilException"), reason: "Object type \(endpoint) has not been implemented yet!", userInfo: nil )
            Bugsnag.notify(exception)
            return nil
        }
        return item
    }

    var className: String {
        switch self {
        case .user:
            return "User"
        case .category:
            return "Category"
        case .university:
            return "University"
        default:
            return String(self.rawValue.capitalised.dropLast())
        }
    }
}
extension ItemType {
    func returnRoute() -> String {
        let route = self.rawValue
        return ("https://\(baseUrl)/api/v1.0/" + route)
    }

    init?(_ item: String) {
        let countedString: Counted<String> = Counted(arrayLiteral: item)
        switch countedString {
        case .n1("User"):
            self = .user
        case .n1("Category"):
            self = .category
        case .n1("University"):
            self = .university
        case .n1("CourseUser"), .n1("GroupUser"):
            self = .enrollment
        case .n1(Regex("Attachment.*")):
            self = .attachment
        case .n1(Regex("AssignmentSubType.*")):
            self = .assignment
        default:
            self = ItemType(rawValue: "\(item.lowercased())s")!
        }
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

public enum GradeType: String {
    case points = "Points"
    case completion = "(In)complete"
    case percent = "Percentage"
    case letter = "Letter Grade"
}

public enum SubmissionType: String {
    case none = "No Submission"
    case fileSubmission = "File Submission"
    case discussionBoard = "Discussion Board"
}
public enum GroupType: String {
    case individual = "Individual"
    case group = "Group"
}

public enum UserRole: String {
    case admin = "Admin"
    case professor = "Professor"
    case student = "Student"
    case member = "Member"
    case TA = "TA"
}

public enum AssignmentStatus: String {
    case NotPublished = "Unpublished"
    case NotAvailableYet = "Not Available Yet"
    case NeedsGrading = "Needs Grading"
    case Grading = "Grading"

    case InProgress = "In Progress"
    case Graded = "Graded"
    case Submitted = "Submitted"
    case LateSubmission = "Late Submission"
    case Open = "Open"
    case PastDue = "Past Due"
    case Closed = "Closed"

    var sortValueProfessor: Int {
        switch self {
        case .NotPublished:
            return 2
        case .Graded:
            return 4
        case .Open:
            return 1
        case .NotAvailableYet:
            return 3
        case .NeedsGrading:
            return 0
        default:
            return 5
        }
    }

    var sortValue: Int {
        switch self {
        case .NotPublished:
            return 0
        case .InProgress:
            return 1
        case .Graded:
            return 2
        case .Submitted, .LateSubmission:
            return 3
        case .Open:
            return 4
        case .NotAvailableYet:
            return 5
        case .PastDue:
            return 6
        case .Closed:
            return 7
        default:
            return 9
        }
    }
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
            case "CourseUser", "GroupUser":
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
    var itemType: ItemType!
    var url: URL!
    var resourceKey: String!
    var parent: NBModel?
    var owner: NBModel?
    var related: NBModel?

    class var routeType: ItemType { return .user }

    class var endpoint: String { return self.routeType.returnRoute() }

    class var classIdentifier: ObjectIdentifier {
        return ObjectIdentifier(self)
    }

    func getParentByType<T>(_ parentType: T.Type, withSelf: Bool = false) -> T! where T: NBModel {
        if withSelf {
            if self.itemType == parentType.routeType {
                return self as? T
            }
        }

        var thisParent = self.parent

        while thisParent != nil {
            if thisParent!.itemType == parentType.routeType {
                return thisParent! as? T
            }

            thisParent = thisParent!.parent
        }
        return nil
    }

    func deleteSelf() {
        let deleteReq = NBNetworking.shared.request(.delete, url: self.url.absoluteString)
        if deleteReq.statusCode!.rawValue == 410, let itemType = ItemType.fromURL(self.url.absoluteString) {
            _ = NBSocket.shared.updateHandler(itemType: "\(itemType)", updateUrl: self.url.absoluteString, action: "deleted", updatedAt: "\(self.updatedAt!)")
        } else {
            if let keyPath = (deleteReq.json as AnyObject).value(forKeyPath: "result") as? [String: AnyObject], let url = keyPath["url"] as? String, let itemType = ItemType.fromURL(url) {
                _ = NBSocket.shared.updateHandler(itemType: "\(itemType)", updateUrl: (url), action: "deleted", updatedAt: (keyPath["updatedAt"] as! String))
            }
        }
    }

    public var firstTimeLoading: Bool!
    public var shouldMapParent: Bool!

    public var enrollmentForUser: Enrollment! {
        if let enroll = NBClient.shared.storedTypes[Enrollment.classIdentifier]?.first(where: { $0.parent == self && ($0 as! Enrollment).user == NBClient.shared.getCurrentUser()}) as? Enrollment {
            return enroll
        }
        return nil
    }

    public var secondsSinceUpdate: TimeInterval { return self.updatedAt.timeIntervalSinceReferenceDate }
    public var secondsSinceCreation: TimeInterval { return self.createdAt.timeIntervalSinceReferenceDate }

    func setPayload() -> [String: Any] { return [:] }
    func save(withCustomPayload: [String: Any]? = nil) -> NBModel? {

        var json: [String: Any] = [:]

        if withCustomPayload != nil {
            json = withCustomPayload!
        } else {
            let payloadJson = self.setPayload()
            for item in payloadJson {
                if item.value is NBModel {
                    json += ["_\(item.key)": "\((item.value as! NBModel).url.absoluteString)"]
                } else if item.value is Date {
                    json += [item.key: "\((item.value as! Date).toFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ"))"]
                } else {
                    json += [item.key: item.value]
                }
            }
        }

        var result: NBResult!

        if self.url != nil {
            result = NBNetworking.shared.request(.put, url: self.url.absoluteString, json: (json as Any))
        } else {
            result = NBNetworking.shared.request(.post, url: type(of: self).endpoint, json: (json as Any))
        }

        if result.statusCode!.rawValue == 422 {
            let exception = NSException(name: NSExceptionName(rawValue: "URLRequestException"), reason: "Status code 422: \(result.error.debugDescription) ", userInfo: nil )
            Bugsnag.notify(exception)
            return nil
        }
        if let keyPath = (result.json as AnyObject).value(forKeyPath: "result") as? [String: AnyObject], let url = keyPath["url"] as? String, let itemType = ItemType.fromURL(url) {
            let finalObject = NBSocket.shared.updateHandler(itemType: "\(itemType)", updateUrl: (url), action: "updated", updatedAt: (keyPath["updatedAt"] as! String))
            return finalObject
        }
        return nil
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
        itemType <- (map["itemType"], TransformOf<ItemType, String>(fromJSON: { ItemType($0!) }, toJSON: { $0!.rawValue }))
        url <- (map["url"], URLTransform(shouldEncodeURLString: true, allowedCharacterSet: .urlQueryAllowed))
        resourceKey <- map["resourceKey"]

        if shouldMapParent {
            if let parentString = map.JSON["_parent"] as? String, let itemType = ItemType.fromURL(parentString) {
                let parentMap = Mapper<Generic>().map(JSON: ["itemType": "\(itemType)", "updateUrl": "\(parentString)"])
                parent = parentMap?.genericObject
            }
        }
        if let ownerString = (map.JSON["_owner"] as? String), let itemType = ItemType.fromURL(ownerString) {
            let ownerMap = Mapper<Generic>().map(JSON: ["itemType": "\(itemType)", "updateUrl": "\(ownerString)"])
            owner = ownerMap?.genericObject
        }
        if let relatedString = (map.JSON["_related"] as? String), let itemType = ItemType.fromURL(relatedString) {
            let relatedMap = Mapper<Generic>().map(JSON: ["itemType": "\(itemType)", "updateUrl": "\(relatedString)"])
            related = relatedMap?.genericObject
        }
    }

    func equal(to: NBModel) -> Bool {
        return resourceKey == to.resourceKey
    }

}
extension NBModel: Hashable {
    public var hashValue: Int {
        return ObjectIdentifier(self).hashValue
    }
}

public func == (lhs: NBModel, rhs: NBModel) -> Bool {
    return lhs.equal(to: rhs)
}

public protocol PostsComments {
    var text: String! { get set }
    var editedAt: Date! { get }
    var isAnonymous: Bool! { get }
    var creator: User! { get }

    var attachments: [Attachment]! { get set }
    var comments: [Comment]! { get set }
    mutating func saveEditedObjectWithText(newText: String)
}
extension PostsComments {
    public mutating func saveEditedObjectWithText(newText: String) {
        self.text = newText
        _ = (self as! NBModel).save()
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
    var status: AssignmentStatus! { get }
    var userGrade: Grade! { get }
    var gradeScheme: GradeType! { get }
    var gradeString: String! { get }
    var points: Double! { get set }
    func getUserGrade() -> String
    func refreshCachedGradeString()
    func getStatus() -> AssignmentStatus
    func refreshCachedStatus()
}

extension AssignmentAssessment {
    var isAvailable: Bool { return (availableDate.isInPast || availableDate.isToday) }
    var isPastDue: Bool { return dueDate.isInPast }

    public func getRoundedGradePercent(grade: Double) -> Double {
        let rawPercent = grade / self.points * 100
        let percentRounded = rawPercent.rounded(toPlaces: ((self as! NBModel).parent as! Course).gradePrecision)
        return percentRounded
    }

    public func getStatus() -> AssignmentStatus {
        if let userRole = (self as! NBModel).parent?.enrollmentForUser.role {
            if userRole == .professor || userRole == .admin || userRole == .TA {
                if dueDate == nil { return AssignmentStatus.NotPublished }
                if availableDate.isInFuture { return AssignmentStatus.NotAvailableYet }

                if isPastDue {
                    if let firstGrade = userGrade, firstGrade.grade != nil {
                        return AssignmentStatus.Graded
                    } else {
                        return AssignmentStatus.NeedsGrading
                    }
                }
            } else if userRole == .student {
                if let grade = userGrade, grade.grade != nil {
                    return AssignmentStatus.Graded
                }

                if let selfAssignment = self as? Assignment {
                    if selfAssignment.submissionScheme == .fileSubmission {
                        if selfAssignment.fileSubmissions != nil {
                            if !selfAssignment.fileSubmissions.isEmpty {
                                return AssignmentStatus.Submitted
                            }
                        }
                    } else if selfAssignment.submissionScheme == .discussionBoard {
                        if selfAssignment.isUserSubmissionStarted {
                            if selfAssignment.hasRequirements && !selfAssignment.isUserSubmissionComplete {
                                if isPastDue {
                                    return AssignmentStatus.Submitted
                                }
                                return AssignmentStatus.InProgress
                            }
                            return AssignmentStatus.Submitted
                        }
                    }
                    if isPastDue && selfAssignment.allowLateSubmission {
                        return AssignmentStatus.PastDue
                    }
                } else if let selfAssessment = self as? Assessment {
                    if selfAssessment.submissions != nil, let userSubmission = selfAssessment.submissions.first {
                        if userSubmission.isInProgress {
                            return AssignmentStatus.InProgress
                        } else { return AssignmentStatus.Submitted }
                    }
                }
            }

            if !isPastDue && isAvailable {
                return AssignmentStatus.Open
            } else if isPastDue {
                return AssignmentStatus.Closed
            }
        }
        return AssignmentStatus.NotAvailableYet
    }

    public func getUserGrade() -> String {
        if userGrade == nil { return "Not Graded" }
        guard let gradePoints = userGrade.grade else { return "Not Graded" }

        if self.gradeScheme == .completion {
            return gradePoints == 0 && self.points! > 0 ? "Incomplete" : "Complete"
        } else if self.gradeScheme == .percent && ((self as! NBModel).parent as! Course).gradeGPAEnabled {
            var rawPercent = gradePoints / self.points * 100
            rawPercent = rawPercent / 100 * 4
            let gpaValue = rawPercent.rounded(toPlaces: ((self as! NBModel).parent as! Course).gradePrecision)
            return String(format: "%.2f", gpaValue)
        } else if self.gradeScheme == .percent {
            let percentFormatted = self.getRoundedGradePercent(grade: gradePoints)
            let places = ((self as! NBModel).parent as! Course).gradePrecision
            let formatString = "%.\(places!)f%%"
            return String(format: formatString, percentFormatted)
        } else if self.gradeScheme == .letter {
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
            } else {
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
            return "\(Int(gradePoints)) pts"
        } else {
            return "\(gradePoints) pts"
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
    var permalink: String!
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
        permalink <- map["permalink"]
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
        } else if profileUrl.absoluteString.contains("/latest/images/cover/default/default_") {
            let defaultName = profileUrl.deletingPathExtension().lastPathComponent
            if let defaults = Gradients.getDefaultGradients() {
                let gradientColor = Gradients.gradientColorWithName(defaults, name: defaultName)
                return [gradientColor!.startColor, gradientColor!.endColor]
            }
        } else {
            return [UIColor(hexString: "#BF4458"), UIColor(hexString: "#854D88")]
        }
        return [UIColor(hexString: "#BF4458"), UIColor(hexString: "#854D88")]
    }

    func firstTimeLoaded() {
        if firstTimeLoading != nil {
            if firstTimeLoading { firstTimeLoading = false }
        }
    }

    func refreshCachedAssignments() {
        var assignments = NBClient.shared.storedTypes[Assignment.classIdentifier]?.filter({ $0.parent == self }) as? [AssignmentAssessment]
        assignments = (assignments == nil ? [] : assignments!)
        if self.enrollmentForUser != nil, self.enrollmentForUser.role == .TA {
            assignments = assignments!.filter({($0 as! Assignment).gradeOnly == false})
        }
        let assessments = NBClient.shared.storedTypes[Assessment.classIdentifier]?.filter({ $0.parent == self }) as? [AssignmentAssessment]
        if assessments != nil { assignments! += assessments! }
        self.courseAssignments = assignments!
        let categories = NBClient.shared.storedTypes[Category.classIdentifier]?.filter({ $0.parent! == self }) as? [Category]
        self.courseCategories = (categories == nil ? [] : categories!)
    }

    override public func refresh() {
        refreshCachedAssignments()
    }
}

public class Assignment: NBModel, AssignmentAssessment {
    public var title: String!
    public var points: Double!
    public var dueDate: Date!
    public var availableDate: Date!
    public var desc: String!
    var gradeOnly: Bool!

    public var gradeScheme: GradeType!
    var type: GroupType!
    var gradesPublished: Bool!
    var allowLateSubmission: Bool!
    public var category: Category!
    public var submissionScheme: SubmissionType!

    public var minComments: Int!
    public var minPosts: Int!
    public var wordCountPosts: Int!
    public var wordCountComments: Int!
    public var postsWordCountRequired: String!
    public var commentsWordCountRequired: String!

    public var submissionPosts: [Post]!
    public var submissionComments: [Comment]!
    public var fileSubmissions: [Submission]!

    public var hasRequirements: Bool { return minPosts > 0 || minComments > 0 }

    public func postsMatchingWordCount() -> [Post] {
        var userPosts = [Post]()
        for post in submissionPosts {
            post.related = self
            post.parent = self
            if post.satisfiesWordCount { userPosts.append(post) }
        }
        return userPosts
    }
    public func commentsMatchingWordCount() -> [Comment] {
        var userComments = [Comment]()
        for comment in submissionComments {
            comment.related = self
            if comment.satisfiesWordCount { userComments.append(comment) }
        }
        return userComments
    }

    public var isUserSubmissionComplete: Bool {
        return self.postsMatchingWordCount().count >= self.minPosts && self.commentsMatchingWordCount().count >= self.minComments
    }

    public var isUserSubmissionStarted: Bool {
        if !submissionPosts.isEmpty || !submissionComments.isEmpty { return true }
        return false
    }

    public var userGrade: Grade!
    public var gradeString: String!
    public var status: AssignmentStatus!

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
        } else {
            desc <- map["description"]
        }
        gradeScheme <- (map["gradeScheme"], TransformOf<GradeType, String>(fromJSON: { GradeType(rawValue: $0!) }, toJSON: { $0!.rawValue }))
        type <- (map["type"], TransformOf<GroupType, String>(fromJSON: { GroupType(rawValue: $0!) }, toJSON: { $0!.rawValue }))
        gradesPublished <- map["gradesPublished"]
        allowLateSubmission <- map["lateSubmissionPermitted"]
        minComments <- map["minNumComments"]
        minPosts <- map["minNumPosts"]
        wordCountPosts <- map["wordCountPosts"]
        wordCountComments <- map["wordCountComments"]
        postsWordCountRequired <- map["postsRequired"]
        commentsWordCountRequired <- map["commentsRequired"]
        submissionScheme <- (map["submissionScheme"], TransformOf<SubmissionType, String>(fromJSON: { SubmissionType(rawValue: $0!) }, toJSON: { $0!.rawValue }))

        category <- (map["_category"], ObjectTransform<Category>())
        userGrade = nil

        submissionPosts = []
        submissionComments = []
        fileSubmissions = []
    }

    func refreshCachedSubmissions() {
        let posts = NBClient.shared.storedTypes[Post.classIdentifier]?.filter({ ($0.related == self) && (($0 as! Post).creator == NBClient.shared.getCurrentUser()) }) as? [Post]
        self.submissionPosts = (posts == nil ? [] : posts!)
        let comments = NBClient.shared.storedTypes[Comment.classIdentifier]?.filter({ ($0.related == self) && (($0 as! Comment).creator == NBClient.shared.getCurrentUser()) }) as? [Comment]
        self.submissionComments = (comments == nil ? [] : comments!)
        let submissions = NBClient.shared.storedTypes[Submission.classIdentifier]?.filter({ ($0.parent == self) && (($0 as! Submission).creator == NBClient.shared.getCurrentUser()) }) as? [Submission]
        self.fileSubmissions = (submissions == nil ? [] : submissions!)
    }

    public func refreshCachedGradeString() {
        if let grade = NBClient.shared.storedTypes[Grade.classIdentifier]?.first(where: {$0.parent == self}) as? Grade {
            self.userGrade = grade
        }

        self.gradeString = getUserGrade()
    }
    public func refreshCachedStatus() {
        self.status = getStatus()
    }

    override public func refresh() {
        refreshCachedSubmissions()
        refreshCachedGradeString()
        refreshCachedStatus()
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

public class Submission: NBModel {
    var text: String?
    public var creator: User!
    public var submittedLate: Bool { return createdAt.isAfterDate((self.parent as! Assignment).dueDate, orEqual: false, granularity: .second) }

    override class var routeType: ItemType { return .submission }

    required public init?(map: Map) {
        super.init(map: map)
    }

    override public func mapping(map: Map) {
        super.mapping(map: map)

        text <- map["text"]
        creator <- (map["_creator"], ObjectTransform<User>())
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
    public var points: Double!
    public var userGrade: Grade!
    public var gradeString: String!
    public var status: AssignmentStatus!

    public var submissions: [AssessmentSubmission]!

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
        submissions = []
    }

    func refreshCachedSubmissions() {
        let subs = NBClient.shared.storedTypes[AssessmentSubmission.classIdentifier]?.filter({ ($0.parent == self) && ($0.owner == NBClient.shared.getCurrentUser()) }) as? [AssessmentSubmission]
        self.submissions = (subs == nil ? [] : subs!)
    }

    public func refreshCachedPoints() {
        var pointsCalculated: Double = 0
        if let questions = NBClient.shared.storedTypes[AssessmentQuestion.classIdentifier]?.filter({ $0.parent == self }) as? [AssessmentQuestion] {
            for question in questions {
                if !question.extraCredit {
                    pointsCalculated += question.points
                }
            }
        }
        self.points = pointsCalculated
    }

    public func refreshCachedGradeString() {
        if let grade = NBClient.shared.storedTypes[Grade.classIdentifier]?.first(where: {$0.owner == self}) as? Grade {
            self.userGrade = grade
        }
        self.gradeString = getUserGrade()
    }
    public func refreshCachedStatus() {
        self.status = getStatus()
    }

    override public func refresh() {
        refreshCachedSubmissions()
        refreshCachedPoints()
        refreshCachedGradeString()
        refreshCachedStatus()
    }
}

class AssessmentQuestion: NBModel {
    var questionScheme: String!
    var title: String!
    var points: Double!
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

public class AssessmentSubmission: NBModel {
    var startDate: Date!
    var endDate: Date!

    public var isInProgress: Bool { return endDate == nil }

    override class var routeType: ItemType { return .assessmentSubmission }

    required public init?(map: Map) {
        super.init(map: map)
    }

    override public func mapping(map: Map) {
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
    var lastAccessAt: Date!

    public var statusIsAccepted: Bool {
        if status.contains("Accepted") { return true } else { return false }
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
    public var externalAttachments: [Attachment]!
    var pinned: Bool!
    var availableDate: Date?
    public var postLikes: [Like]!
    public var comments: [Comment]!
    public var likedByCurrentUser: Bool!
    public var likeFromCurrentUser: Like?

    public var satisfiesWordCount: Bool {
        guard let parentDiscussionBoard = self.related as? Assignment else { return false }
        if parentDiscussionBoard.postsWordCountRequired == "Required" {
            if self.text.wordCount >= parentDiscussionBoard.wordCountPosts {
                return true
            }
        } else if parentDiscussionBoard.postsWordCountRequired == "Recommended" {
            return true
        }
        return false
    }

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
        comments = []
        attachments = []
        externalAttachments = []
        likedByCurrentUser = false
        likeFromCurrentUser = nil

        setupObservers()
    }

    func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdatedPost(_:)), name: .SocketDidReceiveUpdatedPost, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdatedComment(_:)), name: .SocketDidReceiveUpdatedComment, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdatedLike(_:)), name: .SocketDidReceiveUpdatedLike, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdatedAttachment(_:)), name: .SocketDidReceiveUpdatedAttachment, object: nil)
    }

    @objc func handleUpdatedPost(_ notification: NSNotification) {
        guard let dict = notification.userInfo as NSDictionary?, let newPost = dict["object"] as? Post, newPost == self else {
            return
        }

        if newPost.updatedAt > self.updatedAt {
            self.text = newPost.text
            self.editedAt = newPost.editedAt
            self.availableDate = newPost.availableDate
            self.pinned = newPost.pinned
            self.updatedAt = newPost.updatedAt
        }
    }

    @objc func handleUpdatedComment(_ notification: NSNotification) {
        guard let dict = notification.userInfo as NSDictionary?, let newComment = dict["object"] as? Comment else {
            return
        }
        guard newComment.parent == self else {
            return
        }

        if newComment.isCommentReply {
            return
        }
        if !self.comments.contains(newComment) {
            self.comments.append(newComment)
        }
    }

    @objc func handleUpdatedLike(_ notification: NSNotification) {
        guard let dict = notification.userInfo as NSDictionary?, let newLike = dict["object"] as? Like else {
            return
        }
        guard newLike.parent == self else {
            return
        }

        if self.postLikes.contains(newLike) {
            return
        }

        self.postLikes.append(newLike)
        if newLike.owner == NBClient.shared.getCurrentUser() {
            self.likedByCurrentUser = true
            self.likeFromCurrentUser = newLike
        }
    }

    @objc func handleUpdatedAttachment(_ notification: NSNotification) {
        guard let dict = notification.userInfo as NSDictionary?, let newAttachment = dict["object"] as? Attachment else {
            return
        }
        guard newAttachment.parent == self else {
            return
        }

        if newAttachment.mimeType == .image, !self.attachments.contains(newAttachment) {
            self.attachments.append(newAttachment)
        } else if newAttachment.attachmentScheme == .External, !self.externalAttachments.contains(newAttachment)  {
            self.externalAttachments.append(newAttachment)
        }
    }

    func totalCommentsCount() -> Int {
        var count = self.comments.count
        for comment in self.comments {
            count += comment.comments.count
        }

        return count
    }

    func refreshCachedLikes() {
        let likes = NBClient.shared.storedTypes[Like.classIdentifier]?.filter({ ($0 as! Like).parent! == self }) as? [Like]
        self.postLikes = (likes == nil ? [] : likes!)
        if postLikes.isEmpty || postLikes == nil {
            likedByCurrentUser = false
            likeFromCurrentUser = nil
        } else if postLikes.count > 0 {
            let like = postLikes.first(where: { $0.owner! == NBClient.shared.getCurrentUser() })

            if like != nil {
                likedByCurrentUser = true
                likeFromCurrentUser = like
            } else if like == nil {
                likedByCurrentUser = false
                likeFromCurrentUser = nil
            }
        }
    }
    func refreshCachedCommentsAttachments() {
        let comments = NBClient.shared.storedTypes[Comment.classIdentifier]?.filter({ $0.parent! == self }) as? [Comment]
        self.comments = (comments == nil ? [] : comments!)

        let attach = NBClient.shared.storedTypes[Attachment.classIdentifier]?.filter({ $0.parent! == self && ($0 as! Attachment).mimeType == .image }) as? [Attachment]
        self.attachments = (attach == nil ? [] : attach!)
        let attachExt = NBClient.shared.storedTypes[Attachment.classIdentifier]?.filter({ $0.parent! == self && ($0 as! Attachment).attachmentScheme == .External }) as? [Attachment]
        self.externalAttachments = (attachExt == nil ? [] : attachExt!)
    }

    override public func refresh() {
        refreshCachedCommentsAttachments()
        refreshCachedLikes()
    }
}

public enum AttachmentScheme: String {
    case Book = "Book"
    case Conference = "Conference"
    case External = "External"
    case S3 = "S3"
    case YouTube = "YouTube"
    case Zoom = "Zoom"
}

public enum AttachmentTypes: String {
    case audio, image, website, video, document, unsupported

    enum Images: String {
        case gif = "image/gif"
        case jpeg = "image/jpeg"
        case png = "image/png"
        case svg = "image/svg+xml"
        case tiff = "image/tiff"
    }

    public init?(typeValue: String!) {
        if typeValue == nil { self.init(rawValue: "unsupported") } else {
            let slash = CharacterSet.init(charactersIn: "/")
            let parts = typeValue.components(separatedBy: slash)
            self.init(rawValue: parts[0])
        }
    }
}

public class Attachment: NBModel {
    var embeddable: Bool!
    var location: String!
    var previewUrls: [String: [String]]!
    var thumbnailUrl: String!
    var attachmentName: String!
    var attachmentScheme: AttachmentScheme!
    var availableDate: Date!
    var fileName: String!
    var size: Int!
    var status: String!
    var mimeType: AttachmentTypes!

    var ext: String!
    var downloadUrl: String!
    var fileId: String!

    var title: String!
    var desc: String!
    var domain: String!

    var authors: String!
    var isRequired: Bool!
    var pageCount: Int!
    var amazonLink: String!
    var recommendAmazon: Bool!
    var appleLink: String!
    var recommendApple: Bool!

    var duration: Int!
    var ytThumbnail: String!
    var paths: [String: [String]]!

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

        embeddable  <- map["embeddable"]
        location <- (map["location"])
        previewUrls <- map["previewUrls"]
        thumbnailUrl <- map["thumbnailUrl"]
        attachmentName <- map["attachmentName"]
        attachmentScheme <- (map["attachmentScheme"], TransformOf<AttachmentScheme, String>(fromJSON: { AttachmentScheme(rawValue: $0!) }, toJSON: { $0!.rawValue }))
        availableDate <- (map["availableDate"], ISO8601FixedDateTransform())
        fileName <- map["fileName"]
        size <- map["size"]
        status <- map["status"]
        mimeType <- (map["type"], TransformOf<AttachmentTypes, String>(fromJSON: { AttachmentTypes(typeValue: $0) }, toJSON: { $0!.rawValue }))

        ext <- map["extension"]
        downloadUrl <- map["downloadUrl"]
        fileId <- map["fileId"]

        title <- map["title"]
        desc <- map["description"]
        domain <- map["domain"]
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
    public var externalAttachments: [Attachment]!
    public var commentLikes: [Like]!
    public var comments: [Comment]!
    public var likedByCurrentUser: Bool!
    public var likeFromCurrentUser: Like?
    public var isCommentReply: Bool { return (self.parent is Comment) }

    public var satisfiesWordCount: Bool {
        guard let parentDiscussionBoard = self.related as? Assignment else { return false }
        if parentDiscussionBoard.commentsWordCountRequired == "Required" {
            if self.text.wordCount >= parentDiscussionBoard.wordCountComments {
                return true
            }
        } else if parentDiscussionBoard.commentsWordCountRequired == "Recommended" {
            return true
        }
        return false
    }

    override class var routeType: ItemType { return .comment }

    required public init?(map: Map) {
        super.init(map: map)
    }
    init(text: String, owner: NBModel?, parent: NBModel?, related: NBModel?, isAnonymous: Bool?) {
        super.init()
        self.text = text
        self.owner = owner
        self.parent = parent
        self.related = related
        self.isAnonymous = isAnonymous
    }
    override func setPayload() -> [String: Any] {
        var payload: [String: Any] = [:]
        payload["text"] = text
        payload["parent"] = self.parent!
        payload["owner"] = self.owner!
        payload["related"] = self.related!
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
        externalAttachments = []
        commentLikes = []
        comments = []
        likedByCurrentUser = false
        likeFromCurrentUser = nil

        setupObservers()
    }

    func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdatedComment(_:)), name: .SocketDidReceiveUpdatedComment, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdatedLike(_:)), name: .SocketDidReceiveUpdatedLike, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdatedAttachment(_:)), name: .SocketDidReceiveUpdatedAttachment, object: nil)
    }

    @objc func handleUpdatedComment(_ notification: NSNotification) {
        guard let dict = notification.userInfo as NSDictionary?, let newComment = dict["object"] as? Comment else {
            return
        }

        if newComment == self, newComment.updatedAt > self.updatedAt  {
            self.text = newComment.text
            self.editedAt = newComment.editedAt
            self.updatedAt = newComment.updatedAt
        } else if newComment.parent == self, !self.comments.contains(newComment) {
            self.comments.append(newComment)
        }
    }

    @objc func handleUpdatedLike(_ notification: NSNotification) {
        guard let dict = notification.userInfo as NSDictionary?, let newLike = dict["object"] as? Like else {
            return
        }
        guard newLike.parent == self else {
            return
        }

        if self.commentLikes.contains(newLike) {
            return
        }

        self.commentLikes.append(newLike)
        if newLike.owner == NBClient.shared.getCurrentUser() {
            self.likedByCurrentUser = true
            self.likeFromCurrentUser = newLike
        }
    }

    @objc func handleUpdatedAttachment(_ notification: NSNotification) {
        guard let dict = notification.userInfo as NSDictionary?, let newAttachment = dict["object"] as? Attachment else {
            return
        }
        guard newAttachment.parent == self else {
            return
        }

        if newAttachment.mimeType == .image, !self.attachments.contains(newAttachment) {
            self.attachments.append(newAttachment)
        } else if newAttachment.attachmentScheme == .External, !self.externalAttachments.contains(newAttachment)  {
            self.externalAttachments.append(newAttachment)
        }
    }

    public func refreshCachedAttachments() {
        let comments = NBClient.shared.storedTypes[Comment.classIdentifier]?.filter({ $0.parent! == self }) as? [Comment]
        self.comments = (comments == nil ? [] : comments!)

        let attach = NBClient.shared.storedTypes[Attachment.classIdentifier]?.filter({ $0.parent == self && ($0 as! Attachment).mimeType == .image }) as? [Attachment]
        self.attachments = (attach == nil ? [] : attach!)
        let attachExt = NBClient.shared.storedTypes[Attachment.classIdentifier]?.filter({ $0.parent! == self && ($0 as! Attachment).attachmentScheme == .External }) as? [Attachment]
        self.externalAttachments = (attachExt == nil ? [] : attachExt!)
    }
    public func refreshCachedLikes() {
        let likes = NBClient.shared.storedTypes[Like.classIdentifier]?.filter({ ($0 as! Like).parent! == self }) as? [Like]
        self.commentLikes = (likes == nil ? [] : likes!)
        if commentLikes.isEmpty || commentLikes == nil {
            likedByCurrentUser = false
            likeFromCurrentUser = nil
        } else if commentLikes.count > 0 {
            let like = commentLikes.first(where: { $0.owner! == NBClient.shared.getCurrentUser() })

            if like != nil {
                likedByCurrentUser = true
                likeFromCurrentUser = like
            } else if like == nil {
                likedByCurrentUser = false
                likeFromCurrentUser = nil
            }
        }
    }

    override public func refresh() {
        refreshCachedLikes()
        refreshCachedAttachments()
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
}

class Notification: NBModel {

    var status: String!
    var text: String!
    var type: String!

    public var unseenBool: Bool { return status == nil ? true : false }
    public var unreadBool: Bool { return status == nil || status!.contains("seen") ? true : false }
    public var notificationType: NotificationType { return NotificationType.init(rawValue: type)! }
    public var userProfilePicURL: URL { return URL(string: RequestKind.rpc.requestUrl(url: "notifications/" + self.resourceKey + "/getProfilePicture"))!.appendingQueryParameters(["uuid": UIDevice().uuid]) }

    override class var routeType: ItemType { return .notification }

    required public init?(map: Map) {
        super.init(map: map)
    }

    init(status: String, text: String, type: String) {
        super.init()
        self.status = status
        self.text = text
        self.type = type
    }

    override func mapping(map: Map) {
        shouldMapParent = false
        super.mapping(map: map)

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

        for (key, value) in settingsMobile {
            self.settingsArray[settingsPositions.index(of: key)!] = SettingsGroup(sectionName: key, sectionMobileSettings: value, sectionEmailSettings: settingsEmail[key], sectionWebSettings: settingsWeb[key])
        }
    }
}

