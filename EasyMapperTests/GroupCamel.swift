//
//  GroupCamel.swift
//  EasyMapper
//
//  Created by Jacob Lubecki on 10/17/16.
//
//

import ObjectMapper

class GroupCamel: Mappable {
    
    // MARK: - Properties
    
    var name: String?
    var id: Int?
    var budget: Double?
    var created: Date?
    var upcomingMeetings: [MeetingCamel]?
    var memberSummary: MemberSummaryCamel?
    
    
    // MARK: - Init
    
    required init?(map: Map) { }
    
    
    // MARK: - Mappable
    
    func mapping(map: Map) {
        name             <- map["name"]
        id               <- map["id"]
        budget           <- map["budget"]
        created          <- (map["created"], DateTransform())
        upcomingMeetings <- map["upcoming_meetings"]
        memberSummary    <- map["member_summary"]
    }
}
