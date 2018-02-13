//
//  Extensions.swift
//  NB-Mobile
//
//  Created by Conner Owen on 11/21/17.
//  Copyright © 2017 NoteBowl. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper

enum CodingError : Error {
    case RuntimeError(String)
}

public extension Decodable {
    init(json: String, keyPath: String? = "result") throws {
        guard let data = json.data(using: .utf8) else { throw CodingError.RuntimeError("cannot create data from string") }
        try self.init(data: data, keyPath: keyPath)
    }
    
    init(data: Data, keyPath: String? = "result") throws {
        if let keyPath = keyPath {
            let topLevel = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
            guard let nestedJson = (topLevel as AnyObject).value(forKeyPath: keyPath) else { throw CodingError.RuntimeError("Cannot decode data to object")  }
            let nestedData = try JSONSerialization.data(withJSONObject: nestedJson)
            self = try JSONDecoder().decode(Self.self, from: nestedData)
            return
        }
        self = try JSONDecoder().decode(Self.self, from: data)
    }
}


public extension String {
    func encodeURIComponent() -> String? {
        let characterSet = NSMutableCharacterSet.alphanumeric()
        characterSet.addCharacters(in: "-_.!~*'()")
        return self.addingPercentEncoding(withAllowedCharacters: characterSet as CharacterSet)
    }
}

public extension DateFormatter {
    static var iso8061: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return formatter
    }
}

public extension Date {
    var relativelyFormatted: String {
        let now = Date()
        let components = Calendar.current.dateComponents(
            [.year, .month, .weekOfYear, .day, .hour, .minute, .second],
            from: self,
            to: now
        )
        if let years = components.year, years > 0 {
            return "\(years) year\(years == 1 ? "" : "s") ago"
        }
        
        if let months = components.month, months > 0 {
            return "\(months) month\(months == 1 ? "" : "s") ago"
        }
        
        if let weeks = components.weekOfYear, weeks > 0 {
            return "\(weeks) week\(weeks == 1 ? "" : "s") ago"
        }
        if let days = components.day, days > 0 {
            guard days > 1 else { return "yesterday" }
            
            return "\(days) day\(days == 1 ? "" : "s") ago"
        }
        
        if let hours = components.hour, hours > 0 {
            return "\(hours) hour\(hours == 1 ? "" : "s") ago"
        }
        
        if let minutes = components.minute, minutes > 0 {
            return "\(minutes) minute\(minutes == 1 ? "" : "s") ago"
        }
        
        if let seconds = components.second, seconds > 30 {
            return "\(seconds) second\(seconds == 1 ? "" : "s") ago"
        }
        
        return "just now"
    }
}

public extension UITableViewCell {
    func showCell(_ show: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.contentView.alpha = show ? 1.0 : 0.0
        }
    }
}

public extension UIDevice {
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
    
    var uuid: String {
        return identifierForVendor!.uuidString
    }
    
    var deviceQuery: String {
        var params = "?uuid=\(identifierForVendor!)&name=\(name)&os=\(systemVersion)&type=\(model)&model=\(modelName)"
        params = params.encodeURIComponent()!
        var base = "/gateway/services/mobile/register"
        base = base.encodeURIComponent()!
        let finalEncoded = (base + params.encodeURIComponent()!)
        return finalEncoded
    }
    
}

public extension UIImage {
    public func filled(withColor color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        color.setFill()
        guard let context = UIGraphicsGetCurrentContext() else { return self }
        
        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.setBlendMode(CGBlendMode.normal)
        
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        guard let mask = self.cgImage else { return self }
        context.clip(to: rect, mask: mask)
        context.fill(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
}

class ObjectTransform<T: Object>: TransformType {
    public typealias Object = T
    public typealias JSON = String
    
    func transformFromJSON(_ value: Any?) -> T? {
        let urlString = value as! String
        
        let req = Just.get(urlString, params: ["uuid": UIDevice().uuid])
        
        if (req.ok) {
            let reqJson = req.json
            let nestedJson = (reqJson as AnyObject).value(forKeyPath: "result")
            
            let mapp = Mapper<T>().map(JSONObject: nestedJson!)
            return mapp
        }
        return nil
    }
    
    func transformToJSON(_ value: T?) -> String? {
        return nil
    }
}

class ImageTransform: TransformType {
    public typealias Object = UIImage
    public typealias JSON = String
    
    func transformFromJSON(_ value: Any?) -> UIImage? {
        print("\n\nprofileurl: ", (value as! String))
        var urlcomps = URLComponents(string: (value as! String))!
        // let rull = URL(string: (value as! String))
        if (urlcomps.host == nil) {
            print("host nil!")
            urlcomps.scheme = "https"
            urlcomps.host = "demo.nbstage.com"
        }
        let req = Just.get(urlcomps.url!.absoluteString, params: ["uuid": UIDevice().uuid])
        
        if (req.ok) {
            return UIImage(data: req.content!)
        }
        return nil
    }
    
    func transformToJSON(_ value: UIImage?) -> String? {
        return nil
    }
}

class ISO8601FixedDateTransform: DateFormatterTransform {
    
    static let reusableISODateFormatter = DateFormatter(withFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", locale: "en_US_POSIX")
    
    public init() {
        super.init(dateFormatter: ISO8601FixedDateTransform.reusableISODateFormatter)
    }
}
