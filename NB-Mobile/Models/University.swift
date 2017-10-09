

struct University {
    var casAuthType: String
    var created: String
    var logo: String
    var domainName: String
    var identifier: String
    var itemType: String
    var location: String
    var uniName: String
    var uniPermalink: String
    var profileImage: String
    var resourceKey: String
    var currentState: String
    var updated: String
    var uniJsonURL: String
    var zipcode: Int
 
    enum CodingKeys: String, CodingKey {
        case uniName = "name"
        case uniPermalink = "permalink"
        case domainName = "domain"
        case uniJsonURL = "url"
        case identifier
        case casAuthType = "cas"
        case zipcode = "zip"
        case additionalInfo
    }
    
    enum AdditionalInfoKeys: String, CodingKey {
        case created = "createdAt"
        case updated = "updatedAt"
        case logo = "defaultLogo"
        case profileImage = "profileLogo"
        case currentState = "state"
        case location
        case itemType
        case resourceKey
    }
}

extension University: Decodable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        uniName = try values.decode(String.self, forKey: .uniName)
        uniPermalink = try values.decode(String.self, forKey: .uniPermalink)
        domainName = try values.decode(String.self, forKey: .domainName)
        uniJsonURL = try values.decode(String.self, forKey: .uniJsonURL)
        identifier = try values.decode(String.self, forKey: .identifier)
        casAuthType = try values.decode(String.self, forKey: .casAuthType)
        zipcode = try values.decode(Int.self, forKey: .zipcode)
        
        let additionalInfo = try values.nestedContainer(keyedBy: AdditionalInfoKeys.self, forKey: .additionalInfo)
        created = try additionalInfo.decode(String.self, forKey: .created)
        updated = try additionalInfo.decode(String.self, forKey: .updated)
        logo = try additionalInfo.decode(String.self, forKey: .logo)
        profileImage = try additionalInfo.decode(String.self, forKey: .profileImage)
        currentState = try additionalInfo.decode(String.self, forKey: .currentState)
        location = try additionalInfo.decode(String.self, forKey: .location)
        itemType = try additionalInfo.decode(String.self, forKey: .itemType)
        resourceKey = try additionalInfo.decode(String.self, forKey: .resourceKey)
        
        
    }
}

