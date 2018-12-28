//
//  CourseUITests.swift
//  NotebowlMobileUITests
//
//  Created by Conner Owen on 8/28/18.
//  Copyright © 2018 Notebowl. All rights reserved.
//

import XCTest

class CourseUITests: NBUITests {

    override func setUp() {
        setupCourses(app, testCase: self)
        super.setUp()
        app.navigateToCourses()
    }

    override func tearDown() { super.tearDown() }

    func testCreateNewCourse() {
        API.createCourse()
        let newCourse = Courses.waitUntilCourseExists(atIndex: 0)
        newCourse.assertSelf()
    }

    func testDeleteCourse() {
        API.deleteEnrollment()
        Courses.assertCourseTitles(titles: ["Electro Magnetic Physics"])
    }
}
