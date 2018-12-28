//
//  CommentUITests.swift
//  NotebowlMobileUITests
//
//  Created by Conner Owen on 7/24/18.
//  Copyright © 2018 Notebowl. All rights reserved.
//

import XCTest

class CommentUITests: NBUITests {

    override func setUp() {
        super.setUp()
        setupBulletin(app, testCase: self)
        API.createPostFromUser()
        let parentPost = Bulletin.waitUntilPostExists(atIndex: 0)
        parentPost.navigateToDetailView()
    }
    override func tearDown() { super.tearDown() }


    func testCreateComment() {
        Bulletin.startCreatingNewComment()
        Bulletin.finishCreatingAndSubmit()
        let newComment = Bulletin.waitUntilCommentExists(atIndex: 1)
        newComment.assertSelf()
    }

    func testCreateCommentReply() {
        API.createCommentForPost()
        let newComment = Bulletin.waitUntilCommentExists(atIndex: 1)
        Bulletin.startCreatingNewComment()
        newComment.postReplyToSelf()
        Bulletin.finishCreatingAndSubmit()
        let newCommentReply = Bulletin.waitUntilCommentExists(atIndex: 2)
        newCommentReply.assertSelf()
    }

    func testCreateAnonymousComment() {
        Bulletin.startCreatingNewComment(asAnon: true)
        Bulletin.finishCreatingAndSubmit()
        let newComment = Bulletin.waitUntilCommentExists(atIndex: 1)
        newComment.assertSelf(expectPostedAnonymously: true)
    }

    func testCreateCommentWithAttachments() {
        Bulletin.startCreatingNewComment()
        Bulletin.addAttachmentsToNewComment()
        Bulletin.finishCreatingAndSubmit()
        let newComment = Bulletin.waitUntilCommentExists(atIndex: 1)
        newComment.assertSelf()
        newComment.assertAttachmentsExist()
    }

    func testLikeComment() {
        API.createCommentForPost()
        let newComment = Bulletin.waitUntilCommentExists(atIndex: 1)
        newComment.likeSelf()
    }

    func testDeleteComment() {
        API.createCommentForPost()
        let newComment = Bulletin.waitUntilCommentExists(atIndex: 1)
        newComment.deleteSelf()
    }

    func testDeleteSecondComment() {
        API.createCommentForPost()
        API.createCommentForPost()
        let newComment = Bulletin.waitUntilCommentExists(atIndex: 2)
        newComment.deleteSelf()
    }

    func testReportComment() {
        API.createCommentForPost(user: "andrew.chaifetz@notebowl.com")
        let newComment = Bulletin.waitUntilCommentExists(atIndex: 1)
        newComment.reportSelf()
    }
}
