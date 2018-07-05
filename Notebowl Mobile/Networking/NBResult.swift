//
//  NBResult.swift
//  Notebowl Mobile
//
//  Created by Conner Owen on 5/23/18.
//  Copyright © 2018 Notebowl. All rights reserved.
//

import Foundation
import UIKit
import HTTPStatusCodes

final class NBResult: NSObject {
    final var content: Data?
    var response: URLResponse?
    var error: Error?
    var request: URLRequest? { return task?.originalRequest }
    var task: URLSessionTask?
    var encoding = String.Encoding.utf8
    var JSONReadingOptions = JSONSerialization.ReadingOptions(rawValue: 0)
    
    
    init(data: Data?, response: URLResponse?, error: Error?, task: URLSessionTask?) {
        self.content = data
        self.response = response
        self.error = error
        self.task = task
    }
    
    var statusCode: HTTPStatusCode? { return response != nil ? (response as! HTTPURLResponse).statusCodeValue : nil }
    var reason: String { return (statusCode?.description)! }
    
    override var description: String { return ("\(request!.httpMethod!) \(request!.url!.absoluteString) \(statusCode!.description)") }
    
    
    var json: Any? { return content.flatMap { try? JSONSerialization.jsonObject(with: $0, options: JSONReadingOptions) }}
    var text: String? { return content.flatMap { String(data: $0, encoding: encoding) } }
    var url: URL? { return response?.url }
    
    
    lazy var headers: LowercasedDictionary<String, String> = {
        return LowercasedDictionary<String, String>(
            dictionary: self.response?.Headers ?? [:])
    }()
    
    lazy var cookies: [String: HTTPCookie] = {
        let foundCookies: [HTTPCookie]
        if let headers = self.response?.Headers, let url = self.response?.url {
            foundCookies = HTTPCookie.cookies(withResponseHeaderFields: headers,
                                              for: url) as [HTTPCookie]
        } else {
            foundCookies = []
        }
        var result: [String: HTTPCookie] = [:]
        for cookie in foundCookies {
            result[cookie.name] = cookie
        }
        return result
    }()
    
    lazy var links: [String: [String: String]] = {
        var result = [String: [String: String]]()
        guard let content = self.headers["link"] else {
            return result
        }
        content.components(separatedBy: ", ").forEach { s in
            let linkComponents = s.components(separatedBy: ";")
                .map {
                    ($0 as String).trimmingCharacters(in: CharacterSet.whitespaces)
            }
            if linkComponents.count > 1 {
                let url = linkComponents.first!
                let start = url.index(url.startIndex, offsetBy: 1)
                let end = url.index(url.endIndex, offsetBy: -1)
                let urlRange = start..<end
                var link: [String: String] = ["url": String(url[urlRange])]
                linkComponents.dropFirst().forEach { s in
                    if let equalIndex = s.index(of: "=") {
                        let componentKey = String(s[s.startIndex..<equalIndex])
                        let range = s.index(equalIndex, offsetBy: 1)..<s.endIndex
                        let value = s[range]
                        if value.first == "\"" && value.last == "\"" {
                            let start = value.index(value.startIndex, offsetBy: 1)
                            let end = value.index(value.endIndex, offsetBy: -1)
                            link[componentKey] = String(value[start..<end])
                        } else {
                            link[componentKey] = String(value)
                        }
                    }
                }
                if let rel = link["rel"] {
                    result[rel] = link
                }
            }
        }
        return result
    }()
    
    func cancel() {
        task?.cancel()
    }
}
