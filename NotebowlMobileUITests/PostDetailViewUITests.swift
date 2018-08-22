//
//  PostDetailViewUITests.swift
//  NotebowlMobileUITests
//
//  Created by Conner Owen on 8/22/18.
//  Copyright © 2018 Notebowl. All rights reserved.
//

import XCTest

class PostDetailViewUITests: NBUITests {

    var parentPost: String!
    
    override func setUp() {
        super.setUp()
        textContentForPost = Lorem.sentences(1)
        parentPost = createPostFromUser(user: "admin@notebowl.com")
        firstPost.dateLabel.tap(force: true)
    }
    override func tearDown() { super.tearDown() }
    
    func testDeleteParentPost() {
        doPostAction(action: "Delete", forCell: postForDetailView)
        deletePostAction.tap()
        //isHUDVisible()
        //waitForHUDToDisappear()
        XCTAssertFalse(app.tables["bulletinTableView"].cells["homeFeedPostCell"].exists)
    }
    
    func testEditParentPostText() {
        doPostAction(action: "Edit", forCell: postForDetailView)
        addText(text: " Post edited!")
        postButton.tap()
        checkPost(checkEdited: true, postCell: postForDetailView)
    }
    
    func testEditParentPostAddAttachments() {
        let attachmentsCount = postForDetailView.attachments.count
        doPostAction(action: "Edit", forCell: postForDetailView)
        handlePhotoLibraryPermissions()
        addAttachmentsToPost(withIndexes: [3])
        postButton.tap()
        XCTAssertGreaterThan(postForDetailView.attachments.count, attachmentsCount)
    }
    
    func testLikeParentPost() {
        postForDetailView.likeButton.tap()
        isHUDVisible()
        waitForHUDToDisappear()
        XCTAssert(Int(postForDetailView.likeText.label)! == 1)
        XCTAssert(postForDetailView.likeButton.isSelected)
    }
    
    func testUnlikeParentPost() {
        testLikeParentPost()
        postForDetailView.likeButton.tap()
        isHUDVisible()
        waitForHUDToDisappear()
        XCTAssertFalse(postForDetailView.likeText.exists)
        XCTAssertFalse(postForDetailView.likeButton.isSelected)
    }
}
