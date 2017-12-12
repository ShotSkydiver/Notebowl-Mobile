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


public protocol NBItem {
    static var routeName: String { get }
}

public class NBCodable: Decodable {
    var url: URL
    var createdAt: String
    var updatedAt: String
    
    private enum CodingKeys: String, CodingKey {
        case url
        case createdAt
        case updatedAt

    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.url = try container.decode(URL.self, forKey: .url)
        self.createdAt = try container.decode(String.self, forKey: .createdAt)
        self.updatedAt = try container.decode(String.self, forKey: .updatedAt)
        
        
    }
}

public class User: NBCodable, NBItem {
    
    var firstName: String
    var lastName: String
    var email: String
    var university: URL
    var userAvatar: URL?
    
    public var name: String { return (firstName + " " + lastName)}
    
    public static let routeName: String = "users"
    
    private enum CodingKeys: String, CodingKey {
        case firstName
        case lastName
        case email
        case university = "_university"
        case userAvatar = "profileUrl"
        
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.firstName = try container.decode(String.self, forKey: .firstName)
        self.lastName = try container.decode(String.self, forKey: .lastName)
        self.email = try container.decode(String.self, forKey: .email)
        self.university = try container.decode(URL.self, forKey: .university)
        self.userAvatar = try container.decode(URL.self, forKey: .userAvatar)
        
        try super.init(from: decoder)
    }
    
}


public class Course: NBCodable, NBItem {
    
    var courseName: String
    var courseNumber: String
    var courseSubject: String
    var units: Int
    var courseLocation: String?
    var courseDescription: String?
    var term: URL
    var university: URL
    
    public static let routeName: String = "courses"
    
    private enum CodingKeys: String, CodingKey {
        case courseName = "name"
        case courseNumber = "number"
        case courseSubject = "subject"
        case units
        case courseLocation = "location"
        case courseDescription = "description"
        case term = "_term"
        case university = "_university"

    }
    
    required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.courseName = try values.decode(String.self, forKey: .courseName)
        self.courseNumber = try values.decode(String.self, forKey: .courseNumber)
        self.courseSubject = try values.decode(String.self, forKey: .courseSubject)
        self.units = try values.decode(Int.self, forKey: .units)
        self.courseLocation = try values.decodeIfPresent(String.self, forKey: .courseLocation)
        self.courseDescription = try values.decodeIfPresent(String.self, forKey: .courseDescription)
        self.term = try values.decode(URL.self, forKey: .term)
        self.university = try values.decode(URL.self, forKey: .university)

        try super.init(from: decoder)
    }
}
