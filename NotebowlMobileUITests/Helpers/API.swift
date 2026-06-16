//
//  API.swift
//  NotebowlMobileUITests
//
//  Created by Conner Owen on 8/29/18.
//  Copyright © 2018 Notebowl. All rights reserved.
//

import Foundation
import XCTest
import HTTPStatusCodes

class API {
    static var baseUrl = Environment.Local.rawValue

    required init() { }

    static func getFirst(_ objectType: String, user: String = "alexs@notebowl.com", mostRecent: Bool = false, filterByCurrentUser: Bool = false) -> String {
        var params = ["token": "\(user)", "limit": "1"]
        if mostRecent { (params["sortBy"] = "updatedAt:desc") }
        if filterByCurrentUser {
            let userUrl = getFirst("credentials")
            (params["filters"] = "[\"user:IN:\(userUrl)\"]")
        }
        let reqUrl = URL(string: ("https://\(baseUrl)/api/v1.0/\(objectType)"))!.appendingQueryParameters(params)
        var request = URLRequest(url: reqUrl)
        request.httpMethod = "GET"
        return makeDataTaskRequest(withRequest: request)
    }

    static func deleteExisting(_ objectUrl: String) {
        let delUrl = URL(string: ("\(objectUrl)"))!.appendToken(user: "admin@notebowl.com")
        var request = URLRequest(url: delUrl)
        request.httpMethod = "DELETE"
        makeDataTaskRequest(withRequest: request)
        return
    }

    static func updateExisting(_ objectUrl: String, payload: Any) {
        let putUrl = URL(string: ("\(objectUrl)"))!.appendToken(user: "bob.smith@notebowl.com")
        var request = URLRequest(url: putUrl)
        request.addHeadersJSON()
        request.addPayload(payload: payload)
        request.httpMethod = "PUT"
        makeDataTaskRequest(withRequest: request)
        return
    }

    static func createNew(_ objectType: String, parent: String! = "", owner: String! = "", related: String! = "", payload: Any? = nil, user: String = "alexs@notebowl.com") -> String {
        let jsonPayload: Any =  (payload != nil ? payload! : ["text": Lorem.sentences(2), "owner": "\(owner!)", "parent": "\(parent!)", "related": "\(related!)", "isAnonymous": false, "availableDate": true])
        let reqUrl = URL(string: ("https://\(baseUrl)/api/v1.0/\(objectType)"))!.appendToken(user: user)
        var request = URLRequest(url: reqUrl)
        request.addHeadersJSON()
        request.addPayload(payload: jsonPayload)
        request.httpMethod = "POST"
        return makeDataTaskRequest(withRequest: request)
    }

    static func makeDataTaskRequest(withRequest: URLRequest) -> String {
        var responseUrl: String!
        let semaphore = DispatchSemaphore(value: 0)
        let task = URLSession.shared.dataTask(with: withRequest) { (data, response, error) in
            let json: Any = data.flatMap { try! JSONSerialization.jsonObject(with: $0, options: .mutableContainers) }!
            let keyPath = (json as AnyObject).value(forKeyPath: "result")!

            if let keyPaths = keyPath as? [[String: Any]] {
                responseUrl = ( keyPaths.first!["url"] as! String)
            } else if let keyPaths = keyPath as? [String: Any] {
                responseUrl = ( keyPaths["url"] as! String)
            }
            semaphore.signal()
        }
        task.resume()
        let timeout = DispatchTime.distantFuture
        _ = semaphore.wait(timeout: timeout)
        return responseUrl
    }

    static func createPostFromUser(user: String = "alexs@notebowl.com", discussionBoardPost: Bool = false) {
        let courseUrl = getFirst("courses")
        if discussionBoardPost {
            let assignmentUrl = getFirst("assignments")
            _ = createNew("posts", parent: assignmentUrl, owner: courseUrl, related: assignmentUrl, user: user)
        } else if !discussionBoardPost {
            _ = createNew("posts", parent: courseUrl, owner: courseUrl, related: courseUrl, user: user)
        }
    }

    static func createCommentForPost(user: String = "alexs@notebowl.com", discussionBoardComment: Bool = false) {
        let postUrl = getFirst("posts")
        let courseUrl = getFirst("courses")
        if discussionBoardComment {
            let assignmentUrl = getFirst("assignments")
            _ = API.createNew("comments", parent: postUrl, owner: courseUrl, related: assignmentUrl, user: user)
        } else if !discussionBoardComment {
            _ = API.createNew("comments", parent: postUrl, owner: courseUrl, related: courseUrl, user: user)
        }
    }

    static func createCommentReply(user: String = "alexs@notebowl.com") {
        let postUrl = getFirst("posts")
        let commentUrl = getFirst("comments")
        let courseUrl = getFirst("courses")
        _ = API.createNew("comments", parent: commentUrl, owner: postUrl, related: courseUrl, user: user)
    }

    static func createCourse(currentUserAsTA: Bool = false) {
        let uniUrl = getFirst("universities")
        let payload: Any = ["name": "Test Course", "subject": "SOCK", "number": "101", "units": 3, "usesWeightedGrades": false, "published": true, "university": "\(uniUrl)"]
        let courseUrl = createNew("courses", payload: payload, user: "admin@notebowl.com")

        let profUserUrl = getFirst("credentials", user: "bob.smith@notebowl.com")
        let profEnrollPayload: Any = ["role": "Professor", "status": "Accepted", "user": "\(profUserUrl)", "parent": "\(courseUrl)"]
        _ = createNew("enrollments", payload: profEnrollPayload, user: "admin@notebowl.com")

        let userUrl = getFirst("credentials")
        if currentUserAsTA {
            let enrollPayload: Any = ["role": "TA", "status": "Accepted", "user": "\(userUrl)", "parent": "\(courseUrl)"]
            _ = createNew("enrollments", payload: enrollPayload, user: "admin@notebowl.com")
        } else if !currentUserAsTA {
            let enrollPayload: Any = ["role": "Student", "status": "Accepted", "user": "\(userUrl)", "parent": "\(courseUrl)"]
            _ = createNew("enrollments", payload: enrollPayload, user: "admin@notebowl.com")
        }
    }

    static func deleteEnrollment() {
        let enrollUrl = getFirst("enrollments", filterByCurrentUser: true)
        deleteExisting(enrollUrl)
    }

    static func createBasicAssignment() {
        let courseUrl = getFirst("courses", mostRecent: true)
        let catUrl = getFirst("categories", mostRecent: true)
        let payload: Any = ["title": "Test Assignment", "points": 60, "gradeOnly": false, "description": "\(Lorem.sentences(2))", "submissionScheme": "No Submission", "lateSubmissionPermitted": false, "availableDate": "2018-07-13T07:04:23+0000", "dueDate": "2018-12-13T07:04:23+0000", "category": "\(catUrl)", "parent": "\(courseUrl)"]
        _ = createNew("assignments", payload: payload, user: "bob.smith@notebowl.com")
    }

    static func createFileSubmissionAssignment() {
        let courseUrl = getFirst("courses", mostRecent: true)
        let catUrl = getFirst("categories", mostRecent: true)
        let payload: Any = ["title": "File Submission Assignment", "points": 80, "gradeOnly": false, "description": "\(Lorem.sentences(2))", "submissionScheme": "File Submission", "lateSubmissionPermitted": false, "availableDate": "2018-07-13T07:04:23+0000", "dueDate": "2018-12-13T07:04:23+0000", "category": "\(catUrl)", "parent": "\(courseUrl)"]
        _ = createNew("assignments", payload: payload, user: "bob.smith@notebowl.com")
    }

    static func createDiscussionBoardAssignment(minComments: Int = 0, minPosts: Int = 0, wordCount: Int = 0, wordCountRequired: String = "Recommended") {
        let courseUrl = getFirst("courses", mostRecent: true)
        let catUrl = getFirst("categories", mostRecent: true)
        let payload: Any = ["title": "Discussion Board Assignment", "type": "Individual", "points": 50, "gradeOnly": false, "gradeScheme": "Percentage", "description": "\(Lorem.sentences(2))", "submissionScheme": "Discussion Board", "minNumComments": minComments, "minNumPosts": minPosts, "wordCountComments": wordCount, "wordCountPosts": wordCount, "commentsRequired": "\(wordCountRequired)", "postsRequired": "\(wordCountRequired)", "lateSubmissionPermitted": false, "availableDate": "2018-07-13T07:04:23+0000", "dueDate": "2018-12-13T07:04:23+0000", "category": "\(catUrl)", "parent": "\(courseUrl)"]
        _ = createNew("assignments", payload: payload, user: "bob.smith@notebowl.com")
    }

    static func createGrade() {
        let assignUrl = getFirst("assignments")
        let studentUserUrl = getFirst("credentials", user: "alexs@notebowl.com")
        let payload: Any = ["grade": 60, "parent": "\(assignUrl)", "owner": "\(assignUrl)", "related": "\(studentUserUrl)"]
        _ = createNew("grades", payload: payload, user: "bob.smith@notebowl.com")
    }

    static func updateGrade() {
        let gradeUrl = getFirst("grades")
        let payload: Any = ["grade": 65]
        updateExisting(gradeUrl, payload: payload)
    }

    static func deleteGrade() {
        let gradeUrl = getFirst("grades")
        deleteExisting(gradeUrl)
    }

    static func deleteAssignment() {
        let assignUrl = getFirst("assignments")
        deleteExisting(assignUrl)
    }
}

extension URL {
    public func appendingQueryParameters(_ parameters: [String: String]) -> URL {
        var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true)!
        var items = urlComponents.queryItems ?? []
        items += parameters.map({ URLQueryItem(name: $0, value: $1) })
        urlComponents.queryItems = items
        return urlComponents.url!
    }
    public mutating func appendQueryParameters(_ parameters: [String: String]) {
        self = appendingQueryParameters(parameters)
    }
    public func appendToken(user: String) -> URL {
        let params = ["token": user]
        return self.appendingQueryParameters(params)
    }
}

extension URLRequest {
    public mutating func addHeadersJSON() {
        var headers: [String: String] = [:]
        headers["content-type"] = "application/json"
        for (k, v) in headers {
            self.addValue(v, forHTTPHeaderField: k)
        }
    }
    public mutating func addPayload(payload: Any) {
        let body: Data? = try? JSONSerialization.data(withJSONObject: payload,
                                                      options: .prettyPrinted)
        self.httpBody = body
    }
}
