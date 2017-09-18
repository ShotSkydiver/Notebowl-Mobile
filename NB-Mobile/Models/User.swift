import SwiftyJSON

struct User {
    let email: String?
    let firstName: String?
    let lastName: String?
    let url: String?
    let profileUrl: String?
    let profileThumbUrl: String?
    let university: String?
    let resourceKey: String?
    let itemType: String?
    let isUniversityAdmin: Bool?
    let createdAt: String?
    let updatedAt: String?
    
    init(json: JSON) throws {
        email           = json["email"].string
        firstName       = json["firstName"].string
        lastName        = json["lastName"].string
        url             = json["url"].string
        profileUrl      = json["profileUrl"].string
        profileThumbUrl = json["profileThumbUrl"].string
        university      = json["_university"].string
        resourceKey     = json["resourceKey"].string
        itemType        = json["itemType"].string
        isUniversityAdmin  = json["isUniversityAdmin"].bool
        createdAt       = json["createdAt"].string
        updatedAt       = json["updatedAt"].string
        
    }
}


