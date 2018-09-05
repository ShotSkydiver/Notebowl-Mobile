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
    
    override func setUp() {
        setupBulletin(app, testCase: self)
        super.setUp()
    }
    override func tearDown() { super.tearDown() }
    
    func testCreateNewPost() {
        Bulletin.startCreatingNewPost()
        Bulletin.finishCreatingAndSubmit()
        let newPost = Bulletin.waitUntilPostExists(atIndex: 0)
        newPost.assertSelf()
    }
    
    func testCreateNewAnonymousPost() {
        Bulletin.startCreatingNewPost(asAnonymousUser: true)
        Bulletin.finishCreatingAndSubmit()
        let newPost = Bulletin.waitUntilPostExists(atIndex: 0)
        newPost.assertSelf(expectPostedAnonymously: true)
    }
 
    func testCreateNewPostWithAttachments() {
        Bulletin.startCreatingNewPost()
        Bulletin.addAttachmentsToNewPost()
        Bulletin.finishCreatingAndSubmit()
        let newPost = Bulletin.waitUntilPostExists(atIndex: 0)
        newPost.assertAttachmentsExist()
    }
    
    func testDeletePost() {
        API.createPostFromUser()
        let existingPost = Bulletin.waitUntilPostExists(atIndex: 0)
        existingPost.deleteSelf()
    }
    
    func testEditPostText() {
        API.createPostFromUser()
        let existingPost = Bulletin.waitUntilPostExists(atIndex: 0)
        existingPost.editText()
    }
    
    func testEditPostAddAttachments() {
        API.createPostFromUser()
        let existingPost = Bulletin.waitUntilPostExists(atIndex: 0)
        existingPost.addAttachments(editingExisting: true)
        Bulletin.finishCreatingAndSubmit()
        let modifiedPost = Bulletin.waitUntilPostExists(atIndex: 0)
        modifiedPost.assertAttachmentsExist()
    }
    
    func testLikeFirstPost() {
        API.createPostFromUser()
        let existingPost = Bulletin.waitUntilPostExists(atIndex: 0)
        existingPost.likeSelf()
    }
    
    func testReportPost() {
        API.createPostFromUser(user: "andrew.chaifetz@notebowl.com")
        let existingPost = Bulletin.waitUntilPostExists(atIndex: 0)
        existingPost.reportSelf()
    }
}
