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
    
    var profileUrl: String?
    var profileThumbUrl: String
    var _university: String
    
    public var name: String { return (firstName + " " + lastName)}
    
    public var university: [University] { return (NBClient.shared.get(University.self, urlToGet: _university) as! [University]) }

    
    public static let routeName: String = "users"

}


public class Course: NBProtocol {
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
    
    var term: [Term] { get {return NBClient.shared.get(Term.self, urlToGet: _term) as! [Term]} }
    
    public var university: [University] { return (NBClient.shared.get(University.self, urlToGet: _university) as! [University]) }
    
    public var assignments: [Assignment] {
        return NBClient.shared.get(Assignment.self, filters: "[\"_parent:IN:\(url.absoluteString)\"]") as! [Assignment]
    }
    
    public var currentGradePercent: String {
        var maximumPoints = 0.0, userPoints = 0.0
        
        for assignment in assignments {
            maximumPoints += Double(exactly: assignment.points)!
            userPoints += assignment.currentGrade
        }
        
        var finalGrade = (userPoints/maximumPoints)
        finalGrade = (finalGrade*100.0)
        return String(format: "%.1f%%", finalGrade)
    }
    
    public var mostRecentGrade: String {
        var allAssignments: String = ""
        for assignment in assignments {
            allAssignments = (allAssignments + assignment.url.absoluteString + ",")
        }
        
        let mostRecent: [Grade] = (NBClient.shared.get(Grade.self, filters: "[\"_parent:IN:\(allAssignments)\"]", sortBy: "updatedAt:desc", limit: "1") as! [Grade])
        let formatter: DateFormatter = .iso8061
        let updatedDate = formatter.date(from: mostRecent.first!.updatedAt)
        return (updatedDate?.relativelyFormatted)!
        
    }

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

public class Assignment: NBProtocol {
    public var url: URL
    public var createdAt: String
    public var updatedAt: String
    
    var description: String?
    var availableDate: String
    var dueDate: String
    var title: String
    var points: Int
    var _parent: String
    
    public static let routeName: String = "assignments"

    public var parent: [Course] { return (NBClient.shared.get(Course.self, urlToGet: _parent) as! [Course]) }
    
    public var currentGrade: Double {
        let userGrade: [Grade] = (NBClient.shared.get(Grade.self, filters: "[\"_user:IN:\(NBClient.shared.currentUser!.url.absoluteString)\",\"_parent:IN:\(url.absoluteString)\"]") as! [Grade])
        return Double(exactly: userGrade.first!.grade)!
    }
    
}

public struct Grade: NBProtocol {
    public var url: URL
    public var createdAt: String
    public var updatedAt: String
    
    var grade: Int
    var _creator: String
    var _parent: String
    var _user: String
    
    public static let routeName: String = "grades"
}
