//
//  PostUITests.swift
//  NotebowlMobileUITests
//
//  Created by Conner Owen on 7/24/18.
//  Copyright © 2018 Notebowl. All rights reserved.
//

import XCTest
import Foundation

class PostUITests: NBUITests {
    
    var textContentForPost: String!
    
    override func setUp() {
        super.setUp()
        textContentForPost = Lorem.sentences(2)
    }
    override func tearDown() { super.tearDown() }
    
    func createPostWithText(content: String? = nil, attachments: Bool = false, anonymous: Bool = false, changeCourse: Bool = false) {
        app.otherElements["bulletinTableViewHeader"].tap()
        app.textViews["createPostText"].typeText((content == nil ? self.textContentForPost : content!))
        XCTAssertEqual(app.textViews["createPostText"].value as? String ?? "", (content == nil ? self.textContentForPost : content!))
        
        if changeCourse {
            app.buttons["coursePickerButton"].tap()
            XCTAssertEqual(app.pickerWheels.element.value as! String, AvailableCourses.firstCourse.rawValue)
            app.pickerWheels.element.adjust(toPickerWheelValue: AvailableCourses.secondCourse.rawValue)
            app.buttons["Done"].tap()
        }
        if attachments {
            handlePhotoLibraryPermissions()
            addAttachmentsToPost(withIndexes: [1,2])
        }
        if anonymous {
            app.buttons["anonymousButton"].tap()
        }
        
        postButton.tap()
    }
    
    func checkPosted(content: String? = nil, asAnonymous: Bool = false, withAttachments: Bool = false, courseChanged: Bool = false, checkEdited: Bool = false) {
        let postContent = firstPost.otherElements["postContent"].value as? String ?? ""
        
        checkEdited ? XCTAssert(postContent.contains(" Post edited!")) : XCTAssertEqual(postContent, (content == nil ? self.textContentForPost : content))
        checkEdited ? XCTAssert(firstPost.dateLabel.label.contains("edited")) : XCTAssertEqual(firstPost.dateLabel.label, "just now")
        
        if asAnonymous { XCTAssertEqual(firstPost.userName.label, "Anonymous") }
        
        let attachments = firstPost.children(matching: .staticText).matching(identifier: "attachmentCountLabel").allElementsBoundByIndex
        if withAttachments { XCTAssert(attachments.count == 2) }
        
        if courseChanged { XCTAssertEqual(firstPost.courseLabel.label, AvailableCourses.secondCourse.rawValue) }
    }
    
    func testCreateBasicPost() {
        createPostWithText()
        checkPosted()
    }
    
    func testCreateAnonymousPost() {
        createPostWithText(anonymous: true)
        checkPosted(asAnonymous: true)
    }
    
    func testPostAndChangeCourse() {
        createPostWithText(changeCourse: true)
        checkPosted(courseChanged: true)
    }
    
    func testCreateNewPostWithAttachments() {
        createPostWithText(attachments: true)
        checkPosted(withAttachments: true)
    }
    
    func testDeletePost() {
        createPostFromUser(user: "admin@notebowl.com")
        let postsCount = app.tables["bulletinTableView"].cells.count
        doPostAction(action: "Delete")
        deletePostAction.tap()
        XCTAssertFalse(app.tables["bulletinTableView"].cells["homeFeedPostCell"].exists)
    }
    
    func testEditPostText() {
        createPostFromUser(user: "admin@notebowl.com")
        doPostAction(action: "Edit")
        addText(text: " Post edited!")
        postButton.tap()
        checkPosted(checkEdited: true)
    }
    
    func testEditPostAddAttachments() {
        createPostFromUser(user: "admin@notebowl.com")
        let attachmentsCount = firstPost.attachments.count
        doPostAction(action: "Edit")
        handlePhotoLibraryPermissions()
        addAttachmentsToPost(withIndexes: [3])
        postButton.tap()
        XCTAssertGreaterThan(firstPost.attachments.count, attachmentsCount)
    }
    
    func testLikeFirstPost() {
        createPostFromUser(user: "admin@notebowl.com")
        firstPost.likeButton.tap()
        isHUDVisible()
        waitForHUDToDisappear()
        XCTAssert(Int(firstPost.likeText.label)! > 0)
    }
    
    func testReportPost() {
        createPostFromUser(user: "bob.smith@notebowl.com")
        doPostAction(action: "Report")
        reportAction.tap()
        isHUDVisible()
    }
}

extension XCUIElement {
    var dateLabel: XCUIElement { return self.staticTexts["dateLabel"] }
    var userName: XCUIElement { return self.staticTexts["userNameLabel"] }
    var courseLabel: XCUIElement { return self.staticTexts["courseLabel"] }
    var likeButton: XCUIElement { return self.children(matching: .button)["likeButton"] }
    var likeText: XCUIElement { return self.staticTexts["likeCount"] }
    
    var attachments: [XCUIElement] { return self.children(matching: .staticText).matching(identifier: "attachmentCountLabel").allElementsBoundByIndex }
    
}
