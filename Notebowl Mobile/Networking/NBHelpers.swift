//
//  NBHelpers.swift
//  Notebowl Mobile
//
//  Created by Conner Owen on 5/23/18.
//  Copyright © 2018 Notebowl. All rights reserved.
//

import Foundation
import UIKit
import HTTPStatusCodes

public enum RequestKind: String {
    case api = "/api/v1.0/"
    case rpc = "/rpc/v1.0/"
    case mobile = "/gateway/services/mobile/"
}
extension RequestKind {
    func requestUrl(url: String) -> String {
        return ("https://\(NBClient.baseUrl)\(self.rawValue)\(url)")
    }
}
public let errorStatusCodes = [401,403,404,412]


enum File {
    case url(URL, String?)
    case data(String, Foundation.Data, String?)
    case text(String, String, String?)
}
enum Method: String {
    case delete = "DELETE"
    case get = "GET"
    case head = "HEAD"
    case options = "OPTIONS"
    case patch = "PATCH"
    case post = "POST"
    case put = "PUT"
}

struct LowercasedDictionary<Key: Hashable, Value>: Collection, ExpressibleByDictionaryLiteral {
    private var _data: [Key: Value] = [:]
    private var _keyMap: [String: Key] = [:]
    public typealias Element = (key: Key, value: Value)
    public typealias Index = DictionaryIndex<Key, Value>
    public var startIndex: Index {
        return _data.startIndex
    }
    public var endIndex: Index {
        return _data.endIndex
    }
    public func index(after: Index) -> Index {
        return _data.index(after: after)
    }
    
    public var count: Int {
        assert(_data.count == _keyMap.count, "internal keys out of sync")
        return _data.count
    }
    public var isEmpty: Bool {
        return _data.isEmpty
    }
    
    public init(dictionaryLiteral elements: (Key, Value)...) {
        for (key, value) in elements {
            _keyMap["\(key)".lowercased()] = key
            _data[key] = value
        }
    }
    public init(dictionary: [Key: Value]) {
        for (key, value) in dictionary {
            _keyMap["\(key)".lowercased()] = key
            _data[key] = value
        }
    }
    public subscript (position: Index) -> Element {
        return _data[position]
    }
    
    public subscript (key: Key) -> Value? {
        get {
            if let realKey = _keyMap["\(key)".lowercased()] {
                return _data[realKey]
            }
            return nil
        }
        set(newValue) {
            let lowerKey = "\(key)".lowercased()
            if _keyMap[lowerKey] == nil {
                _keyMap[lowerKey] = key
            }
            _data[_keyMap[lowerKey]!] = newValue
        }
    }
    
    public func makeIterator() -> DictionaryIterator<Key, Value> {
        return _data.makeIterator()
    }
    public var keys: Dictionary<Key, Value>.Keys {
        return _data.keys
    }
    public var values: Dictionary<Key, Value>.Values {
        return _data.values
    }
}



extension URLResponse {
    var Headers: [String: String] {
        return (self as? HTTPURLResponse)?.allHeaderFields as? [String: String]
            ?? [:]
    }
}
protocol URLComponentsMutable {
    var urlComponent: URLComponents? { get }
}
extension String: URLComponentsMutable {
    public var urlComponent: URLComponents? {
        return URLComponents(string: self)
    }
}
extension URL: URLComponentsMutable {
    public var urlComponent: URLComponents? {
        return URLComponents(url: self, resolvingAgainstBaseURL: true)
    }
}
