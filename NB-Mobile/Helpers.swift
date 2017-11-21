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


    class func buildMobileRegisterQuery() -> String {
        let deviceInfo = Deviice.current
        let deviceOS = (Luminous.System.Hardware.systemName + " " + Luminous.System.Hardware.systemVersion)

        var params = "?uuid=\(Luminous.System.Hardware.Device.identifierForVendor!)&name=\(deviceInfo.model)&os=\(deviceOS)&type=\(deviceInfo.type)&model=\(deviceInfo.identifier)"
        params = params.encodeURIComponent()!

        var base = "/gateway/services/mobile/register"
        base = base.encodeURIComponent()!

        let finalEncoded = (base + params.encodeURIComponent()!)

        return finalEncoded
    }

}


extension String {

    func encodeURIComponent() -> String? {
        var characterSet = NSMutableCharacterSet.alphanumeric()
        characterSet.addCharacters(in: "-_.!~*'()")
        return self.addingPercentEncoding(withAllowedCharacters: characterSet as CharacterSet)
    }
}
