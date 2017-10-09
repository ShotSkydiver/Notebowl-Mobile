//
//  API.swift
//  NB-Mobile
//
//  Created by Conner Owen on 10/2/17.
//  Copyright © 2017 NoteBowl. All rights reserved.
//

import Foundation
import Luminous
import ResponseDetective
import Disk

class API: NSObject, URLSessionDelegate, URLSessionTaskDelegate {
    
    let device = Luminous.System.Hardware.Device.current
    let deviceUUID = UIDevice().identifierForVendor!.uuidString
    let deviceOS = (Luminous.System.Hardware.systemName + " " + Luminous.System.Hardware.systemVersion)

    var sessionKey = ""
    var casSession: URLSession!

    override init() {
        super.init()

        let serviceQuery = URLQueryItem(name: "service", value: "https://denison.nbstage.com/gateway/services/cas/denison/Login")
        var urlComps = URLComponents(string: "https://login.denison.edu/cas/login")
        urlComps?.queryItems = [serviceQuery]
        var request = URLRequest(url: (urlComps?.url)!)
        request.httpMethod = "GET"
        let config = URLSessionConfiguration.default
        ResponseDetective.enable(inConfiguration: config)
        casSession = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue.main)

        //URLSession.shared
        let sessionTask = casSession.dataTask(with: request, completionHandler: sessionHandler)
        sessionTask.resume()
    }

    func sessionHandler(data: Data?, response: URLResponse?, error: Error?) -> Void {
        print("sessionHandler begin")
        //let responseBody = String(data: data!, encoding: String.Encoding.utf8)

        print("response: ", response)
        print("response headers: ", (response as! HTTPURLResponse).allHeaderFields)

        // casLoginStepTwo(sessionKeyStr: sessionKeyString)
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        print("completed sessionTask")
    }


    func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Void) {
        print("URLSession wants to do a redirect to: ", request)
        var requestComponents = URLComponents(url: request.url!, resolvingAgainstBaseURL: true)
        if let requestQueryItems = requestComponents?.queryItems {
            if (requestQueryItems.count > 0) {
                let sessionQueryItem = requestComponents?.queryItems?.first
                let sessionKeyString = (sessionQueryItem?.value)!
                print("sessionDataKey query item: ", sessionKeyString)
                //sessionKey = sessionKeyString
            }
        }
        else {

        }



        completionHandler(request)
    }

    func casLoginStepTwo(sessionKeyStr: String) {

        // set up next request
        let commonAuthURL = URL(string: "https://login.denison.edu/commonauth")
        var commonAuthRequest = URLRequest(url: commonAuthURL!)
        commonAuthRequest.httpMethod = "POST"

        commonAuthRequest.addValue("text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8", forHTTPHeaderField: "Accept")
        commonAuthRequest.addValue("https://login.denison.edu/denisonAuthEndpoint/login.do", forHTTPHeaderField: "Referer")
        commonAuthRequest.addValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        //request.addValue("1", forHTTPHeaderField: "Upgrade-Insecure-Requests")

        //let testUser = "check_y16"
        //let testPassword = "(N0t3B0wL@2016)"
        //let loginParameters = "username=check_y16&password=%28N0t3B0wL%402016%29&sessionDataKey=\(sessionKey)"

        let bodyParameters = [
            "sessionDataKey": sessionKeyStr,
            "username": "check_y16",
            "password": "(N0t3B0wL@2016)",
            ]
        let bodyString = bodyParameters.queryParameters
        commonAuthRequest.httpBody = bodyString.data(using: .utf8, allowLossyConversion: true)

        //commonAuthRequest.httpBody = loginParameters.data(using: String.Encoding.utf8)

        let casSessionTask = casSession.dataTask(with: commonAuthRequest) { (data, response, error) in
            print("response:", response)
        }
        casSessionTask.resume()

    }

    class func checkIfLoggedIn() -> Bool {
        var loggedInBool: Bool = false
        /*
        var request = URLRequest(url: Helpers.appendTokenToURL(url: AppValues.credentials))
        request.httpMethod = "GET"
        request.addValue("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Safari/604.1.38", forHTTPHeaderField: "User-Agent")
        request.addValue("application/json, text/plain, *//*", forHTTPHeaderField: "Accept")
        
        let config = URLSessionConfiguration.default
        //ResponseDetective.enable(inConfiguration: config)
        let session = URLSession(configuration: config)
        

        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            //DispatchQueue.main.async {
            guard responseError == nil else {
                    loggedInBool = false
                    return
            }
            guard let jsonData = responseData else {
                return
            }
                
            let statusCode = (response as! HTTPURLResponse).statusCode
            if (statusCode == 404) {
                print("not logged in!")
                loggedInBool = false
                return
            }
            else if (statusCode == 200) {
                print("logged in!")
                loggedInBool = true
                
                do {
                    let decoder = JSONDecoder()
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSxxx"
                    formatter.timeZone = TimeZone(secondsFromGMT: 0)
                    formatter.locale = Locale(identifier: "en_US_POSIX")
                    decoder.dateDecodingStrategy = .formatted(formatter)
                    
                    let user = try decoder.decode(Users.self, from: jsonData)
                    self.saveUserObject(user: user.result)
                    print("success decoding user!")
                }
                catch {
                    print("error decoding!", error)
                }
                
                return
            }
        }
        task.resume()
        */
        return loggedInBool
    }
    
    
    
    class func login() {
        // login code here
        
        //saveTokenToDisk(uuid: AppValues.ipt5_uuid, token: AppValues.ipt5_token)
    }
    
    

}

protocol URLQueryParameterStringConvertible {
    var queryParameters: String {get}
}

extension Dictionary : URLQueryParameterStringConvertible {
    /**
     This computed property returns a query parameters string from the given NSDictionary. For
     example, if the input is @{@"day":@"Tuesday", @"month":@"January"}, the output
     string will be @"day=Tuesday&month=January".
     @return The computed parameters string.
     */
    var queryParameters: String {
        var parts: [String] = []
        for (key, value) in self {
            let part = String(format: "%@=%@",
                              String(describing: key).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!,
                              String(describing: value).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            parts.append(part as String)
        }
        return parts.joined(separator: "&")
    }

}

extension URL {
    /**
     Creates a new URL by adding the given query parameters.
     @param parametersDictionary The query parameter dictionary to add.
     @return A new URL.
     */
    func appendingQueryParameters(_ parametersDictionary : Dictionary<String, String>) -> URL {
        let URLString : String = String(format: "%@?%@", self.absoluteString, parametersDictionary.queryParameters)
        return URL(string: URLString)!
    }
}
