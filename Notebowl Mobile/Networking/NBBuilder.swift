//
//  NBBuilder.swift
//  Notebowl Mobile
//
//  Created by Conner Owen on 5/23/18.
//  Copyright © 2018 Notebowl. All rights reserved.
//

import Foundation
import UIKit

extension NBNetworking {
    func queryComponents(_ key: String, _ value: Any!) -> [(String, String)] {
        var components: [(String, String)] = []
        if let dictionary = value as? [String: Any] {
            for (nestedKey, value) in dictionary {
                components += queryComponents("\(key)[\(nestedKey)]", value)
            }
        } else if let array = value as? [Any] {
            for value in array {
                components += queryComponents("\(key)", value)
            }
        } else if let queryString = value as? String {
            components.append((
                percentEncodeString(key),
                percentEncodeString(queryString))
            )
        }
        return components
    }

    func query(_ parameters: [String: Any]) -> String {
        var components: [(String, String)] = []
        for key in Array(parameters.keys).sorted(by: <) {
            let empty = parameters[key]
            components += self.queryComponents(key, empty)
        }
        return (components.map{"\($0)=\($1)"} as [String]).joined(separator: "&")
    }

    func percentEncodeString(_ originalObject: Any) -> String {
        if originalObject is NSNull {
            return "null"
        } else {
            var reserved = CharacterSet.urlQueryAllowed
            reserved.remove(charactersIn: ": #[]@!$&'()*+, ;=")
            return String(describing: originalObject)
                .addingPercentEncoding(withAllowedCharacters: reserved) ?? ""
        }
    }

    func synthesizeMultipartBody(_ data: [String: Any], files: [String: File]) -> Data? {
        var body = Data()
        let boundary = "--\(self.sessionDefaults.multipartBoundary)\r\n"
            .data(using: sessionDefaults.encoding)!
        for (k, v) in data {
            let valueToSend: Any = v is NSNull ? "null" : v
            body.append(boundary)
            body.append("Content-Disposition: form-data; name=\"\(k)\"\r\n\r\n"
                .data(using: sessionDefaults.encoding)!)
            body.append("\(valueToSend)\r\n".data(using: sessionDefaults.encoding)!)
        }
        for (k, v) in files {
            body.append(boundary)
            var partContent: Data? = nil
            var partFilename: String? = nil
            var partMimetype: String? = nil
            switch v {
            case let .url(URL, mimetype):
                partFilename = URL.lastPathComponent
                if let URLContent = try? Data(contentsOf: URL) {
                    partContent = URLContent
                }
                partMimetype = mimetype
            case let .text(filename, text, mimetype):
                partFilename = filename
                if let textData = text.data(using: sessionDefaults.encoding) {
                    partContent = textData
                }
                partMimetype = mimetype
            case let .data(filename, data, mimetype):
                partFilename = filename
                partContent = data
                partMimetype = mimetype
            }
            if let content = partContent, let filename = partFilename {
                let dispose = "Content-Disposition: form-data; name=\"\(k)\"; filename=\"\(filename)\"\r\n"
                body.append(dispose.data(using: sessionDefaults.encoding)!)
                if let type = partMimetype {
                    body.append(
                        "Content-Type: \(type)\r\n\r\n".data(using: sessionDefaults.encoding)!)
                } else {
                    body.append("\r\n".data(using: sessionDefaults.encoding)!)
                }
                body.append(content)
                body.append("\r\n".data(using: sessionDefaults.encoding)!)
            }
        }
        if body.count > 0 {
            body.append("--\(self.sessionDefaults.multipartBoundary)--\r\n"
                .data(using: sessionDefaults.encoding)!)
        }
        return body
    }

    func addCookies(_ URL: Foundation.URL, newCookies: [String: String]) {
        for (k, v) in newCookies {
            if let cookie = HTTPCookie(properties: [
                HTTPCookiePropertyKey.name: k,
                HTTPCookiePropertyKey.value: v,
                HTTPCookiePropertyKey.originURL: URL,
                HTTPCookiePropertyKey.path: "/"
                ])
            {
                self.nbSession.configuration.httpCookieStorage?.setCookie(cookie)
            }
        }
    }

}
