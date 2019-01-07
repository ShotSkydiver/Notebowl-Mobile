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
                if let postNav: Post = Post.getCache().first(where: { $0.resourceKey == post }) {
                    let postDetailVC = storyboard.instantiateViewController(withIdentifier: "postViewController") as! HomeFeedPostViewController
                    postDetailVC.displayedPost = postNav
                    (tabVC.selectedViewController as! RootNavigationBarVC).pushViewController(postDetailVC, animated: false)
                }
            case .courses:
                tabVC.selectedIndex = 1
            case .course(permalink: let course):
                tabVC.selectedIndex = 1
                if let courseNav: Course = Course.getCache().first(where: { $0.permalink == course }) {
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
        case .n1("CourseUser"), .n1("GroupUser"), .n1("EventUser"):
            self = .enrollment
        case .n1(Regex("Attachment.*")):
            self = .attachment
        case .n1(Regex("AssignmentSubType.*")):
            self = .assignment
        default:
            self = ItemType(rawValue: "\(item.lowercase)s")!
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
    var updatedAt: Date!

    public var genericObject: NBModel?

    class func objectForMapping(map: Map) -> BaseMappable? {
        if let url: String = map["updateUrl"].value(), let itemType = ItemType.fromURL(url) {
            switch itemType.className {
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
    init() {
    }

    func mapping(map: Map) {
        updatedAt <- (map["updatedAt"], ISO8601FixedDateTransform())
    }
}

class Response<T>: Generic where T: NBModel {
    var responseObject: T!

    public override init() {}
    public required init?(map: Map) { }

    public override func mapping(map: Map) {
        super.mapping(map: map)
        responseObject <- (map["updateUrl"], ObjectTransform<T>(update: updatedAt))
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
        NBClient.shared.decacheMappable(object: self)
    }

    public var firstTimeLoading: Bool!
    public var shouldMapParent: Bool!

    public var enrollmentForUser: Enrollment! {
        guard let enrollment: Enrollment = Enrollment.getCache().first(where: { $0.parent == self && $0.user == NBClient.shared.getCurrentUser() }) else {
            return nil
        }
        return enrollment
    }

    class func getCache<T>() -> [T] where T: NBModel {
        if !NBClient.shared.storedTypes.has(key: self.routeType) {
            NBClient.shared.storedTypes[self.routeType] = []
        }

        let objects = NBClient.shared.storedTypes[self.routeType]

        return objects as! [T]
    }

    class func removeFromCache<T>(object: T) where T: NBModel {
        NBClient.shared.storedTypes[self.routeType]?.removeAll(object)
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

        if let keyPath = (result.json as AnyObject).value(forKeyPath: "result") as? [String: AnyObject], let url = keyPath["url"] as? String {
            let mapReq = NBClient.shared.getMappable(type(of: self), url: url)

            if let newObject = mapReq?.first {
                return newObject
            }
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
                let parentMap = Mapper<Generic>().map(JSON: ["updateUrl": "\(parentString)"])
                parent = parentMap?.genericObject
            }
        }
        if let ownerString = (map.JSON["_owner"] as? String), let itemType = ItemType.fromURL(ownerString) {
            let ownerMap = Mapper<Generic>().map(JSON: ["updateUrl": "\(ownerString)"])
            owner = ownerMap?.genericObject
        }
        if let relatedString = (map.JSON["_related"] as? String), let itemType = ItemType.fromURL(relatedString) {
            let relatedMap = Mapper<Generic>().map(JSON: ["updateUrl": "\(relatedString)"])
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
    var externalAttachments: [Attachment]! { get set }
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

            if percentGrade < 0 {
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

        setupObservers()
    }

    func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(beginUpdatingUser(_:)), name: NSNotification.Name("ModelDidBeginUpdatingUser"), object: nil)
    }

    @objc func beginUpdatingUser(_ notification: NSNotification) {
        guard let dict = notification.userInfo as NSDictionary?, let newUser = dict["object"] as? User, newUser == self else {
            return
        }

        if newUser.updatedAt > self.updatedAt {
            self.profileUrl = newUser.profileUrl
            self.updatedAt = newUser.updatedAt
        }
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
    var fullName: String! { return (courseCode + ": " + name) }
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

        courseAssignments = []
        courseCategories = []

        setupObservers()
    }

    func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(beginUpdatingCourse(_:)), name: NSNotification.Name("ModelDidBeginUpdatingCourse"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(beginUpdatingAssignment(_:)), name: NSNotification.Name("ModelDidBeginUpdatingAssignment"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(beginUpdatingAssignment(_:)), name: NSNotification.Name("ModelDidBeginUpdatingAssessment"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(beginUpdatingCategory(_:)), name: NSNotification.Name("ModelDidBeginUpdatingCategory"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(beginDeletingAssignment(_:)), name: NSNotification.Name("ModelDidBeginDeletingAssignment"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(beginDeletingAssignment(_:)), name: NSNotification.Name("ModelDidBeginDeletingAssessment"), object: nil)
    }

    @objc func beginUpdatingCourse(_ notification: NSNotification) {
        guard let dict = notification.userInfo as NSDictionary?, let newCourse = dict["object"] as? Course, newCourse == self else {
            return
        }

        if newCourse.updatedAt > self.updatedAt {
            self.profileUrl = newCourse.profileUrl
            self.name = newCourse.name
            self.units = newCourse.units
            self.location = newCourse.location
            self.desc = newCourse.desc
            self.availableDate = newCourse.availableDate
            self.endDate = newCourse.endDate
            self.updatedAt = newCourse.updatedAt
        }
    }

    @objc func beginUpdatingAssignment(_ notification: NSNotification) {
        guard let dict = notification.userInfo as NSDictionary?, let newAssignment = dict["object"] as? NBModel else {
            return
        }

        if newAssignment.parent != self {
            return
        }

        if newAssignment is Assignment && enrollmentForUser.role == .TA && (newAssignment as! Assignment).gradeOnly {
            return
        }

        if !self.courseAssignments.contains(where: {($0 as! NBModel) == newAssignment}) {
            self.courseAssignments.append(newAssignment as! AssignmentAssessment)
        }
    }

    @objc func beginUpdatingCategory(_ notification: NSNotification) {
        guard let dict = notification.userInfo as NSDictionary?, let newCategory = dict["object"] as? Category else {
            return
        }

        if newCategory.parent != self {
            return
        }

        if !self.courseCategories.contains(newCategory) {
            self.courseCategories.append(newCategory)
        }
    }

    @objc func beginDeletingAssignment(_ notification: NSNotification) {
        guard let dict = notification.userInfo as NSDictionary?, let deletingAssignment = dict["object"] as? NBModel else {
            return
        }

        if deletingAssignment.parent != self {
            return
        }

        if self.courseAssignments.contains(where: {($0 as! NBModel) == deletingAssignment}) {
            self.courseAssignments.removeAll(where: {($0 as! NBModel) == deletingAssignment})
        }
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
        var assignments: [Assignment] = Assignment.getCache().filter({ $0.parent == self })

        if self.enrollmentForUser != nil, self.enrollmentForUser.role == .TA {
            assignments = assignments.filter({ !$0.gradeOnly })
        }
        courseAssignments = assignments
        let assessments: [Assessment] = Assessment.getCache().filter({ $0.parent == self })
        courseAssignments += assessments as [AssignmentAssessment]

        courseCategories = Category.getCache().filter({ $0.parent == self })
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

        setupObservers()
    }

    func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(beginUpdatingAssignment(_:)), name: NSNotification.Name("ModelDidBeginUpdatingAssignment"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(beginUpdatingPost(_:)), name: NSNotification.Name("ModelDidBeginUpdatingPost"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(beginUpdatingComment(_:)), name: NSNotification.Name("ModelDidBeginUpdatingComment"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(beginUpdatingSubmission(_:)), name: NSNotification.Name("ModelDidBeginUpdatingSubmission"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(beginUpdatingGrade(_:)), name: NSNotification.Name("ModelDidBeginUpdatingGrade"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(beginDeletingPost(_:)), name: NSNotification.Name("ModelDidBeginDeletingPost"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(beginDeletingComment(_:)), name: NSNotification.Name("ModelDidBeginDeletingComment"), object: nil)
    }

    @objc func beginUpdatingAssignment(_ notification: NSNotification) {
        guard let dict = notification.userInfo as NSDictionary?, let newAssignment = dict["object"] as? Assignment, newAssignment == self else {
            return
        }

        if newAssignment.updatedAt > self.updatedAt {
            self.category = newAssignment.category
            self.title = newAssignment.title
            self.points = newAssignment.points
            self.dueDate = newAssignment.dueDate
            self.availableDate = newAssignment.availableDate
            self.desc = newAssignment.desc
            self.gradeScheme = newAssignment.gradeScheme
            self.type = newAssignment.type
            self.gradesPublished = newAssignment.gradesPublished
            self.allowLateSubmission = newAssignment.allowLateSubmission
            self.minComments = newAssignment.minComments
            self.minPosts = newAssignment.minPosts
            self.wordCountPosts = newAssignment.wordCountPosts
            self.wordCountComments = newAssignment.wordCountComments
            self.postsWordCountRequired = newAssignment.postsWordCountRequired
            self.commentsWordCountRequired = newAssignment.commentsWordCountRequired
            self.updatedAt = newAssignment.updatedAt
            self.status = getStatus()
        }
    }

    @objc func beginUpdatingPost(_ notification: NSNotification) {
        guard let dict = notification.userInfo as NSDictionary?, let newPost = dict["object"] as? Post else {
            return
        }

        if newPost.related != self {
            return
        }

        if !self.submissionPosts.contains(newPost) {
            self.submissionPosts.append(newPost)
        }

        self.status = getStatus()
    }

    @objc func beginUpdatingComment(_ notification: NSNotification) {
        guard let dict = notification.userInfo as NSDictionary?, let newComment = dict["object"] as? Comment else {
            return
        }

        if newComment.isCommentReply || newComment.related != self {
            return
        }

        if !self.submissionComments.contains(newComment) {
            self.submissionComments.append(newComment)
        }

        self.status = getStatus()
    }

    @objc func beginUpdatingSubmission(_ notification: NSNotification) {
        guard let dict = notification.userInfo as NSDictionary?, let newSubmission = dict["object"] as? Submission else {
            return
        }

        if newSubmission.creator != NBClient.shared.getCurrentUser() || newSubmission.parent != self {
            return
        }

        if !self.fileSubmissions.contains(newSubmission) {
            self.fileSubmissions.append(newSubmission)
        }

        self.status = getStatus()
    }

    @objc func beginUpdatingGrade(_ notification: NSNotification) {
        guard let dict = notification.userInfo as NSDictionary?, let newGrade = dict["object"] as? Grade else {
            return
        }

        if newGrade.parent != self {
            return
        }
        
        self.userGrade = newGrade
        self.gradeString = getUserGrade()
        self.status = getStatus()
    }

    @objc func beginDeletingPost(_ notification: NSNotification) {
        guard let dict = notification.userInfo as NSDictionary?, let deletingPost = dict["object"] as? Post else {
            return
        }

        if deletingPost.related != self {
            return
        }

        if self.submissionPosts.contains(deletingPost) {
            self.submissionPosts.removeAll(deletingPost)
        }

        self.status = getStatus()
    }

    @objc func beginDeletingComment(_ notification: NSNotification) {
        guard let dict = notification.userInfo as NSDictionary?, let deletingComment = dict["object"] as? Comment else {
            return
        }

        if deletingComment.isCommentReply || deletingComment.related != self {
            return
        }

        if self.submissionComments.contains(deletingComment) {
            self.submissionComments.removeAll(deletingComment)
        }

        self.status = getStatus()
    }

    func refreshCachedSubmissions() {
        self.submissionPosts = Post.getCache().filter({ $0.related == self && $0.creator == NBClient.shared.getCurrentUser() })
        self.submissionComments = Comment.getCache().filter({ $0.related == self && $0.creator == NBClient.shared.getCurrentUser() })
        self.fileSubmissions = Submission.getCache().filter({ $0.parent == self && $0.creator == NBClient.shared.getCurrentUser() })
    }

    public func refreshCachedGradeString() {
        if let grade: Grade = Grade.getCache().first(where: {$0.parent == self}) {
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

        setupObservers()
    }

    func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(beginUpdatingAssessment(_:)), name: NSNotification.Name("ModelDidBeginUpdatingAssessment"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(beginUpdatingSubmission(_:)), name: NSNotification.Name("ModelDidBeginUpdatingSubmission"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(beginUpdatingGrade(_:)), name: NSNotification.Name("ModelDidBeginUpdatingGrade"), object: nil)
    }

    @objc func beginUpdatingAssessment(_ notification: NSNotification) {
        guard let dict = notification.userInfo as NSDictionary?, let newAssessment = dict["object"] as? Assessment, newAssessment == self else {
            return
        }

        if newAssessment.updatedAt > self.updatedAt {
            self.category = newAssessment.category
            self.title = newAssessment.title
            self.dueDate = newAssessment.dueDate
            self.availableDate = newAssessment.availableDate
            self.desc = newAssessment.desc
            self.gradeScheme = newAssessment.gradeScheme
            self.gradesPublished = newAssessment.gradesPublished
            self.updatedAt = newAssessment.updatedAt
            self.status = getStatus()
        }
    }

    @objc func beginUpdatingSubmission(_ notification: NSNotification) {
        guard let dict = notification.userInfo as NSDictionary?, let newSubmission = dict["object"] as? AssessmentSubmission else {
            return
        }

        if newSubmission.owner != NBClient.shared.getCurrentUser() || newSubmission.parent != self {
            return
        }

        if !self.submissions.contains(newSubmission) {
            self.submissions.append(newSubmission)
        }

        self.status = getStatus()
    }

    @objc func beginUpdatingGrade(_ notification: NSNotification) {
        guard let dict = notification.userInfo as NSDictionary?, let newGrade = dict["object"] as? Grade else {
            return
        }

        if newGrade.parent != self {
            return
        }

        self.userGrade = newGrade
        self.gradeString = getUserGrade()
        self.status = getStatus()
    }

    func refreshCachedSubmissions() {
        self.submissions = AssessmentSubmission.getCache().filter({ $0.parent == self && $0.owner == NBClient.shared.getCurrentUser() })
    }

    public func refreshCachedPoints() {
        var pointsCalculated: Double = 0
        let questions: [AssessmentQuestion] = AssessmentQuestion.getCache().filter({ $0.parent == self })

        for question in questions {
            if !question.extraCredit {
                pointsCalculated += question.points
            }
        }
        self.points = pointsCalculated
    }

    public func refreshCachedGradeString() {
        if let grade: Grade = Grade.getCache().first(where: {$0.owner == self}) {
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

        setupObservers()
    }

    func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(beginUpdatingAssessmentQuestion(_:)), name: NSNotification.Name("ModelDidBeginUpdatingAssessmentQuestion"), object: nil)
    }

    @objc func beginUpdatingAssessmentQuestion(_ notification: NSNotification) {
        guard let dict = notification.userInfo as NSDictionary?, let newQuestion = dict["object"] as? AssessmentQuestion, newQuestion == self else {
            return
        }

        if newQuestion.updatedAt > self.updatedAt {
            self.title = newQuestion.title
            self.points = newQuestion.points
            self.desc = newQuestion.desc
            self.extraCredit = newQuestion.extraCredit
            self.updatedAt = newQuestion.updatedAt
        }
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

        setupObservers()
    }

    func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(beginUpdatingAssessmentSubmission(_:)), name: NSNotification.Name("ModelDidBeginUpdatingAssessmentSubmission"), object: nil)
    }

    @objc func beginUpdatingAssessmentSubmission(_ notification: NSNotification) {
        guard let dict = notification.userInfo as NSDictionary?, let newSubmission = dict["object"] as? AssessmentSubmission, newSubmission == self else {
            return
        }

        if newSubmission.updatedAt > self.updatedAt {
            self.startDate = newSubmission.startDate
            self.endDate = newSubmission.endDate
            self.updatedAt = newSubmission.updatedAt
        }
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

        setupObservers()
    }

    func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(beginUpdatingCategory(_:)), name: NSNotification.Name("ModelDidBeginUpdatingCategory"), object: nil)
    }

    @objc func beginUpdatingCategory(_ notification: NSNotification) {
        guard let dict = notification.userInfo as NSDictionary?, let newCategory = dict["object"] as? Category, newCategory == self else {
            return
        }

        if newCategory.updatedAt > self.updatedAt {
            self.title = newCategory.title
            self.weight = newCategory.weight
            self.isExtraCredit = newCategory.isExtraCredit
            self.dropLowest = newCategory.dropLowest
            self.updatedAt = newCategory.updatedAt
        }
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

        setupObservers()
    }

    func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(beginUpdatingGrade(_:)), name: NSNotification.Name("ModelDidBeginUpdatingGrade"), object: nil)
    }

    @objc func beginUpdatingGrade(_ notification: NSNotification) {
        guard let dict = notification.userInfo as NSDictionary?, let newGrade = dict["object"] as? Grade, newGrade == self else {
            return
        }

        if newGrade.updatedAt > self.updatedAt {
            self.grade = newGrade.grade
            self.updatedAt = newGrade.updatedAt
        }
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

        setupObservers()
    }

    func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(beginUpdatingEnrollment(_:)), name: NSNotification.Name("ModelDidBeginUpdatingEnrollment"), object: nil)
    }

    @objc func beginUpdatingEnrollment(_ notification: NSNotification) {
        guard let dict = notification.userInfo as NSDictionary?, let newEnrollment = dict["object"] as? Enrollment, newEnrollment == self else {
            return
        }

        if newEnrollment.updatedAt > self.updatedAt {
            self.role = newEnrollment.role
            self.status = newEnrollment.status
            self.lastAccessAt = newEnrollment.lastAccessAt
            self.updatedAt = newEnrollment.updatedAt
        }
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
        NotificationCenter.default.addObserver(self, selector: #selector(beginUpdatingPost(_:)), name: NSNotification.Name("ModelDidBeginUpdatingPost"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(beginUpdatingComment(_:)), name: NSNotification.Name("ModelDidBeginUpdatingComment"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(beginUpdatingLike(_:)), name: NSNotification.Name("ModelDidBeginUpdatingLike"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(beginUpdatingAttachment(_:)), name: NSNotification.Name("ModelDidBeginUpdatingAttachment"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(beginDeletingComment(_:)), name: NSNotification.Name("ModelDidBeginDeletingComment"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(beginDeletingLike(_:)), name: NSNotification.Name("ModelDidBeginDeletingLike"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(beginDeletingAttachment(_:)), name: NSNotification.Name("ModelDidBeginDeletingAttachment"), object: nil)
    }

    @objc func beginUpdatingPost(_ notification: NSNotification) {
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

    @objc func beginUpdatingComment(_ notification: NSNotification) {
        guard let dict = notification.userInfo as NSDictionary?, let newComment = dict["object"] as? Comment else {
            return
        }

        if newComment.isCommentReply || newComment.parent != self {
            return
        }

        if !self.comments.contains(newComment) {
            self.comments.append(newComment)
        }
    }

    @objc func beginUpdatingLike(_ notification: NSNotification) {
        guard let dict = notification.userInfo as NSDictionary?, let newLike = dict["object"] as? Like else {
            return
        }

        if self.postLikes.contains(newLike) || newLike.parent != self {
            return
        }

        self.postLikes.append(newLike)
        if newLike.owner == NBClient.shared.getCurrentUser() {
            self.likedByCurrentUser = true
            self.likeFromCurrentUser = newLike
        }
    }

    @objc func beginUpdatingAttachment(_ notification: NSNotification) {
        guard let dict = notification.userInfo as NSDictionary?, let newAttachment = dict["object"] as? Attachment else {
            return
        }
        if newAttachment.parent != self {
            return
        }

        if newAttachment.mimeType == .image, !self.attachments.contains(newAttachment) {
            self.attachments.append(newAttachment)
        } else if newAttachment.attachmentScheme == .External, !self.externalAttachments.contains(newAttachment) {
            self.externalAttachments.append(newAttachment)
        }
    }

    @objc func beginDeletingComment(_ notification: NSNotification) {
        guard let dict = notification.userInfo as NSDictionary?, let deletedComment = dict["object"] as? Comment else {
            return
        }

        if deletedComment.isCommentReply || deletedComment.parent != self {
            return
        }

        if self.comments.contains(deletedComment) {
            self.comments.removeAll(deletedComment)
        }
    }

    @objc func beginDeletingLike(_ notification: NSNotification) {
        guard let dict = notification.userInfo as NSDictionary?, let deletedLike = dict["object"] as? Like else {
            return
        }
        if deletedLike.parent != self {
            return
        }

        if self.postLikes.contains(deletedLike) {
            self.postLikes.removeAll(deletedLike)
            if deletedLike.owner == NBClient.shared.getCurrentUser() {
                self.likedByCurrentUser = false
                self.likeFromCurrentUser = nil
            }
        }
    }

    @objc func beginDeletingAttachment(_ notification: NSNotification) {
        guard let dict = notification.userInfo as NSDictionary?, let deletedAttachment = dict["object"] as? Attachment else {
            return
        }
        if deletedAttachment.parent != self {
            return
        }

        if self.attachments.contains(deletedAttachment) {
            self.attachments.removeAll(deletedAttachment)
        } else if self.externalAttachments.contains(deletedAttachment) {
            self.externalAttachments.removeAll(deletedAttachment)
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
        postLikes = Like.getCache().filter({ $0.parent == self })

        if postLikes.isEmpty {
            likedByCurrentUser = false
            likeFromCurrentUser = nil
        } else if let like = postLikes.first(where: { $0.owner == NBClient.shared.getCurrentUser() }) {
            likedByCurrentUser = true
            likeFromCurrentUser = like
        }
    }

    func refreshCachedCommentsAttachments() {
        self.comments = Comment.getCache().filter({ $0.parent == self })
        self.attachments = Attachment.getCache().filter({ $0.parent == self && $0.mimeType == .image })
        self.externalAttachments = Attachment.getCache().filter({ $0.parent == self && $0.attachmentScheme == .External })
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
        NotificationCenter.default.addObserver(self, selector: #selector(beginUpdatingComment(_:)), name: NSNotification.Name("ModelDidBeginUpdatingComment"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(beginUpdatingLike(_:)), name: NSNotification.Name("ModelDidBeginUpdatingLike"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(beginUpdatingAttachment(_:)), name: NSNotification.Name("ModelDidBeginUpdatingAttachment"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(beginDeletingComment(_:)), name: NSNotification.Name("ModelDidBeginDeletingComment"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(beginDeletingLike(_:)), name: NSNotification.Name("ModelDidBeginDeletingLike"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(beginDeletingAttachment(_:)), name: NSNotification.Name("ModelDidBeginDeletingAttachment"), object: nil)
    }

    @objc func beginUpdatingComment(_ notification: NSNotification) {
        guard let dict = notification.userInfo as NSDictionary?, let newComment = dict["object"] as? Comment else {
            return
        }

        if newComment == self, newComment.updatedAt > self.updatedAt {
            self.text = newComment.text
            self.editedAt = newComment.editedAt
            self.updatedAt = newComment.updatedAt
        } else if newComment.parent == self, !self.comments.contains(newComment) {
            self.comments.append(newComment)
        }
    }

    @objc func beginUpdatingLike(_ notification: NSNotification) {
        guard let dict = notification.userInfo as NSDictionary?, let newLike = dict["object"] as? Like else {
            return
        }

        if self.commentLikes.contains(newLike) || newLike.parent != self {
            return
        }

        self.commentLikes.append(newLike)
        if newLike.owner == NBClient.shared.getCurrentUser() {
            self.likedByCurrentUser = true
            self.likeFromCurrentUser = newLike
        }
    }

    @objc func beginUpdatingAttachment(_ notification: NSNotification) {
        guard let dict = notification.userInfo as NSDictionary?, let newAttachment = dict["object"] as? Attachment else {
            return
        }
        if newAttachment.parent != self {
            return
        }

        if newAttachment.mimeType == .image, !self.attachments.contains(newAttachment) {
            self.attachments.append(newAttachment)
        } else if newAttachment.attachmentScheme == .External, !self.externalAttachments.contains(newAttachment) {
            self.externalAttachments.append(newAttachment)
        }
    }

    @objc func beginDeletingComment(_ notification: NSNotification) {
        guard let dict = notification.userInfo as NSDictionary?, let deletedComment = dict["object"] as? Comment else {
            return
        }
        if deletedComment.parent != self {
            return
        }

        if self.comments.contains(deletedComment) {
            self.comments.removeAll(deletedComment)
        }
    }

    @objc func beginDeletingLike(_ notification: NSNotification) {
        guard let dict = notification.userInfo as NSDictionary?, let deletedLike = dict["object"] as? Like else {
            return
        }
        if deletedLike.parent != self {
            return
        }

        if self.commentLikes.contains(deletedLike) {
            self.commentLikes.removeAll(deletedLike)
            if deletedLike.owner == NBClient.shared.getCurrentUser() {
                self.likedByCurrentUser = false
                self.likeFromCurrentUser = nil
            }
        }
    }

    @objc func beginDeletingAttachment(_ notification: NSNotification) {
        guard let dict = notification.userInfo as NSDictionary?, let deletedAttachment = dict["object"] as? Attachment else {
            return
        }
        if deletedAttachment.parent != self {
            return
        }

        if self.attachments.contains(deletedAttachment) {
            self.attachments.removeAll(deletedAttachment)
        } else if self.externalAttachments.contains(deletedAttachment) {
            self.externalAttachments.removeAll(deletedAttachment)
        }
    }

    public func refreshCachedAttachments() {
        self.comments = Comment.getCache().filter({ $0.parent == self })
        self.attachments = Attachment.getCache().filter({ $0.parent == self && $0.mimeType == .image })
        self.externalAttachments = Attachment.getCache().filter({ $0.parent == self && $0.attachmentScheme == .External })
    }

    public func refreshCachedLikes() {
        commentLikes = Like.getCache().filter({ $0.parent == self })

        if commentLikes.isEmpty {
            likedByCurrentUser = false
            likeFromCurrentUser = nil
        } else if let like = commentLikes.first(where: { $0.owner == NBClient.shared.getCurrentUser() }) {
            likedByCurrentUser = true
            likeFromCurrentUser = like
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

        setupObservers()
    }

    func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(beginUpdatingNotification(_:)), name: NSNotification.Name("ModelDidBeginUpdatingNotification"), object: nil)
    }

    @objc func beginUpdatingNotification(_ notification: NSNotification) {
        guard let dict = notification.userInfo as NSDictionary?, let newNotification = dict["object"] as? Notification, newNotification == self else {
            return
        }

        if newNotification.updatedAt > self.updatedAt {
            self.status = newNotification.status
            self.text = newNotification.text
            self.type = newNotification.type
            self.updatedAt = newNotification.updatedAt
        }
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

    public func findSetting() {
        userSetting = Setting.getCache().first(where: { $0.key == self.key })
    }

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

