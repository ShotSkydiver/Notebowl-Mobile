//
//  CourseAssignmentsUITests.swift
//  NotebowlMobileUITests
//
//  Created by Conner Owen on 8/28/18.
//  Copyright © 2018 Notebowl. All rights reserved.
//

import XCTest

class CourseAssignmentsUITests: NBUITests {

    override func setUp() {
        setupCourses(app, testCase: self)
        super.setUp()
        app.navigateToCourses()
        API.createCourse()
        let newCourse = Courses.waitUntilCourseExists(atIndex: 0)
        newCourse.navigateToDetailView()
    }
    override func tearDown() { super.tearDown() }

    
    func testCreateNewAssignment() {
        API.createAssignment(title: Lorem.title)
        let newAssignment = Courses.waitUntilAssignmentExists(atIndex: 0)
        newAssignment.assertSelf()
    }

    func testDeleteAssignment() {
        testCreateNewAssignment()
        API.deleteAssignment()
        Courses.waitUntilPlaceholderVisible()
    }

    func testNewGrade() {
        API.createAssignment(title: Lorem.title)
        let newAssignment = Courses.waitUntilAssignmentExists(atIndex: 0)
        newAssignment.assertSelf()
        API.createGrade()
        newAssignment.assertCreatedGrade()
    }

    func testDeleteGrade() {
        API.createAssignment(title: Lorem.title)
        let newAssignment = Courses.waitUntilAssignmentExists(atIndex: 0)
        newAssignment.assertSelf()
        API.deleteGrade()
        newAssignment.assertDeletedGrade()
    }

    func testUpdateGrade() {
        API.createAssignment(title: Lorem.title)
        let newAssignment = Courses.waitUntilAssignmentExists(atIndex: 0)
        newAssignment.assertSelf()
        API.updateGrade()
        newAssignment.assertUpdatedGrade()
    }
}
