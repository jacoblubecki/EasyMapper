//
//  MeetingSnake.swift
//  EasyMapper
//
//  Created by Jacob Lubecki on 10/17/16.
//
//

import ObjectMapper

class MeetingSnake: Mappable {
    
    // MARK: - Properties
    
    var name: String?
    var date: Date?
    var description: String?
    var related_links: [RelatedLink]?
    var registration_required: Bool?
    
    // MARK: - Init
    
    required init?(map: Map) { }
    
    
    // MARK: - Mappable
    
    func mapping(map: Map) {
        name                  <- map["name"]
        date                  <- (map["date"], DateTransform())
        description           <- map["description"]
        related_links         <- map["related_links"]
        registration_required <- map["registration_required"]
    }
}
