//
//  Helpers.swift
//  Notebowl Mobile
//
//  Created by Conner Owen on 5/7/18.
//  Copyright © 2018 Notebowl. All rights reserved.
//

import Foundation
import UIKit

public enum RequestKind: String {
    case api = "/api/v1.0/"
    case rpc = "/rpc/v1.0/"
    case mobile = "/gateway/services/mobile/"
}

public let urlRequestDefaults = JustSessionDefaults(
    JSONReadingOptions: .mutableContainers, // NSJSONSerialization reading options
    JSONWritingOptions: .prettyPrinted,     // NSJSONSerialization writing options
    headers: ["uuid": UIDevice().uuid],     // headers to include in every request
    // multipartBoundary: "Ju5tH77P15Aw350m3", // multipart post request boundaries
    credentialPersistence: .none,           // NSURLCredential persistence options
    encoding: String.Encoding.utf8          // en(de)coding for HTTP body
)

public let API = JustOf<HTTP>(defaults: urlRequestDefaults)

public let errorStatusCodes = [401,403,404,412]

func getUrl(_ url: URLComponentsConvertible, kind: RequestKind = .api, method: HTTPMethod = .get, params: [String: Any] = [:], data: [String: Any] = [:], json: Any? = nil, asyncCompletionHandler: ((HTTPResult) -> Void)? = nil) -> HTTPResult {
    let absoluteUrl = ((url.urlComponents?.host) != nil) ? url as! String : "https://\(NBClient.baseUrl)\(kind.rawValue)\(url)"

    return API.request(method, url: absoluteUrl, params: params, data: data, json: json, asyncCompletionHandler: asyncCompletionHandler)    
}
