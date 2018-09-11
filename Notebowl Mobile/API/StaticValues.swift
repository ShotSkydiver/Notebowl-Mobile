//
//  StaticValues.swift
//  Notebowl Mobile
//
//  Created by Conner Owen on 9/11/18.
//  Copyright © 2018 Notebowl. All rights reserved.
//

import Foundation

enum Environment: String {
    case Production = "platform.notebowl.com"
    case Local = "demo.notebowl.xyz"
}

public var baseUrl: String {
    #if DEBUG
    return Environment.Local.rawValue
    #else
    return Environment.Production.rawValue
    #endif
}

public var socketUrl: String { return "https://\(baseUrl)/socket.io/" }
