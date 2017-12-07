//
//  Extensions.swift
//  NB-Mobile
//
//  Created by Conner Owen on 11/21/17.
//  Copyright © 2017 NoteBowl. All rights reserved.
//

import Foundation
import UIKit

enum CodingError : Error {
    case RuntimeError(String)
}

public extension Decodable {
    init(json: String, keyPath: String? = "result") throws {
        guard let data = json.data(using: .utf8) else { throw CodingError.RuntimeError("cannot create data from string") }
        try self.init(data: data, keyPath: keyPath)
    }
    
    init(data: Data, keyPath: String? = "result") throws {
        if let keyPath = keyPath {
            let topLevel = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
            guard let nestedJson = (topLevel as AnyObject).value(forKeyPath: keyPath) else { throw CodingError.RuntimeError("Cannot decode data to object")  }
            let nestedData = try JSONSerialization.data(withJSONObject: nestedJson)
            self = try JSONDecoder().decode(Self.self, from: nestedData)
            return
        }
        self = try JSONDecoder().decode(Self.self, from: data)
    }
}


public extension String {
    func encodeURIComponent() -> String? {
        let characterSet = NSMutableCharacterSet.alphanumeric()
        characterSet.addCharacters(in: "-_.!~*'()")
        return self.addingPercentEncoding(withAllowedCharacters: characterSet as CharacterSet)
    }
}

public extension DateFormatter {
    static var iso8061: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return formatter
    }
}

public extension UIDevice {
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
    
    var deviceQuery: String {
        var params = "?uuid=\(identifierForVendor!)&name=\(name)&os=\(systemVersion)&type=\(model)&model=\(modelName)"
        params = params.encodeURIComponent()!
        var base = "/gateway/services/mobile/register"
        base = base.encodeURIComponent()!
        let finalEncoded = (base + params.encodeURIComponent()!)
        return finalEncoded
    }
}


