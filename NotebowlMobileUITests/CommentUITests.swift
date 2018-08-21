//
//  CommentUITests.swift
//  NotebowlMobileUITests
//
//  Created by Conner Owen on 7/24/18.
//  Copyright © 2018 Notebowl. All rights reserved.
//

import XCTest

class CommentUITests: NBUITests {
    
    var textContentForPost: String!
    var parentPost: String!
    
    override func setUp() {
        super.setUp()
        textContentForPost = Lorem.sentences(1)
        parentPost = createPostFromUser(user: "admin@notebowl.com")
        firstPost.dateLabel.tap(force: true)
        
    }
    override func tearDown() { super.tearDown() }

    
    func createCommentForPost(user: String) {
        _ = createNew("comments", parent: parentPost, user: user)
        waitForCondition(element: firstComment, predicate: NSPredicate(format: "exists == true"), timeout: 5.0)
    }
    
    func createCommentWithText(content: String? = nil, attachments: Bool = false, anonymous: Bool = false) {
        inputTextView.staticTexts.element.tap(force: true)
        
        inputTextView.typeText((content == nil ? self.textContentForPost : content!))
        XCTAssertEqual((inputTextView.value as! String), (content == nil ? self.textContentForPost : content!))

        if attachments {
            handlePhotoLibraryPermissions()
            addAttachmentsToPost(withIndexes: [1,2])
        }
        if anonymous {
            app.buttons["anonymousButton"].tap()
        }
        postButton.tap()
    }
    
    func checkPosted(content: String? = nil, asAnonymous: Bool = false, withAttachments: Bool = false) {
        XCTAssertEqual((lastComment.textViews["postContent"].value as! String), (content == nil ? self.textContentForPost : content))
        XCTAssertEqual(lastComment.dateLabel.label, "just now")
        
        if asAnonymous { XCTAssertEqual(lastComment.userName.label, "Anonymous") }
        if withAttachments { XCTAssert(lastComment.attachments.count > 0) }
    }
    
    func testCreateComment() {
        createCommentWithText()
        checkPosted()
    }
    
    func testCreateAnonymousComment() {
        createCommentWithText(anonymous: true)
        checkPosted(asAnonymous: true)
    }
    
    func testCreateCommentWithAttachments() {
        createCommentWithText(attachments: true)
        checkPosted(withAttachments: true)
        
    }
    
    func testLikeComment() {
        createCommentForPost(user: "admin@notebowl.com")
        firstComment.likeButton.tap()
        isHUDVisible()
        waitForHUDToDisappear()
        XCTAssert(Int(firstComment.likeText.label)! > 0)
    }
    
    func testDeleteComment() {
        createCommentForPost(user: "admin@notebowl.com")
        let commentsCount = app.tables["postDetailTableView"].cells.count
        doPostAction(action: "Delete", forCell: firstComment)
        deleteCommentAction.tap()
        XCTAssertEqual(app.tables["postDetailTableView"].cells.count, commentsCount-1)
    }
    
    func testReportComment() {
        createCommentForPost(user: "bob.smith@notebowl.com")
        doPostAction(action: "Report", forCell: firstComment)
        reportAction.tap()
        isHUDVisible()
    }
    
}
