//
//  Course.swift
//  NB-Mobile
//
//  Created by Conner Owen on 9/29/17.
//  Copyright © 2017 NoteBowl. All rights reserved.
//



// let beers = try decoder.decode([[String:Beer]].self, from: data)
import Foundation

struct Course: Codable {
    let courseName: String
    let courseNumber: String // ultimately should be converted to an int
    let courseSubject: String
    let courseDescription: String?
    let permalink: String
    let numOfUnits: Int
    let location: String?
    let courseStartDate: String // Should be Date
    let usesWeightedGrades: Bool
    let usesDropLowestGrade: Bool
    let courseTermURL: URL // Should be URL
    let universityURL: URL
    let resourceKey: String
    let itemType: String // is this necessary to define?
    let courseJsonURL: URL
    
    enum CodingKeys: String, CodingKey {
        case courseName = "name"
        case courseNumber = "number"
        case courseSubject = "subject"
        case courseDescription = "description"
        case permalink
        case numOfUnits = "units"
        case location
        case courseStartDate = "availableDate"
        case usesWeightedGrades = "useWeightedGrades"
        case usesDropLowestGrade = "useDropLowest"
        case courseTermURL = "_term"
        case universityURL = "_university"
        case resourceKey
        case itemType
        case courseJsonURL = "url"
    }
}

struct Courses: Codable {
    let time: Double
    let code: Int
    let method: String
    let url: URL
    let count: Int
    let result: [Course]
}
/*
extension Courses {
    init(from decoder: Decoder) throws {
        
    }
}
*/
