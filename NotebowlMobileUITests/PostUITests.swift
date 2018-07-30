//
//  PostUITests.swift
//  NotebowlMobileUITests
//
//  Created by Conner Owen on 7/24/18.
//  Copyright © 2018 Notebowl. All rights reserved.
//

import XCTest
import UITestHelper

class PostUITests: XCTestCase {

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        self.tryLaunch()
        self.waitForLoadingViewToDisappear()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    
    func createPostWithText(content: String, attachments: Bool, anonymous: Bool) {
        app.tables.textFields["createPostTextField"].tap()
        
        app.textViews["createPostText"].typeText(content)
        XCTAssertEqual(app.textViews["createPostText"].value as? String ?? "", content)
        
        app.buttons["coursePickerButton"].tap()
        // app.pickerWheels.element.adjust(toPickerWheelValue: "SQK 101: Squeaky Jibbs")
        app.buttons["Done"].tap()
        
        if attachments {
            self.handlePhotoPermissions()
            app.buttons["photoLibraryButton"].tap()
            app.tap()
            XCTAssert(app.navigationBars["YPImagePicker.YPPickerVC"].exists)
            
            let elementsQuery = app.scrollViews.otherElements
            let collectionViewsQuery = elementsQuery.collectionViews
            collectionViewsQuery.children(matching: .cell).element(boundBy: 1).children(matching: .other).element.tap()
            elementsQuery.buttons["yp multiple"].tap()
            collectionViewsQuery.children(matching: .cell).element(boundBy: 2).children(matching: .other).element.tap()
            app.navigationBars["YPImagePicker.YPPickerVC"].buttons["Next"].tap()
        }
        if anonymous {
            app.buttons["anonymousButton"].tap()
        }
        
        app.buttons["postButton"].tap()
    }
    
    
    
    
    
    func testCreateNewPost() {
        self.createPostWithText(content: "Post from automated UI unit test!", attachments: false, anonymous: false)
        
        let firstCell = app.tables["bulletinTableView"].children(matching: .cell).element(boundBy: 1)
        let postContent = firstCell.otherElements["postContent"].value as? String ?? ""
        XCTAssertEqual(postContent, "Post from automated UI unit test!")
    }
    
    func testCreateAnonymousPost() {
        self.createPostWithText(content: "Anonymous Post from automated UI unit test!", attachments: false, anonymous: true)
        
        let cell = app.tables["bulletinTableView"].children(matching: .cell).element(boundBy: 1)
        
        let postContent = cell.otherElements["postContent"].value as? String ?? ""
        XCTAssertEqual(postContent, "Anonymous Post from automated UI unit test!")
        
        let userName = cell.staticTexts["userNameLabel"].label
        XCTAssertEqual(userName, "Anonymous")
    }
    
    func testPostAndChangeCourse() {
        self.createPostWithText(content: "Course changed Post from automated UI unit test!", attachments: false, anonymous: false)
        
        let cell = app.tables["bulletinTableView"].children(matching: .cell).element(boundBy: 1)
        
        let postContent = cell.otherElements["postContent"].value as? String ?? ""
        XCTAssertEqual(postContent, "Course changed Post from automated UI unit test!")
        
        let postDate = cell.staticTexts["postDateLabel"].label
        XCTAssertEqual(postDate, "just now")
        
        let courseSelected = cell.staticTexts["courseLabel"].label
        XCTAssertEqual(courseSelected, "SQK 101: Squeaky Jibbs")
    }
    
    func testCreateNewPostWithAttachments() {
        self.createPostWithText(content: "Attachments Post from automated UI unit test!", attachments: true, anonymous: false)
        
        let firstCell = app.tables["bulletinTableView"].children(matching: .cell).element(boundBy: 1)
        
        let postContent = firstCell.otherElements["postContent"].value as? String ?? ""
        XCTAssertEqual(postContent, "Attachments Post from automated UI unit test!")
        
        let attachments = firstCell.children(matching: .staticText).matching(identifier: "attachmentCountLabel").allElementsBoundByIndex
        XCTAssert(attachments.count == 2)
    }
    
    func testDeletePost() {
        let cell = app.tables["bulletinTableView"].children(matching: .cell).element(boundBy: 1)
        cell.children(matching: .button)["moreButton"].tap()
        cell.buttons["Delete"].tap()
        
        XCTAssert(app.tables["bulletinTableView"].cells.count == 10)
    }
    
    func testEditPostText() {
        let cell = app.tables["bulletinTableView"].children(matching: .cell).element(boundBy: 1)
        cell.children(matching: .button)["moreButton"].tap()
        cell.buttons["Edit"].tap()
        
        app.textViews["createPostText"].typeText(" Post edited!")
        let textValue = app.textViews["createPostText"].value as? String ?? ""
        XCTAssert(textValue.contains(" Post edited!"))
        
        app.buttons["postButton"].tap()
        
        let cell2 = app.tables["bulletinTableView"].children(matching: .cell).element(boundBy: 1)
        
        let postContent = cell2.otherElements["postContent"].value as? String ?? ""
        XCTAssert(postContent.contains(" Post edited!"))
        
        let postDate = cell2.staticTexts["postDateLabel"].label
        XCTAssert(postDate.contains("edited"))
    }
    
    func testEditPostAddDeleteAttachments() {
        let cell = app.tables["bulletinTableView"].children(matching: .cell).element(boundBy: 1)
        let attachments = cell.children(matching: .staticText).matching(identifier: "attachmentCountLabel").allElementsBoundByIndex
        
        cell.children(matching: .button)["moreButton"].tap()
        cell.buttons["Edit"].tap()
        
        self.handlePhotoPermissions()
        app.buttons["photoLibraryButton"].tap()
        app.tap()
        XCTAssert(app.navigationBars["YPImagePicker.YPPickerVC"].exists)
        
        app.scrollViews.otherElements.collectionViews.children(matching: .cell).element(boundBy: 3).children(matching: .other).element.tap()
        app.navigationBars["YPImagePicker.YPPickerVC"].buttons["Next"].tap()
        
        app.buttons["postButton"].tap()
        
        let cell2 = app.tables["bulletinTableView"].children(matching: .cell).element(boundBy: 1)
        let attachments2 = cell2.children(matching: .staticText).matching(identifier: "attachmentCountLabel").allElementsBoundByIndex
        
        //XCTAssert(attachments2.count >= 3)
        XCTAssertGreaterThanOrEqual(attachments2.count, attachments.count)
    }
    
    func testLikeFirstPost() {
        let cell = app.tables["bulletinTableView"].children(matching: .cell).element(boundBy: 1)
        
        let isLikedAlready = cell.children(matching: .button)["postLikeButton"].isSelected
        var likeCountInt = 0
        cell.staticTexts["postLikeCount"].ifExists { (postLikeCount) in
            likeCountInt = Int(postLikeCount.label)!
        }
        cell.children(matching: .button)["postLikeButton"].tap()
        
        self.checkIsElementVisible(element: app.otherElements["PKHUD"])
        self.waitForHUDToDisappear()
        
        let cell2 = app.tables["bulletinTableView"].children(matching: .cell).element(boundBy: 1)
        if isLikedAlready {
            var likeCountInt2 = 0
            if cell2.staticTexts["postLikeCount"].exists { likeCountInt2 = Int(cell2.staticTexts["postLikeCount"].label)! }
            XCTAssert(likeCountInt > likeCountInt2)
        }
        else if !isLikedAlready {
            let likeCountInt2 = Int(cell2.staticTexts["postLikeCount"].label)
            XCTAssert(likeCountInt2! > likeCountInt)
        }
    }
    
    func testReportPost() {
        let cells = app.tables["bulletinTableView"].children(matching: .cell).matching(identifier: "homeFeedPostCell").allElementsBoundByIndex
        
        for cell in cells {
            cell.children(matching: .button)["moreButton"].tap()
            if cell.buttons["Report"].exists {
                cell.buttons["Report"].tap()
                app.sheets["Report Post"].buttons["It doesn't belong on Notebowl"].tap()
                self.checkIsElementVisible(element: app.otherElements["PKHUD"])
                break
            }
        }
    }
}
