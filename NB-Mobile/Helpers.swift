//
//  Helpers.swift
//  NB-Mobile
//
//  Created by Conner Owen on 9/29/17.
//  Copyright © 2017 NoteBowl. All rights reserved.
//

import Foundation
import Luminous
import Deviice
import Disk

class Helpers: NSObject {
    
    class func appendTokenToURL(url: URL, token: Token) -> URL {
        var urlComp = URLComponents(url: url, resolvingAgainstBaseURL: true)
        urlComp?.queryItems = [(URLQueryItem(name: "token", value: "\(token.token)")), (URLQueryItem(name: "uuid", value: "\(token.uuid)"))]
        return (urlComp?.url)!
    }

    class func saveTokenToDisk(uuid: String, token: String) {
        let currentToken = Token(uuid: uuid, token: token)
        do {
            try Disk.save(currentToken, to: .applicationSupport, as: "token.json")
        }
        catch {
            fatalError(error.localizedDescription)
        }
    }
    class func saveUserToDisk(user: User) {
        do {
            try Disk.save(user, to: .applicationSupport, as: "currentUser.json")
            print("saved user to disk!")
        }
        catch {
            fatalError(error.localizedDescription)
        }
    }

    class func decodeUserObject(jsonString: String) -> User? {
        var userResult: User?
        let jsonData = jsonString.data(using: .utf8)!
        do {
            let decoder = JSONDecoder()
            //let formatter = DateFormatter()
            //formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSxxx"
            //formatter.timeZone = TimeZone(secondsFromGMT: 0)
            //formatter.locale = Locale(identifier: "en_US_POSIX")
            //decoder.dateDecodingStrategy = .formatted(formatter)

            let user = try decoder.decode(Users.self, from: jsonData)
            userResult = user.result
            Helpers.saveUserToDisk(user: userResult!)
            print("success decoding user!")
        }
        catch {
            print("error decoding!", error)
        }
        return userResult
    }

    class func checkIfUserLoggedIn() -> Bool {
        do {
            let retrievedToken = try Disk.retrieve("token.json", from: .applicationSupport, as: Token.self)
            let retrievedUser = try Disk.retrieve("currentUser.json", from: .applicationSupport, as: User.self)
            let userURL = Helpers.appendTokenToURL(url: retrievedUser.userJsonURL, token: retrievedToken)
            print("userurl: ", userURL)
            let task = URLSession().dataTask(with: URLRequest(url: userURL)) { (responseData, response, responseError) in
                //DispatchQueue.main.async {

            }
            task.resume()
            let statusCode = (task.response as! HTTPURLResponse).statusCode
            if (statusCode == 404) {
                print("not logged in!")
                return false
            }
            else if (statusCode == 200) {
                print("logged in!")
                return true
            }
        }
        catch {
            print("error trying to retrieve stored token! ", error)
            return false
        }
        return false
    }

}


struct AppValues {
    
    // MARK:- URLS

    // https://demo.nbstage.com/
    // https://denison.nbstage.com/
    // https://holycross.notebowl.com/
    // https://arizona.nbstage.com/
    
    static let root_domain = "nbstage.com"
    static let base_url = "https://demo.nbstage.com"
    static let api_path = "/api/v1.0/"
    static let rpc_path = "/api/v1.0/"
    
    /// POST {email, password}
    static let credentials = base_url + api_path + "credentials"
    static let courses = base_url + api_path + "courses"

    static let deviceInfo = Luminous.System.Hardware.Device.current
    static let deviceOS = (Luminous.System.Hardware.systemName + " " + Luminous.System.Hardware.systemVersion)
    // MARK:- TOKEN
    static let token_reg_url = "https://gateway.nbstage.com/services/mobile/register"
    
    static let ipt5_uuid = "664ABFB1-8DB0-4BED-B8EC-D58CCEC7DDF7"
    static let ipt5_token = "661vDu48r9HHHmC1OfuZmw8l0chP8WMt"
    
    static let ipt5_uuidQuery = URLQueryItem(name: "uuid", value: "\(AppValues.ipt5_uuid)")
    static let ipt5_tokenQuery = URLQueryItem(name: "token", value: "\(AppValues.ipt5_token)")
    static let ipt5_queryItems: [URLQueryItem] = [AppValues.ipt5_tokenQuery, AppValues.ipt5_uuidQuery]
}


struct CollegeURLs {

    // MARK:- Denison
    let serviceQuery = URLQueryItem(name: "service", value: "https://denison.nbstage.com/gateway/services/cas/denison/Login")
    var urlComps = URLComponents(string: "https://login.denison.edu/cas/login")
    //urlComps?.queryItems = [serviceQuery]
}
