//
//  StaticValues.swift
//  Notebowl Mobile
//
//  Created by Conner Owen on 9/11/18.
//  Copyright © 2018 Notebowl. All rights reserved.
//

import Foundation
import UIKit

enum Environment: String {
    case Production = "platform.notebowl.com"
    case Local = "demo.notebowl.xyz"
}

public var baseUrl: String {
    return Environment.Production.rawValue
}

public var socketUrl: String { return "https://\(baseUrl)/socket.io/" }

public struct Gradients {
    var startColor: UIColor!
    var endColor: UIColor!
    var name: String!

    init(startColor: UIColor, endColor: UIColor, name: String) {
        self.startColor = startColor
        self.endColor = endColor
        self.name = name
    }

    static func getDefaultGradients() -> [Gradients]? {
        var gradientColors: [Gradients] = []

        if let path = Bundle.main.path(forResource: "default_gradients", ofType: "json") {
            do {
                let data = try NSData(contentsOfFile: path, options: NSData.ReadingOptions.mappedIfSafe)
                if let parsedData = try? JSONSerialization.jsonObject(with: data as Data) as! [[String: Any]] {
                    parsedData.forEach({ (eachData) in
                        let name = eachData["name"] as! String
                        var colors = eachData["colors"] as! [String]

                        let startColor = UIColor(hexString: colors[0] as String)
                        let endColor = UIColor(hexString: colors[1] as String)
                        let gradientColor = Gradients(startColor: startColor, endColor: endColor, name: name)
                        gradientColors.append(gradientColor)
                    })
                    return gradientColors
                }
            } catch {
                return nil
            }
        } else {
            return nil
        }
        return gradientColors
    }

    static func gradientColorWithName(_ from: [Gradients], name: String) -> Gradients? {
        let matchedGradientColors = from.filter { $0.name == name }
        if matchedGradientColors.count > 0 {
            let gradientColor = matchedGradientColors[0]
            if let _ = gradientColor.startColor, let _ = gradientColor.endColor {
                return gradientColor
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
}

