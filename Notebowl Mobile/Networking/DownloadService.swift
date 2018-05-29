//
//  DownloadService.swift
//  Notebowl Mobile
//
//  Created by Conner Owen on 5/22/18.
//  Copyright © 2018 Notebowl. All rights reserved.
//

import Foundation
import UIKit
import netfox
import HTTPStatusCodes

typealias RequestTaskID = Int
public typealias Credential = (username: String, password: String)
typealias RequestProgressHandler = (RequestProgress) -> Void
typealias RequestCompletionHandler = (NBResult) -> Void

struct RequestProgress {
    public enum `Type` {
        case upload
        case download
    }
    let type: Type
    let totalBytesProcessed: Int64
    let totalBytesExpectedToProcess: Int64
    var buffer: Data?
    var percentageUpload: Double { return Double(totalBytesProcessed) / Double(totalBytesExpectedToProcess) }
}

struct RequestConfiguration {
    let credential: Credential?
    let redirects: Bool
    let originalRequest: URLRequest?
    var data: Data
    let progressHandler: RequestProgressHandler?
    let completionHandler: RequestCompletionHandler?
}

struct NBSessionDefaults {
    var startRequestImmediately: Bool
     var JSONReadingOptions: JSONSerialization.ReadingOptions
     var JSONWritingOptions: JSONSerialization.WritingOptions
     var headers: [String: String]
     var multipartBoundary: String
     var credentialPersistence: URLCredential.Persistence
     var encoding: String.Encoding
     var cachePolicy: NSURLRequest.CachePolicy
     init(
        startRequestImmediately: Bool = true,
        JSONReadingOptions: JSONSerialization.ReadingOptions = JSONSerialization.ReadingOptions(rawValue: 0),
        JSONWritingOptions: JSONSerialization.WritingOptions = JSONSerialization.WritingOptions(rawValue: 0),
        headers: [String: String] = [:],
        multipartBoundary: String = "Ju5tH77P15Aw350m3",
        credentialPersistence: URLCredential.Persistence = .forSession,
        encoding: String.Encoding = String.Encoding.utf8,
        cachePolicy: NSURLRequest.CachePolicy = .reloadIgnoringLocalCacheData)
    {
        self.startRequestImmediately = startRequestImmediately
        self.JSONReadingOptions = JSONReadingOptions
        self.JSONWritingOptions = JSONWritingOptions
        self.headers = headers
        self.multipartBoundary = multipartBoundary
        self.encoding = encoding
        self.credentialPersistence = credentialPersistence
        self.cachePolicy = cachePolicy
    }
}



class NBNetworking: NSObject, URLSessionDelegate {
    var nbSession: URLSession!
    var sessionDefaults: NBSessionDefaults!
    var requestConfigs: [RequestTaskID: RequestConfiguration]=[:]
    
    var invalidURL = NSError(domain: NSURLErrorDomain, code: 0, userInfo: [NSLocalizedDescriptionKey: "URL is invalid!"])
    var improperAsyncAccess = NSError(domain: NSCocoaErrorDomain, code: 1, userInfo: [NSLocalizedDescriptionKey: "You are accessing asynchronous result synchronously."])
    var taskNeverStarted = NSError(domain: "com.notebowl.NB", code: 2, userInfo: [NSLocalizedDescriptionKey: "DataTask for request hasn't been started yet!"])
    
    static let shared: NBNetworking = {
        let instance = NBNetworking()
        instance.nbSession = URLSession(configuration: URLSessionConfiguration.withHeaders, delegate: instance, delegateQueue: nil)
        instance.sessionDefaults = NBSessionDefaults(JSONReadingOptions: .mutableContainers, JSONWritingOptions: .prettyPrinted, headers: ["uuid": UIDevice().uuid], encoding: String.Encoding.utf8)
        return instance
    }()
    
    private override init() { }

    func makeTask(_ request: URLRequest, configuration: RequestConfiguration) -> URLSessionDataTask?
    {
        let task = nbSession.dataTask(with: request)
        requestConfigs[task.taskIdentifier] = configuration
        return task
        
    }
    
    func get(url: URLComponentsMutable) {
        
    }
    
    
    func upload(url: URLComponentsMutable, file: File) {
        
    }
    
    
    func download(url: URLComponentsMutable) {
        
    }
}

extension NBNetworking {
    
    func synthesizeRequest(
        _ method: Method,
        url: URLComponentsMutable,
        params: [String: Any],
        data: [String: Any],
        json: Any?,
        headers: LowercasedDictionary<String, String>,
        files: [String: File],
        auth: Credential?,
        timeout: Double?,
        urlQuery: String?,
        requestBody: Data?
        ) -> URLRequest? {
        if var urlComponents = url.urlComponent {
            let queryString = query(params)
            if queryString.count > 0 {
                urlComponents.percentEncodedQuery = queryString
            }
            
            var finalHeaders = headers
            var contentType: String? = nil
            var body: Data?
            if let requestData = requestBody {
                body = requestData
            } else if files.count > 0 {
                body = synthesizeMultipartBody(data, files: files)
                let bound = self.sessionDefaults.multipartBoundary
                contentType = "multipart/form-data; boundary=\(bound)"
            } else {
                if let requestJSON = json {
                    contentType = "application/json"
                    body = try? JSONSerialization.data(withJSONObject: requestJSON,
                                                       options: sessionDefaults.JSONWritingOptions)
                    
                } else {
                    if data.count > 0 {
                        if headers["content-type"]?.lowercased() == "application/json" {
                            body = try? JSONSerialization.data(withJSONObject: data,
                                                               options: sessionDefaults.JSONWritingOptions)
                        } else {
                            contentType = "application/x-www-form-urlencoded"
                            body = query(data).data(using: sessionDefaults.encoding)
                        }
                    }
                }
            }
            if let contentTypeValue = contentType {
                finalHeaders["Content-Type"] = contentTypeValue
            }
            if let auth = auth,
                let utf8 = "\(auth.0):\(auth.1)".data(using: String.Encoding.utf8)
            {
                finalHeaders["Authorization"] = "Basic \(utf8.base64EncodedString())"
            }
            if let URL = urlComponents.url {
                var request = URLRequest(url: URL)
                request.cachePolicy = sessionDefaults.cachePolicy
                request.httpBody = body
                request.httpMethod = method.rawValue
                if let requestTimeout = timeout {
                    request.timeoutInterval = requestTimeout
                }
                
                for (k, v) in sessionDefaults.headers {
                    request.addValue(v, forHTTPHeaderField: k)
                }
                
                for (k, v) in finalHeaders {
                    request.addValue(v, forHTTPHeaderField: k)
                }
                return request as URLRequest
            }
        }
        return nil
    }
    
    func request(
        _ method: Method = .get,
        url: URLComponentsMutable,
        params: [String: Any] = [:],
        data: [String: Any] = [:],
        json: Any? = nil,
        headers: [String: String] = [:],
        files: [String: File] = [:],
        auth: Credential? = nil,
        cookies: [String: String] = [:],
        loadImmediately: Bool = true,
        redirects: Bool = true,
        timeout: Double? = nil,
        urlQuery: String? = nil,
        requestBody: Data? = nil,
        asyncProgressHandler: RequestProgressHandler? = nil,
        asyncCompletionHandler: ((NBResult) -> Void)? = nil
        ) -> NBResult {
        
        let isSynchronous = asyncCompletionHandler == nil
        let semaphore = DispatchSemaphore(value: 0)
        var requestResult: NBResult = NBResult(data: nil, response: nil, error: improperAsyncAccess, task: nil)
        
        let caseInsensitiveHeaders = LowercasedDictionary<String, String>(dictionary: headers)
        guard let synthesizedRequest = synthesizeRequest(method, url: url, params: params, data: data, json: json, headers: caseInsensitiveHeaders, files: files, auth: auth, timeout: timeout, urlQuery: urlQuery, requestBody: requestBody) else {
            
            let resultWithError = NBResult(data: nil, response: nil, error: invalidURL, task: nil)
            if let handler = asyncCompletionHandler {
                handler(resultWithError)
            }
            return resultWithError
        }
        
        addCookies(synthesizedRequest.url!, newCookies: cookies)
        let config = RequestConfiguration(credential: auth, redirects: redirects, originalRequest: synthesizedRequest, data: Data(), progressHandler: asyncProgressHandler) { result in
            if let handler = asyncCompletionHandler {
                handler(result)
            }
            if isSynchronous {
                requestResult = result
                TTLog.warning("should we not implement semaphore???")
                semaphore.signal()
            }
        }
        
        if let task = makeTask(synthesizedRequest, configuration: config) {
            if loadImmediately {
                task.resume()
            }
            else {
                TTLog.warning("delayed start babbyyyy")
                return NBResult(data: nil, response: nil, error: taskNeverStarted, task: task)
            }
        }
        
        if isSynchronous {
            let timeout = timeout.flatMap { DispatchTime.now() + $0 }
                ?? DispatchTime.distantFuture
            _ = semaphore.wait(timeout: timeout)
            return requestResult
        }
        
        return requestResult
    }
}




extension NBNetworking: URLSessionTaskDelegate, URLSessionDataDelegate {
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        
        if let handler = requestConfigs[task.taskIdentifier]?.progressHandler {
            handler(
                RequestProgress(
                    type: .upload,
                    totalBytesProcessed: totalBytesSent,
                    totalBytesExpectedToProcess: totalBytesExpectedToSend,
                    buffer: nil
                )
            )
        }
    }
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        if let handler = requestConfigs[dataTask.taskIdentifier]?.progressHandler {
            handler(
                RequestProgress(
                    type: .download,
                    totalBytesProcessed: dataTask.countOfBytesReceived,
                    totalBytesExpectedToProcess: dataTask.countOfBytesExpectedToReceive,
                    buffer: data
                )
            )
        }
        if requestConfigs[dataTask.taskIdentifier]?.data != nil {
            requestConfigs[dataTask.taskIdentifier]?.data.append(data)
        }
    }
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let config = requestConfigs[task.taskIdentifier], let handler = config.completionHandler {
            let result = NBResult(data: config.data, response: task.response, error: error, task: task)
            result.JSONReadingOptions = self.sessionDefaults.JSONReadingOptions
            result.encoding = self.sessionDefaults.encoding
            handler(result)
        }
        
        requestConfigs.removeValue(forKey: task.taskIdentifier)
    }
}
extension URLSessionConfiguration {
    static var withHeaders: URLSessionConfiguration {
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = ["uuid": UIDevice().uuid]
        return config
    }
}
