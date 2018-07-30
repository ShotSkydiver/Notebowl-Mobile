//
//  CommentUITests.swift
//  NotebowlMobileUITests
//
//  Created by Conner Owen on 7/24/18.
//  Copyright © 2018 Notebowl. All rights reserved.
//

import XCTest
import UITestHelper

class CommentUITests: XCTestCase {

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        self.tryLaunch()
        self.waitForLoadingViewToDisappear()
        let cell = app.tables["bulletinTableView"].children(matching: .cell).element(boundBy: 1)
        let postDate = cell.staticTexts["postDateLabel"].label
        postDate.tap()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCreateComment() {
        app.textViews.containing(.staticText, identifier:"Write a comment...").element.tap()
        app.textViews.element(boundBy: 0).typeText("UI Test Comment!")
        XCTAssertEqual(app.textViews.element(boundBy: 0).value as? String ?? "", "UI Test Comment!")
        app.buttons["commentSendButton"].tap()
        
        let tableView = app.tables["postDetailTableView"]
        let lastCell = tableView.children(matching: .cell).element(boundBy: (tableView.cells.count - 1))
        
        let postContent = lastCell.textViews["commentContent"].value as? String ?? ""
        XCTAssertEqual(postContent, "UI Test Comment!")
        
        let postedDate = lastCell.staticTexts["commentPostedDate"].label
        XCTAssertEqual(postedDate, "just now")
    }
    
    func testCreateAnonymousComment() {
        app.textViews.containing(.staticText, identifier:"Write a comment...").element.tap()
        app.textViews.element(boundBy: 0).typeText("Anonymous UI Test Comment!")
        XCTAssertEqual(app.textViews.element(boundBy: 0).value as? String ?? "", "Anonymous UI Test Comment!")
        
        app.buttons["commentAnonymousButton"].tap()
        
        app.buttons["commentSendButton"].tap()
        
        let tableView = app.tables["postDetailTableView"]
        let lastCell = tableView.children(matching: .cell).element(boundBy: (tableView.cells.count - 1))
        
        let postContent = lastCell.textViews["commentContent"].value as? String ?? ""
        XCTAssertEqual(postContent, "Anonymous UI Test Comment!")
        
        let postedDate = lastCell.staticTexts["commentPostedDate"].label
        XCTAssertEqual(postedDate, "just now")
        
        let userName = lastCell.staticTexts["commentUserName"].label
        XCTAssertEqual(userName, "Anonymous")
    }
    
    func testCreateCommentWithAttachments() {
        app.textViews.containing(.staticText, identifier:"Write a comment...").element.tap()
        app.textViews.element(boundBy: 0).typeText("UI Test Comment with Attachments!")
        XCTAssertEqual(app.textViews.element(boundBy: 0).value as? String ?? "", "UI Test Comment with Attachments!")
        
        app.buttons["commentPhotoLibraryButton"].tap()
        
        let elementsQuery = app.scrollViews.otherElements
        let collectionViewsQuery = elementsQuery.collectionViews
        collectionViewsQuery.children(matching: .cell).element(boundBy: 1).children(matching: .other).element.tap()
        elementsQuery.buttons["yp multiple"].tap()
        collectionViewsQuery.children(matching: .cell).element(boundBy: 2).children(matching: .other).element.tap()
        app.navigationBars["YPImagePicker.YPPickerVC"].buttons["Next"].tap()
        
        app.buttons["commentSendButton"].tap()
        
        let tableView = app.tables["postDetailTableView"]
        let lastCell = tableView.children(matching: .cell).element(boundBy: (tableView.cells.count - 1))
        
        let postContent = lastCell.textViews["commentContent"].value as? String ?? ""
        XCTAssertEqual(postContent, "UI Test Comment with Attachments!")
        
        let postedDate = lastCell.staticTexts["commentPostedDate"].label
        XCTAssertEqual(postedDate, "just now")
        
        let attachments = lastCell.children(matching: .staticText).matching(identifier: "attachmentCountLabel").allElementsBoundByIndex
        XCTAssert(attachments.count == 2)
    }
    
    func testLikeComment() {
        let commentCell = app.tables["postDetailTableView"].children(matching: .cell).element(boundBy: 1)
        let isLikedAlready = commentCell.children(matching: .button)["commentLikeButton"].isSelected
        var likeCountInt = 0
        commentCell.staticTexts["commentLikeCount"].ifExists { (commentLikeCount) in
            likeCountInt = Int(commentLikeCount.label)!
        }
        commentCell.children(matching: .button)["commentLikeButton"].tap()
 
        self.checkIsElementVisible(element: app.otherElements["PKHUD"])
        self.waitForHUDToDisappear()
        
        let commentCell2 = app.tables["postDetailTableView"].children(matching: .cell).element(boundBy: 1)
        if isLikedAlready {
            var likeCountInt2 = 0
            if commentCell2.staticTexts["commentLikeCount"].exists { likeCountInt2 = Int(commentCell2.staticTexts["commentLikeCount"].label)! }
            XCTAssert(likeCountInt > likeCountInt2)
        }
        else if !isLikedAlready {
            let likeCountInt2 = Int(commentCell2.staticTexts["commentLikeCount"].label)
            XCTAssert(likeCountInt2! > likeCountInt)
        }
    }
    
    func testDeleteComment() {
        let commentCellsCount = app.tables["postDetailTableView"].cells.count
        let commentCell = app.tables["postDetailTableView"].children(matching: .cell).element(boundBy: 1)
        commentCell.children(matching: .button)["commentMoreButton"].tap()
        commentCell.buttons["Delete"].tap()
        
        XCTAssert(app.tables["postDetailTableView"].cells.count < commentCellsCount)
    }
    
    func testReportComment() {
        let cells = app.tables["postDetailTableView"].children(matching: .cell).matching(identifier: "homeFeedCommentCell").allElementsBoundByIndex
        
        for cell in cells {
            cell.children(matching: .button)["commentMoreButton"].tap()
            if cell.buttons["Report"].exists {
                cell.buttons["Report"].tap()
                app.sheets["Report Comment"].buttons["It doesn't belong on Notebowl"].tap()
                self.checkIsElementVisible(element: app.otherElements["PKHUD"])
                break
            }
        }
    }
    
}
