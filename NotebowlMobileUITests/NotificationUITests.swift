//
//  NotificationUITests.swift
//  NotebowlMobileUITests
//
//  Created by Conner Owen on 7/24/18.
//  Copyright © 2018 Notebowl. All rights reserved.
//

import XCTest

class NotificationUITests: NBUITests {
    
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }

    func testNotificationsBadgeClear() {
        app.tabBars.buttons["notificationsItem"].tap()
        guard let badgeValue = app.tabBars.buttons["notificationsItem"].value as? String else {
            XCTFail("badge value not updated")
            return
        }
        XCTAssertEqual(badgeValue, "")
    }
}
