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

    var homeTab: XCUIElement { return app.tabBars.buttons["Home"] }
    var courseTab: XCUIElement { return app.tabBars.buttons["Courses"] }
    var notificationTab: XCUIElement { return app.tabBars.buttons["Notifications"] }
    var badgeValue: String { return notificationTab.value as! String }

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.launch()
        doUserLogin()
        waitForLoadingViewToDisappear()
    }

    override func tearDown() { super.tearDown() }

    func doUserLogin() {
        checkForExistence(app.otherElements["main"], timeout: 10.0)
        app.otherElements["main"].textFields["Email"].tap()
        app.otherElements["main"].textFields["Email"].typeText("alexs@notebowl.com")
        app.otherElements["main"].buttons["Next"].tap()
        waitForCondition(element: app.otherElements["main"].secureTextFields["Password"], predicate: NSPredicate(format: "exists == true"), timeout: 3.0)
        app.otherElements["main"].secureTextFields["Password"].tap()
        app.otherElements["main"].secureTextFields["Password"].typeText("notebowlbeta")
        app.otherElements["main"].buttons["Sign In"].tap()
    }
}

extension XCTestCase {
    func checkForExistence(_ element: XCUIElement, timeout: TimeInterval = 5.0, shouldExist: Bool = true) {
        shouldExist ? waitForCondition(element: element, predicate: NSPredicate(format: "exists == true"), timeout: timeout) : waitForCondition(element: element, predicate: NSPredicate(format: "exists == false"), timeout: timeout)
    }
    func waitForCondition(element: XCUIElement, predicate: NSPredicate, timeout: TimeInterval = 3.0) {
        expectation(for: predicate, evaluatedWith: element, handler: nil)
        waitForExpectations(timeout: timeout, handler: nil)
    }
    func checkIsElementVisible(element: XCUIElement, shouldBeVisible: Bool = true) {
        let window = XCUIApplication().windows.element(boundBy: 0)
        shouldBeVisible ? XCTAssert(window.frame.contains(element.frame)) : XCTAssertFalse(window.frame.contains(element.frame))
    }
    func isHUDVisible() { checkIsElementVisible(element: XCUIApplication().otherElements["PKHUD"]) }

    func waitForLoadingViewToDisappear() { checkForExistence(XCUIApplication().otherElements["loadingView"], timeout: 30.0, shouldExist: false) }
    func waitForLoadingViewToAppear() { checkForExistence(XCUIApplication().otherElements["loadingView"], timeout: 10.0) }
    func waitForHUDToDisappear() { checkForExistence(XCUIApplication().otherElements["PKHUD"], timeout: 5.5, shouldExist: false) }
}
