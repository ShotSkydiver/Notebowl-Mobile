//
//  MiscAppUITests.swift
//  NotebowlMobileUITests
//
//  Created by Conner Owen on 7/24/18.
//  Copyright © 2018 Notebowl. All rights reserved.
//

import XCTest


class MiscAppUITests: XCTestCase {

    let app = XCUIApplication()
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.launch()
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
}
