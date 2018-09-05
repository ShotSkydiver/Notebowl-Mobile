//
//  StaticValues.swift
//  NotebowlMobileUITests
//
//  Created by Conner Owen on 7/30/18.
//  Copyright © 2018 Notebowl. All rights reserved.
//

import Foundation
import XCTest

public struct AvailableCourses {
    static var firstCourse = "ENG 109: Honors English"
    static var secondCourse = "PHYS 241: Electro Magnetic Physics"
}

enum Environment: String {
    case Production = "platform.notebowl.com"
    case Local = "demo.notebowl.xyz"
}

public var textToEditPostWith: String { return " Post edited!" }

