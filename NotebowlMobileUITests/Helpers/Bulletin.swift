//
//  Bulletin.swift
//  NotebowlMobileUITests
//
//  Created by Conner Owen on 8/29/18.
//  Copyright © 2018 Notebowl. All rights reserved.
//

import Foundation
import XCTest

func setupBulletin(_ app: XCUIApplication, testCase: NBUITests) {
    Bulletin.setup(app, testCase: testCase)
}

@objcMembers
class Bulletin: XCTestHelpers {
    static var app: XCUIApplication!
    static var currentTestCase: NBUITests!

    class func setup(_ app: XCUIApplication, testCase: NBUITests) {
        Bulletin.app = app
        Bulletin.currentTestCase = testCase
    }

    class func waitUntilPostExists(atIndex index: Int) -> BulletinPost {
        let post = BulletinPost(index: index)
        waitForElementToExist(post.element)
        return post
    }
    class func waitUntilCommentExists(atIndex index: Int) -> BulletinComment {
        let comment = BulletinComment(index: index)
        waitForElementToExist(comment.element)
        return comment
    }

    class func startCreatingNewPost(asAnonymousUser anon: Bool = false) {
        waitForElementToExist(app.createNewPostHeader)
        app.createNewPostHeader.tap()
        app.editablePostTextView.typeText(Lorem.sentences(3))
        app.coursePickerButton.tap()
        XCTAssertEqual(app.firstCourseInPicker, AvailableCourses.firstCourse)
        app.coursePickerWheel.adjust(toPickerWheelValue: AvailableCourses.secondCourse)
        app.buttons["Done"].tap()
        if anon { app.anonymousButton.tap() }
    }

    class func startCreatingNewComment(asAnon: Bool = false) {
        waitForElementToExist(app.inputTextView)
        app.inputTextView.staticTexts.element.tap(force: true)
        app.inputTextView.typeText(Lorem.sentences(3))
        if asAnon { app.anonymousButton.tap() }
    }

    class func addAttachmentsToNewPost() {
        BulletinPost().addAttachments()
    }
    class func addAttachmentsToNewComment() {
        BulletinComment().addAttachments()
    }

    class func finishCreatingAndSubmit() {
        app.submitNewPostButton.tap()
    }
}

extension XCUIApplication {
    var createNewPostHeader: XCUIElement { return self.otherElements["bulletinTableViewHeader"] }
    var editablePostTextView: XCUIElement { return self.textViews["createPostText"] }
    var inputTextView: XCUIElement { return self.textViews["newCommentTextView"] }

    var photoLibraryButton: XCUIElement { return self.buttons["photoLibraryButton"] }
    var coursePickerButton: XCUIElement { return self.buttons["coursePickerButton"] }
    var coursePickerWheel: XCUIElement { return self.pickerWheels.element }
    var firstCourseInPicker: String { return (coursePickerWheel.value as! String) }
    var anonymousButton: XCUIElement { return self.buttons["anonymousButton"] }
    var submitNewPostButton: XCUIElement { return self.buttons["postButton"] }

    var replyToUserLabel: XCUIElement { return self.staticTexts["replyingToUserText"] }
    var cancelUserReplyButton: XCUIElement { return self.buttons["removeReplyButton"] }
}

class BulletinComment: BulletinPost {
    var deleteCommentAction: XCUIElement { return app.alerts["Delete Comment"].buttons["Delete"] }

    var replyButton: XCUIElement { return element.children(matching: .button)["replyButton"] }

    override func deleteSelf() {
        moreButton.tap()
        deleteButton.tap()
        app.alerts["Delete Comment"].buttons["Delete"].tap()
        XCTestHelpers.waitForElementToDisappear(element)
    }

    override func likeSelf() {
        likeButton.tap()
        XCTestHelpers.waitForElementToDisappear(app.HUD)
        XCTAssertEqual(likeText.label, "1")
    }

    override func assertSelf(expectPostedAnonymously anon: Bool = false) {
        XCTAssertEqual(userNameLabel.label, (anon ? "Anonymous" : "Alex Slaughter"))
    }

    func postReplyToSelf(asAnon: Bool = false) {
        replyButton.tap()
        XCTAssertEqual(app.replyToUserLabel.label, (asAnon ? "Replying to Anonymous" : "Replying to Alex Slaughter"))
    }
}

class BulletinPost: NSObject {
    var app: XCUIApplication!
    var indexForPost: Int!
    var element: XCUIElement { return XCUIApplication().tables.children(matching: .cell).element(boundBy: indexForPost) }

    var postTextContent: String { return (element.otherElements["postContent"].value as! String) }
    var dateLabel: XCUIElement { return element.staticTexts["dateLabel"] }
    var userNameLabel: XCUIElement { return element.staticTexts["userNameLabel"] }
    var courseLabel: XCUIElement { return element.staticTexts["courseLabel"] }
    var likeButton: XCUIElement { return element.children(matching: .button)["likeButton"] }
    var likeText: XCUIElement { return element.staticTexts["likeCount"] }
    var moreButton: XCUIElement { return element.children(matching: .button)["moreButton"] }
    var editButton: XCUIElement { return element.buttons["Edit"] }
    var deleteButton: XCUIElement { return element.buttons["Delete"] }
    var reportButton: XCUIElement { return element.buttons["Report"] }

    required init(index: Int) {
        app = XCUIApplication()
        indexForPost = index
    }

    convenience override init() {
        self.init(index: 0)
    }

    func navigateToDetailView() {
        dateLabel.tap(force: true)
    }

    func assertSelf(expectPostedAnonymously anon: Bool = false) {
        XCTAssertEqual(courseLabel.label, AvailableCourses.secondCourse)
        XCTAssertEqual(userNameLabel.label, (anon ? "Anonymous User" : "Alex Slaughter"))
    }

    func reportSelf() {
        moreButton.tap()
        reportButton.tap()
        app.sheets.element.buttons["It doesn't belong on Notebowl"].tap()
        app.HUD.isVisible()
    }

    func likeSelf() {
        likeButton.tap()
        XCTestHelpers.waitForElementToDisappear(app.HUD)
        XCTAssertEqual(likeText.label, "1  ")
    }
    func unlikeSelf() {
        likeButton.tap()
        XCTestHelpers.waitForElementToDisappear(app.HUD)
        XCTAssertFalse(likeText.exists)
    }

    func deleteSelf() {
        moreButton.tap()
        deleteButton.tap()
        app.alerts["Delete Post"].buttons["Delete"].tap()
        XCTestHelpers.waitForElementToDisappear(element)
    }

    func editText(textToAdd text: String = textToEditPostWith) {
        moreButton.tap()
        editButton.tap()
        app.editablePostTextView.typeText(text)
        app.submitNewPostButton.tap()

        XCTAssert(postTextContent.contains(textToEditPostWith))
        XCTAssert(dateLabel.label.contains("edited"))
    }

    func addAttachments(editingExisting: Bool = false) {
        if editingExisting {
            moreButton.tap()
            editButton.tap()
        }
        Bulletin.currentTestCase.handlePhotoLibraryPermissions()

        let ypLibraryView = app.otherElements["YPLibraryView"]
        let ypCollectionView = ypLibraryView.collectionViews["YPLibraryCollectionView"]
        let ypMultipleSelection = ypLibraryView.buttons["ypMultipleSelectionButton"]
        ypMultipleSelection.tap(force: true)

        let ypLibraryViewCell = ypCollectionView.cells["YPLibraryViewCell-0-0"]
        ypLibraryViewCell.otherElements["YPCellContentView-0-0"].tap()
        XCTAssert(ypMultipleSelection.isEnabled)
        ypCollectionView.otherElements["YPCellContentView-0-1"].tap()

        app.navigationBars["YPImagePicker.YPPickerVC"].buttons["Next"].tap()
        let uploadedAttachmentCell = app.collectionViews["AttachmentsCollectionView"].cells["UploadImageAttachmentCell-0"]
        XCTestHelpers.waitForElementToExist(uploadedAttachmentCell)
        sleep(3)
    }

    func assertAttachmentsExist() {
        let attachmentCells = element.otherElements.containing(NSPredicate(format: "identifier contains %@", "IndexedCollectionViewCell")).allElementsBoundByIndex
        XCTAssert(attachmentCells.count > 0)
    }
}

@objcMembers
class XCTestHelpers: NSObject {
    static func waitForCondition(element: XCUIElement, predicate: NSPredicate, timeout: TimeInterval = 7.5) {
        let expression = XCTNSPredicateExpectation(predicate: predicate, object: element)
        _ = XCTWaiter.wait(for: [expression], timeout: timeout)
    }
    static func waitForElementToExist(_ element: XCUIElement) {
        waitForCondition(element: element, predicate: NSPredicate(format: "exists == true"))
    }
    static func waitForElementToDisappear(_ element: XCUIElement) {
        waitForCondition(element: element, predicate: NSPredicate(format: "exists == false"))
    }
    static func printAllElements() {
        let app = XCUIApplication()
        print(app.descendants(matching: .any).debugDescription)
    }
    static func assertCourseCount(count: Int = 1) {
        XCTAssertEqual(XCUIApplication().tables.cells.count, count)
    }
}

extension NBUITests {
    func handlePhotoLibraryPermissions() {
        addUIInterruptionMonitor(withDescription: "Photos Dialog") { alert -> Bool in
            if alert.buttons["OK"].exists {
                alert.buttons["OK"].tap()
                return true
            }
            return false
        }
        app.photoLibraryButton.tap()
        app.tap()
    }
}

extension XCUIApplication {
    var HUD: XCUIElement { return self.otherElements["PKHUD"] }
}

extension XCUIElement {
    func isVisible(shouldBeVisible: Bool = true) {
        guard let window = XCUIApplication().windows.allElementsBoundByIndex.first(where: { $0.frame.isEmpty == false }) else {
            print("Couldn't find an element window in XCUIApplication with a non-empty frame.")
            return
        }
        XCTAssertEqual(window.frame.contains(self.frame), shouldBeVisible)
    }

    func tap(force: Bool) {
        if isHittable {
            tap()
        } else if force {
            coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5)).tap()
        }
    }
}
