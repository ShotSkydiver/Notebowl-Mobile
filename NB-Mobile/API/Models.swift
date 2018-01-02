//
//  Models.swift
//  NB-Mobile
//
//  Created by Conner Owen on 9/28/17.
//  Copyright © 2017 NoteBowl. All rights reserved.
//

import Foundation

public struct Token: Codable {
    var token: String
    var uuid: String
    
    var query: [String: Any] {
        return ["token": token, "uuid": uuid]
    }
}


public protocol NBProtocol: Decodable {
    var url: URL { get }
    var createdAt: String { get }
    var updatedAt: String { get }
    
    static var routeName: String { get }
}



public struct User: NBProtocol {
    public var url: URL
    public var createdAt: String
    public var updatedAt: String
    
    var firstName: String
    var lastName: String
    var email: String
    var _university: String
    var profileUrl: String?
    var profileThumbUrl: String
    
    public var name: String { return (firstName + " " + lastName)}
    
    public var university: [University] { return (NBClient.shared.get(University.self, urlToGet: _university) as! [University]) }
    
    public static let routeName: String = "users"

}


public struct Course: NBProtocol {
    public var url: URL
    public var createdAt: String
    public var updatedAt: String
    
    var name: String
    var number: String
    var subject: String
    var units: Int
    var location: String?
    var description: String?
    var _term: String
    var _university: String
    
    public var courseCode: String { return (subject + " " + number)}
    
    public var term: [Term] { return (NBClient.shared.get(Term.self, urlToGet: _term) as! [Term]) }
    
    public var university: [University] { return (NBClient.shared.get(University.self, urlToGet: _university) as! [University]) }
    
    public static let routeName: String = "courses"

}

public struct Term: NBProtocol {
    public var url: URL
    public var createdAt: String
    public var updatedAt: String
    
    var title: String
    var termStart: String
    var termEnd: String
    var termAvailable: String
    var _university: String
    
    public static let routeName: String = "terms"
    
    public var university: [University] { return (NBClient.shared.get(University.self, urlToGet: _university) as! [University]) }
}


public struct University: NBProtocol {
    public var url: URL
    public var createdAt: String
    public var updatedAt: String
    
    var profileLogo: String?
    var defaultLogo: String
    var location: String
    var name: String
    var domain: String

    public static let routeName: String = "universities"

}
