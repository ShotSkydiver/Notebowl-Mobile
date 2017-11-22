//
//  Extensions.swift
//  NB-Mobile
//
//  Created by Conner Owen on 11/21/17.
//  Copyright © 2017 NoteBowl. All rights reserved.
//

import Foundation

enum CodingError : Error {
    case RuntimeError(String)
}

public extension Decodable {
    init(json: String, keyPath: String? = nil) throws {
        guard let data = json.data(using: .utf8) else { throw CodingError.RuntimeError("cannot create data from string") }
        try self.init(data: data, keyPath: keyPath)
    }
    
    init(data: Data, keyPath: String? = nil) throws {
        if let keyPath = keyPath {
            let topLevel = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
            guard let nestedJson = (topLevel as AnyObject).value(forKeyPath: keyPath) else { throw CodingError.RuntimeError("Cannot decode data to object")  }
            let nestedData = try JSONSerialization.data(withJSONObject: nestedJson)
            let value = try JSONDecoder().decode(Self.self, from: nestedData)
            self = value
            return
        }
        let value = try JSONDecoder().decode(Self.self, from: data)
        self = value
    }
}


public extension String {
    func encodeURIComponent() -> String? {
        var characterSet = NSMutableCharacterSet.alphanumeric()
        characterSet.addCharacters(in: "-_.!~*'()")
        return self.addingPercentEncoding(withAllowedCharacters: characterSet as CharacterSet)
    }
}
