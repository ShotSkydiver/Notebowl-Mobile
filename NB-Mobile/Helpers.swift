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

    class func saveTokenToDisk(currentToken: Token) -> Bool {
        do {
            try Disk.save(currentToken, to: .applicationSupport, as: "token.json")
            return true
        }
        catch {
            fatalError(error.localizedDescription)
        }
        return false
    }
    class func saveUserToDisk(user: User) {
        do {
            try Disk.save(user, to: .applicationSupport, as: "currentUser.json")
        }
        catch {
            fatalError(error.localizedDescription)
        }
    }

    class func buildMobileRegisterQuery() -> [URLQueryItem] {
        let deviceInfo = Deviice.current
        let deviceOS = (Luminous.System.Hardware.systemName + " " + Luminous.System.Hardware.systemVersion)

        let uuidQuery = URLQueryItem(name: "uuid", value: Luminous.System.Hardware.Device.identifierForVendor!)
        let nameQuery = URLQueryItem(name: "name", value: deviceInfo.model)
        let osQuery = URLQueryItem(name: "os", value: deviceOS)
        let typeQuery = URLQueryItem(name: "type", value: deviceInfo.type.rawValue)
        let modelQuery = URLQueryItem(name: "model", value: deviceInfo.identifier)

        return [uuidQuery, nameQuery, osQuery, typeQuery, modelQuery]
    }

}

