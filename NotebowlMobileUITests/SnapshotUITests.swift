//
//  SnapshotUITests.swift
//  NotebowlMobileUITests
//
//  Created by Conner Owen on 8/23/18.
//  Copyright © 2018 Notebowl. All rights reserved.
//

import XCTest
import SimulatorStatusMagic

class SnapshotUITests: NBUITests {

    override func setUp() {
        setupSnapshot(app)
        super.setUp()
        SDStatusBarManager.sharedInstance().enableOverrides()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testHomeFeedScreenshot() {
        snapshot("01HomeFeedView")
    }

    func testHomeFeedDetailScreenshot() {
        let table = app.tables["bulletinTableView"]
        let cell = table.cells["HomeFeedPostCell-0-1"]
        self.waitForCondition(element: cell.staticTexts["userNameLabel"], predicate: NSPredicate(format: "exists == true"), timeout: 20.0)
        cell.staticTexts["userNameLabel"].tap(force: true)
        snapshot("02HomeFeedDetailView")
    }

    func testUserSettingsScreenshot() {
        app.navigationBars["Profile Nav Controller"].buttons["Profile"].tap()
        snapshot("03UserSettingsView")
    }

    func testCoursesScreenshot() {
        app.tabBars.buttons["Courses"].tap()
        snapshot("04CoursesView")
    }

    func testAssignmentsScreenshot() {
        app.tabBars.buttons["Courses"].tap()
        app.tables.children(matching: .cell).element(boundBy: 0).tap()
        XCTestHelpers.waitForElementToDisappear(app.HUD)
        snapshot("05AssignmentsView")
    }

    func testNotificationsScreenshot() {
        app.tabBars.buttons["Notifications"].tap()
        snapshot("06NotificationsView")
    }
}


extension XCUIElement {
    func scrollToElement(element: XCUIElement) {
        while !element.visible() {
            swipeUp()
        }
    }

    func visible() -> Bool {
        guard self.exists && !self.frame.isEmpty else { return false }
        return XCUIApplication().windows.element(boundBy: 0).frame.contains(self.frame)
    }
}
