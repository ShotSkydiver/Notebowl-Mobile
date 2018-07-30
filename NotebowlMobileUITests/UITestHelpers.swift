//
//  UITestHelpers.swift
//  NotebowlMobileUITests
//
//  Created by Conner Owen on 7/24/18.
//  Copyright © 2018 Notebowl. All rights reserved.
//

import Foundation

import XCTest

extension XCTestCase {
    
    func waitForCondition(element: XCUIElement, predicate: NSPredicate, timeout: TimeInterval = 3.0) {
        expectation(for: predicate, evaluatedWith: element, handler: nil)
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func waitForLoadingViewToDisappear() {
        self.waitForCondition(element: app.otherElements["loadingView"], predicate: NSPredicate(format: "exists == false"), timeout: 30.0)
    }
    func waitForLoadingViewToAppear() {
        self.waitForCondition(element: app.otherElements["loadingView"], predicate: NSPredicate(format: "exists == true"), timeout: 10.0)
    }
    
    func waitForHUDToDisappear() {
        self.waitForCondition(element: app.otherElements["PKHUD"], predicate: NSPredicate(format: "exists == false"), timeout: 5.5)
    }
    func waitForHUDToAppear() {
        self.waitForCondition(element: app.otherElements["PKHUD"], predicate: NSPredicate(format: "exists == true"), timeout: 1.5)
    }
    
    func checkIsElementVisible(element: XCUIElement) {
        let window = app.windows.element(boundBy: 0)
        XCTAssert(window.frame.contains(element.frame))
    }
    func checkIsElementNotVisible(element: XCUIElement) {
        let window = app.windows.element(boundBy: 0)
        XCTAssertFalse(window.frame.contains(element.frame))
    }
    
    func handlePhotoPermissions() {
        addUIInterruptionMonitor(withDescription: "Photos Dialog") { (alert) -> Bool in
            if alert.buttons["Grant Permission"].exists { alert.buttons["Grant permission"].tap() }
            else if alert.buttons["OK"].exists { alert.buttons["OK"].tap() }

            return true
        }
    }
    
}
