//
//  NotebowlMobileUITests.swift
//  NotebowlMobileUITests
//
//  Created by Conner Owen on 7/17/18.
//  Copyright © 2018 Notebowl. All rights reserved.
//

import XCTest

class NotebowlMobileUITests: XCTestCase {
        var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app = XCUIApplication()
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCreateNewPost() {

        let bulletinTableView = app.tables["bulletinTableView"]
 
        let postCell = bulletinTableView.cells["homeFeedPostCell"]
        postCell.waitForExistence(timeout: 40.0)
    
        app.tables.textFields["createPostTextField"].tap()
    
        app.textViews["createPostText"].tap()
        app.textViews["createPostText"].typeText("Post from automated UI unit test!")
        XCTAssertEqual(app.textViews["createPostText"].value as? String ?? "", "Post from automated UI unit test!")
        app.navigationBars["fakeNavBar"].buttons["Post"].tap()
        

        
        postCell.waitForExistence(timeout: 40.0)
        sleep(10)
    }
    
}
