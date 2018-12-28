//
//  Courses.swift
//  NotebowlMobileUITests
//
//  Created by Conner Owen on 9/4/18.
//  Copyright © 2018 Notebowl. All rights reserved.
//

import Foundation
import XCTest

func setupCourses(_ app: XCUIApplication, testCase: NBUITests) {
    Courses.setup(app, testCase: testCase)
}

class Courses: XCTestHelpers {
    static var app: XCUIApplication!
    static var currentTestCase: NBUITests!

    class func setup(_ app: XCUIApplication, testCase: NBUITests) {
        Courses.app = app
        Courses.currentTestCase = testCase
    }

    class func waitUntilCourseExists(atIndex index: Int) -> CourseObject {
        let course = CourseObject(index: index)
        waitForElementToExist(course.element)
        return course
    }
    class func waitUntilAssignmentExists(atIndex index: Int) -> AssignmentObject {
        let assignment = AssignmentObject(index: index)
        waitForElementToExist(assignment.element)
        return assignment
    }

    class func assertCourseTitles(titles: [String]) {
        for title in titles {
            XCTAssert(app.tables.cells.staticTexts[title].exists)
        }
    }
}
extension XCUIApplication {
    var deletedCourse: XCUIElement { return self.tables["courseTableView"].cells.staticTexts["Honors English"] }
    var newCourse: XCUIElement { return self.tables["courseTableView"].cells.staticTexts["Test Course"] }
    func navigateToCourses() {
        XCTestHelpers.waitForElementToExist(self.tabBars.buttons["Courses"])
        self.tabBars.buttons["Courses"].tap() }

    var newAssignment: XCUIElement { return self.tables["courseAssignmentsTableView"].cells.staticTexts["Test Assignment"] }
    var newDiscussionBoardAssignment: XCUIElement { return self.tables["courseAssignmentsTableView"].cells.staticTexts["Discussion Board Assignment"] }
    var newFileSubmissionAssignment: XCUIElement { return self.tables["courseAssignmentsTableView"].cells.staticTexts["File Submission Assignment"] }
}

class CourseObject: NSObject {
    var app: XCUIApplication!
    var indexForCourse: Int!
    var element: XCUIElement { return XCUIApplication().tables.children(matching: .cell).element(boundBy: indexForCourse) }

    var courseTitle: XCUIElement { return element.staticTexts["courseTitle"] }
    var courseNumber: XCUIElement { return element.staticTexts["courseNumber"] }
    var courseLastUpdated: XCUIElement { return element.staticTexts["courseLastUpdated"] }

    required init(index: Int) {
        app = XCUIApplication()
        indexForCourse = index
    }

    convenience override init() {
        self.init(index: 0)
    }

    func navigateToDetailView() {
        courseTitle.tap()
    }

    func assertSelf() {
        XCTAssertEqual(courseTitle.label, "Test Course")
        XCTestHelpers.assertCourseCount(count: 3)
    }
}

class AssignmentObject: NSObject {
    var app: XCUIApplication!
    var indexForAssignment: Int!
    var element: XCUIElement { return XCUIApplication().tables.children(matching: .cell).element(boundBy: indexForAssignment) }

    var assignmentName: XCUIElement { return element.staticTexts["assignmentName"] }
    var assignmentCategory: XCUIElement { return element.staticTexts["assignmentCategory"] }
    var statusText: XCUIElement { return element.staticTexts["statusText"] }
    var dueDateNumber: XCUIElement { return element.staticTexts["dueDateNumber"] }
    var dueDateText: XCUIElement { return element.staticTexts["dueDateText"] }
    var totalPointsNumber: XCUIElement { return element.staticTexts["totalPointsNumber"] }
    var userGrade: XCUIElement { return element.staticTexts["userGrade"] }

    func assertCreatedGrade() { XCTestHelpers.waitForCondition(element: userGrade, predicate: NSPredicate(format: "label like %@", "60"), timeout: 5.0) }
    func assertUpdatedGrade() { XCTestHelpers.waitForCondition(element: userGrade, predicate: NSPredicate(format: "label like %@", "65"), timeout: 5.0) }

    required init(index: Int) {
        app = XCUIApplication()
        indexForAssignment = index
    }

    convenience override init() {
        self.init(index: 0)
    }

    func assertSelf(title: String) {
        XCTAssertEqual(assignmentName.label, "\(title)")
        XCTestHelpers.assertCourseCount(count: 1)
    }

    func assertStatusChange(expected: String) {
        XCTAssertEqual(statusText.label, "\(expected)")
    }

    func assertDeletedGrade() {
        XCTAssertFalse(userGrade.exists)
    }
}
