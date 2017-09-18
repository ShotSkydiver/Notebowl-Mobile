import SwiftyJSON

struct University {
    let defaultLogo: String?
    let profileLogo: String?
    let state: String?
    let domain: String?
    let identifier: String?
    let location: String?
    let name: String?
    let permalink: String?
    let zip: String?
    let resourceKey: String?
    let itemType: String?
    let url: String?
    let createdAt: String?
    let updatedAt: String?
    
    init(json: JSON) throws {
        defaultLogo     = json["defaultLogo"].string
        profileLogo     = json["profileLogo"].string
        state           = json["state"].string
        domain          = json["domain"].string
        identifier      = json["identifier"].string
        location        = json["location"].string
        name            = json["name"].string
        permalink       = json["permalink"].string
        zip             = json["zip"].string
        resourceKey     = json["resourceKey"].string
        itemType        = json["itemType"].string
        url             = json["url"].string
        createdAt       = json["createdAt"].string
        updatedAt       = json["updatedAt"].string
        
    }
}

