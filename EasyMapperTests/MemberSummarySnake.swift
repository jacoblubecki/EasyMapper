//
//  MemberSummarySnake.swift
//  EasyMapper
//
//  Created by Jacob Lubecki on 10/17/16.
//
//

import ObjectMapper

class MemberSummarySnake: Mappable {
    
    // MARK: - Properties
    
    var active_count: Int?
    var total_count: Int?
    var genders: Genders?
    var admins: [MemberSnake]?
    
    
    // MARK: - Init
    
    required init?(map: Map) { }
    
    
    // MARK: - Mappable
    
    func mapping(map: Map) {
        active_count <- map["active_count"]
        total_count  <- map["total_count"]
        genders      <- map["genders"]
        admins       <- map["admins"]
    }
}
