//
//  NBUITests.swift
//  NotebowlMobileUITests
//
//  Created by Conner Owen on 7/30/18.
//  Copyright © 2018 Notebowl. All rights reserved.
//

import XCTest
import Foundation
import HTTPStatusCodes

class NBUITests: XCTestCase {
    
    let app =  XCUIApplication()
    let baseUrl = Environment.Local.rawValue
    
    var firstCourseUrl: String!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.launch()
        self.waitForLoadingViewToDisappear()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    var firstPost: XCUIElement { return app.tables["bulletinTableView"].children(matching: .cell).element(boundBy: 0) }
    var firstComment: XCUIElement { return app.tables["postDetailTableView"].children(matching: .cell).element(boundBy: 1) }
    var lastComment: XCUIElement { return app.tables["postDetailTableView"].children(matching: .cell).element(boundBy: (app.tables["postDetailTableView"].cells.count - 1)) }
    
    var inputTextView: XCUIElement { return app.textViews["newCommentTextView"] }
    var postButton: XCUIElement { return app.buttons["postButton"] }
    var reportAction: XCUIElement { return app.sheets.element.buttons["It doesn't belong on Notebowl"] }
    var deletePostAction: XCUIElement { return app.alerts["Delete Post"].buttons["Delete"] }
    var deleteCommentAction: XCUIElement { return app.alerts["Delete Comment"].buttons["Delete"] }
    
    func addText(text: String) { app.textViews["createPostText"].typeText(text) }
    
    
    func handlePhotoLibraryPermissions() {
        addUIInterruptionMonitor(withDescription: "Photos Dialog") { alert -> Bool in
            if alert.buttons["OK"].exists {
                alert.buttons["OK"].tap()
                return true
            }
            return false
        }
        app.buttons["photoLibraryButton"].tap()
        app.tap()
        XCTAssert(app.navigationBars["YPImagePicker.YPPickerVC"].exists)
    }
    
    func doPostAction(action: String, forCell: XCUIElement? = nil) {
        let cell = (forCell == nil ? firstPost : forCell!)
        cell.children(matching: .button)["moreButton"].tap()
        if cell.buttons[action].exists {
            cell.buttons[action].tap()
        }
    }
    
    func addAttachmentsToPost(withIndexes: [Int]) {
        let elementsQuery = app.scrollViews.otherElements
        let collectionViewsQuery = elementsQuery.collectionViews
        collectionViewsQuery.children(matching: .cell).element(boundBy: withIndexes.first!).children(matching: .other).element.tap()
        let newIndexes = withIndexes.dropFirst()
        if newIndexes.count >= 1 {
            elementsQuery.buttons["yp multiple"].tap()
            for index in newIndexes {
                collectionViewsQuery.children(matching: .cell).element(boundBy: index).children(matching: .other).element.tap()
            }
        }
        app.navigationBars["YPImagePicker.YPPickerVC"].buttons["Next"].tap()
        sleep(3)
    }

    func getFirst(_ objectType: String, user: String) -> String {
        let reqUrl = URL(string: ("https://\(baseUrl)/api/v1.0/\(objectType)"))!.appendingQueryParameters(["token": "\(user)", "limit": "1"])
        var request = URLRequest(url: reqUrl)
        request.httpMethod = "GET"
        
        return makeDataTaskRequest(withRequest: request)
    }
    
    func createNew(_ objectType: String, parent: String, user: String) -> String {
        var headers: [String: String] = [:]
        headers["content-type"] = "application/json"
        let jsonPayload: Any = ["text": Lorem.sentences(2), "_owner": "\(parent)", "_parent": "\(parent)", "_related": "\(parent)", "isAnonymous": false, "availableDate": true]
        let body: Data? = try? JSONSerialization.data(withJSONObject: jsonPayload,
                                           options: .prettyPrinted)
        
        let reqUrl = URL(string: ("https://\(baseUrl)/api/v1.0/\(objectType)"))!.appendToken(user: user)
        var request = URLRequest(url: reqUrl)
        for (k, v) in headers {
            request.addValue(v, forHTTPHeaderField: k)
        }
        request.httpBody = body
        request.httpMethod = "POST"
        
        return makeDataTaskRequest(withRequest: request)
    }
    
    func makeDataTaskRequest(withRequest: URLRequest) -> String {
        
        var responseUrl: String!
        let semaphore = DispatchSemaphore(value: 0)
        
        let task = URLSession.shared.dataTask(with: withRequest) { (data, response, error) in
            let json: Any = data.flatMap { try! JSONSerialization.jsonObject(with: $0, options: .mutableContainers) }!
            let keyPath = (json as AnyObject).value(forKeyPath: "result")!
            
            if let keyPaths = keyPath as? [[String: Any]] {
                responseUrl = ( keyPaths.first!["url"] as! String)
            }
            else if let keyPaths = keyPath as? [String: Any] {
                responseUrl = ( keyPaths["url"] as! String)
            }
        
            semaphore.signal()
            
        }
        task.resume()
        
        let timeout = DispatchTime.distantFuture
        _ = semaphore.wait(timeout: timeout)
        return responseUrl
    }
    
    
    func createPostFromUser(user: String) -> String {
        print("createpostfromuser")
        firstCourseUrl = getFirst("courses", user: user)
        let createdPost = createNew("posts", parent: firstCourseUrl, user: user)
        waitForCondition(element: firstPost, predicate: NSPredicate(format: "exists == true"), timeout: 5.0)
        return createdPost
    }
}

extension XCUIElement {
    func tap(force: Bool) {
        if isHittable {
            tap()
        } else if force {
            coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5)).tap()
        }
    }
}

extension XCTestCase {
    func waitForCondition(element: XCUIElement, predicate: NSPredicate, timeout: TimeInterval = 3.0) {
        expectation(for: predicate, evaluatedWith: element, handler: nil)
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func waitForLoadingViewToDisappear() {
        self.waitForCondition(element: XCUIApplication().otherElements["loadingView"], predicate: NSPredicate(format: "exists == false"), timeout: 30.0)
    }
    func waitForLoadingViewToAppear() {
        self.waitForCondition(element: XCUIApplication().otherElements["loadingView"], predicate: NSPredicate(format: "exists == true"), timeout: 10.0)
    }
    
    func waitForHUDToDisappear() {
        self.waitForCondition(element: XCUIApplication().otherElements["PKHUD"], predicate: NSPredicate(format: "exists == false"), timeout: 5.5)
    }
    func waitForHUDToAppear() {
        self.waitForCondition(element: XCUIApplication().otherElements["PKHUD"], predicate: NSPredicate(format: "exists == true"), timeout: 1.5)
    }
    
    func checkIsElementVisible(element: XCUIElement) {
        let window = XCUIApplication().windows.element(boundBy: 0)
        XCTAssert(window.frame.contains(element.frame))
    }
    func checkIsElementNotVisible(element: XCUIElement) {
        let window = XCUIApplication().windows.element(boundBy: 0)
        XCTAssertFalse(window.frame.contains(element.frame))
    }
    
    func isHUDVisible() {
        self.checkIsElementVisible(element: XCUIApplication().otherElements["PKHUD"])
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
        let params = ["token":user]
        return self.appendingQueryParameters(params)
    }
}
