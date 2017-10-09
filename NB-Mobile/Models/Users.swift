//
//  Users.swift
//  NB-Mobile
//
//  Created by Conner Owen on 9/28/17.
//  Copyright © 2017 NoteBowl. All rights reserved.
//
import Foundation
import UIKit

struct Token: Codable {
    let uuid: String
    let token: String
}

struct User: Codable {
    var firstName: String
    var lastName: String
    var email: String
    var userJsonURL: URL
    var userAvatar: String?
    var userAvatarThumb: String?
    var university: URL
    var resourceKey: String
    var itemType: String
    var isUniversityAdmin: Bool
    var created: Date
    var updated: Date
    
    enum CodingKeys: String, CodingKey {
        case firstName
        case lastName
        case email
        case userJsonURL = "url"
        case userAvatar = "profileUrl"
        case userAvatarThumb = "profileThumbUrl"
        case university = "_university"
        case resourceKey
        case itemType
        case isUniversityAdmin
        case created = "createdAt"
        case updated = "updatedAt"
    }
    /*
    enum AdditionalInfoKeys: String, CodingKey {
        case userAvatarThumb = "profileThumbUrl"
        case university = "_university"
        case resourceKey
        case itemType
        case isUniversityAdmin
        case created = "createdAt"
        case updated = "updatedAt"
    }
    */
}

extension User {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        firstName = try values.decode(String.self, forKey: .firstName)
        lastName = try values.decode(String.self, forKey: .lastName)
        email = try values.decode(String.self, forKey: .email)
        userJsonURL = try values.decode(URL.self, forKey: .userJsonURL)
        userAvatar = try values.decode(String.self, forKey: .userAvatar)
        
        //let additionalInfo = try values.nestedContainer(keyedBy: AdditionalInfoKeys.self, forKey: .additionalInfo)
        userAvatarThumb = try values.decode(String.self, forKey: .userAvatarThumb)
        university = try values.decode(URL.self, forKey: .university)
        resourceKey = try values.decode(String.self, forKey: .resourceKey)
        itemType = try values.decode(String.self, forKey: .itemType)
        isUniversityAdmin = try values.decode(Bool.self, forKey: .isUniversityAdmin)
        created = try values.decode(Date.self, forKey: .created)
        updated = try values.decode(Date.self, forKey: .updated)
    }
    
    func encode(to encoder: Encoder) throws {
        var valuesEncode = try encoder.container(keyedBy: CodingKeys.self)
        try valuesEncode.encode(firstName, forKey: .firstName)
        try valuesEncode.encode(lastName, forKey: .lastName)
        try valuesEncode.encode(email, forKey: .email)
        try valuesEncode.encode(userJsonURL, forKey: .userJsonURL)
        try valuesEncode.encode(userAvatar, forKey: .userAvatar)
        
        //var additionalInfoEncode = try valuesEncode.nestedContainer(keyedBy: AdditionalInfoKeys.self, forKey: .additionalInfo)
        try valuesEncode.encode(userAvatarThumb, forKey: .userAvatarThumb)
        try valuesEncode.encode(university, forKey: .university)
        try valuesEncode.encode(resourceKey, forKey: .resourceKey)
        try valuesEncode.encode(itemType, forKey: .itemType)
        try valuesEncode.encode(isUniversityAdmin, forKey: .isUniversityAdmin)
        try valuesEncode.encode(created, forKey: .created)
        try valuesEncode.encode(updated, forKey: .updated)
    }
}

struct Users: Codable {
    let time: Double
    let code: Int
    let method: String
    let url: URL
    let count: Int
    let result: User
}
