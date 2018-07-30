//
//  MiscAppUITests.swift
//  NotebowlMobileUITests
//
//  Created by Conner Owen on 7/24/18.
//  Copyright © 2018 Notebowl. All rights reserved.
//

import XCTest
import UITestHelper


class MiscAppUITests: XCTestCase {

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        self.tryLaunch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    

    func testChangeSetting() {
        self.waitForLoadingViewToDisappear()
        app.navigationBars["Profile Nav Controller"].buttons["Profile"].tap()
        app.tables.element(boundBy: 0).cells["pushSettingsCell"].staticTexts["pushSettingsLabel"].tap()
        let cell = app.tables["pushTable"].cells["Comment on My Post"]
        let cellSwitch = cell.switches.element(boundBy: 0)
        let cellSwitchEnabled = cellSwitch.value as! String
        app.tables["pushTable"].cells["Comment on My Post"].switches.element(boundBy: 0).tap()
        
        let cellSwitchEnabled2 = app.tables["pushTable"].cells["Comment on My Post"].switches.element(boundBy: 0).value as! String
        XCTAssertNotEqual(cellSwitchEnabled, cellSwitchEnabled2)
    }
    
    func testUserLogin() {
        let notLoggedIn = app.otherElements["main"].waitForExistence(timeout: 5.0)

        if !notLoggedIn {
            print("loadingview exists!!")
            self.waitForLoadingViewToDisappear()
            app.navigationBars["Profile Nav Controller"].buttons["Profile"].tap()
            app.tables.element(boundBy: 0).cells["logoutCell"].staticTexts["logoutCellLabel"].tap()
            app.otherElements["main"].textFields["Email"].waitForExistence(timeout: 5.0)
        }

        if app.otherElements["main"].textFields["Email"].exists {
            print("progressWebView exists!!")
            
            app.otherElements["main"].textFields["Email"].tap()
            app.otherElements["main"].textFields["Email"].typeText("chdowen@notebowl.com")
            app.otherElements["main"].buttons["Next"].tap()
            
            self.waitForCondition(element: app.otherElements["main"].secureTextFields["Password"], predicate: NSPredicate(format: "exists == true"), timeout: 3.0)
            app.otherElements["main"].secureTextFields["Password"].tap()
            app.otherElements["main"].secureTextFields["Password"].typeText("Zenmaster9!")
            app.otherElements["main"].buttons["Sign In"].tap()
            
            self.waitForLoadingViewToDisappear()
        }
    }
}
