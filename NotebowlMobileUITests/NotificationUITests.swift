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
        notificationTab.tap()
        XCTAssertEqual(badgeValue, "")
    }
}
