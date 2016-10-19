//
//  MeetingCamel.swift
//  EasyMapper
//
//  Created by Jacob Lubecki on 10/17/16.
//
//

import ObjectMapper

class MeetingCamel: Mappable {
    
    // MARK: - Properties
    
    var name: String?
    var date: Date?
    var description: String?
    var relatedLinks: [RelatedLink]?
    var registrationRequired: Bool?
    
    // MARK: - Init
    
    required init?(map: Map) { }
    
    
    // MARK: - Mappable
    
    func mapping(map: Map) {
        name                 <- map["name"]
        date                 <- (map["date"], DateTransform())
        description          <- map["description"]
        relatedLinks         <- map["related_links"]
        registrationRequired <- map["registration_required"]
    }
}
