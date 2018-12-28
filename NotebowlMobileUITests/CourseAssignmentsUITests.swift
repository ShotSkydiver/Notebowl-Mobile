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
        newCourse.assertSelf()
        newCourse.navigateToDetailView()
    }
    override func tearDown() { super.tearDown() }

    func testCreateNewAssignment() {
        API.createBasicAssignment()
        let newAssignment = Courses.waitUntilAssignmentExists(atIndex: 0)
        newAssignment.assertSelf(title: "Test Assignment")
    }
    func testCreateFileSubAssignment() {
        API.createFileSubmissionAssignment()
        let newAssignment = Courses.waitUntilAssignmentExists(atIndex: 0)
        newAssignment.assertSelf(title: "File Submission Assignment")
    }

    func testCreateDiscussionBoardAssignmentNoReqs() {
        API.createDiscussionBoardAssignment()
        let newAssignment = Courses.waitUntilAssignmentExists(atIndex: 0)
        newAssignment.assertSelf(title: "Discussion Board Assignment")
    }
    func testCreateDiscussionBoardAssignmentMinPost() {
        API.createDiscussionBoardAssignment(minPosts: 2)
        let newAssignment = Courses.waitUntilAssignmentExists(atIndex: 0)
        newAssignment.assertSelf(title: "Discussion Board Assignment")
    }
    func testCreateNewDiscussionPost() {
        testCreateDiscussionBoardAssignmentNoReqs()
        API.createPostFromUser(discussionBoardPost: true)
        let existingAssignment = Courses.waitUntilAssignmentExists(atIndex: 0)
        existingAssignment.assertStatusChange(expected: "Submitted")
    }
    func testCreateNewDiscussionPostWithMin() {
        testCreateDiscussionBoardAssignmentMinPost()
        API.createPostFromUser(discussionBoardPost: true)
        let existingAssignment = Courses.waitUntilAssignmentExists(atIndex: 0)
        existingAssignment.assertStatusChange(expected: "In Progress")
    }

    func testDeleteAssignment() {
        testCreateNewAssignment()
        API.deleteAssignment()
    }

    func testNewGrade() {
        testCreateNewAssignment()
        let newAssignment = Courses.waitUntilAssignmentExists(atIndex: 0)
        API.createGrade()
        newAssignment.assertCreatedGrade()
    }

    func testDeleteGrade() {
        testNewGrade()
        let newAssignment = Courses.waitUntilAssignmentExists(atIndex: 0)
        API.deleteGrade()
        newAssignment.assertDeletedGrade()
    }

    func testUpdateGrade() {
        testNewGrade()
        let newAssignment = Courses.waitUntilAssignmentExists(atIndex: 0)
        API.updateGrade()
        newAssignment.assertUpdatedGrade()
    }
}
