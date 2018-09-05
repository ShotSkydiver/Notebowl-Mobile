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
    
    class func waitUntilPlaceholderVisible() {
        XCTAssert(app.noAssignments.exists)
    }
    
    
    
}

extension XCUIApplication {
    var deletedCourse: XCUIElement { return self.tables.cells.staticTexts["Honors English"] }
    var newCourse: XCUIElement { return self.tables.cells.staticTexts["Test Course"] }
    func navigateToCourses() { self.tabBars.buttons["Courses"].tap() }
    
    var noAssignments: XCUIElement { return self.tables.staticTexts["This course has no assignments!"] }
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
        element.tap(force: true)
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
    var assignmentDescription: XCUIElement { return element.staticTexts["assignmentDescription"] }
    var assignmentTotalPoints: XCUIElement { return element.staticTexts["assignmentTotalPoints"] }
    var assignmentUserGrade: XCUIElement { return element.staticTexts["assignmentUserGrade"] }
    var assignmentStatus: XCUIElement { return element.staticTexts["assignmentStatus"] }
    var assignmentDueDate: XCUIElement { return element.staticTexts["assignmentDueDate"] }
    
    func assertCreatedGrade() { XCTestHelpers.waitForCondition(element: assignmentUserGrade, predicate: NSPredicate(format: "label like %@", "60"), timeout: 5.0) }
    func assertUpdatedGrade() { XCTestHelpers.waitForCondition(element: assignmentUserGrade, predicate: NSPredicate(format: "label like %@", "65"), timeout: 5.0) }
    
    required init(index: Int) {
        app = XCUIApplication()
        indexForAssignment = index
    }
    
    convenience override init() {
        self.init(index: 0)
    }
    
    func assertSelf() {
        XCTAssertFalse(app.noAssignments.exists)
    }
    
    func assertDeletedGrade() {
        XCTAssertFalse(assignmentUserGrade.exists)
    }
}
