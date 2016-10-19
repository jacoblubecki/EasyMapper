//
//  GroupSnake.swift
//  EasyMapper
//
//  Created by Jacob Lubecki on 10/17/16.
//
//

import Foundation

//
//  GroupSnake.swift
//  EasyMapper
//
//  Created by Jacob Lubecki on 10/17/16.
//
//

import ObjectMapper

class GroupSnake: Mappable {
    
    // MARK: - Properties
    
    var name: String?
    var id: Int?
    var budget: Double?
    var created: Date?
    var upcoming_meetings: [MeetingSnake]?
    var member_summary: MemberSummarySnake?
    
    
    // MARK: - Init
    
    required init?(map: Map) { }
    
    
    // MARK: - Mappable
    
    func mapping(map: Map) {
        name              <- map["name"]
        id                <- map["id"]
        budget            <- map["budget"]
        created           <- (map["created"], DateTransform())
        upcoming_meetings <- map["upcoming_meetings"]
        member_summary    <- map["member_summary"]
    }
}
