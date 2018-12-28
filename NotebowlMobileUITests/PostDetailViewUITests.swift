//
//  PostDetailViewUITests.swift
//  NotebowlMobileUITests
//
//  Created by Conner Owen on 8/22/18.
//  Copyright © 2018 Notebowl. All rights reserved.
//

import XCTest

class PostDetailViewUITests: NBUITests {

    override func setUp() {
        super.setUp()
        setupBulletin(app, testCase: self)
        API.createPostFromUser()
        let parentPost = Bulletin.waitUntilPostExists(atIndex: 0)
        parentPost.navigateToDetailView()
    }

    override func tearDown() { super.tearDown() }

    func testDeleteParentPost() {
        let existingPost = Bulletin.waitUntilPostExists(atIndex: 0)
        existingPost.deleteSelf()
    }

    func testEditParentPostText() {
        let existingPost = Bulletin.waitUntilPostExists(atIndex: 0)
        existingPost.editText()
    }

    func testEditParentPostAddAttachments() {
        let existingPost = Bulletin.waitUntilPostExists(atIndex: 0)
        existingPost.addAttachments(editingExisting: true)
        Bulletin.finishCreatingAndSubmit()
        let modifiedPost = Bulletin.waitUntilPostExists(atIndex: 0)
        modifiedPost.assertAttachmentsExist()
    }

    func testLikeParentPost() {
        let existingPost = Bulletin.waitUntilPostExists(atIndex: 0)
        existingPost.likeSelf()
    }

    func testUnlikeParentPost() {
        let existingPost = Bulletin.waitUntilPostExists(atIndex: 0)
        existingPost.likeSelf()
        existingPost.unlikeSelf()
    }
}
