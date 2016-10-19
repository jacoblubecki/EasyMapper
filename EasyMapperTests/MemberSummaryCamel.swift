//
//  MemberSummaryCamel.swift
//  EasyMapper
//
//  Created by Jacob Lubecki on 10/17/16.
//
//

import ObjectMapper

class MemberSummaryCamel: Mappable {
    
    // MARK: - Properties
    
    var activeCount: Int?
    var totalCount: Int?
    var genders: Genders?
    var admins: [MemberCamel]?
    
    
    // MARK: - Init
    
    required init?(map: Map) { }
    
    
    // MARK: - Mappable
    
    func mapping(map: Map) {
        activeCount <- map["active_count"]
        totalCount  <- map["total_count"]
        genders     <- map["genders"]
        admins      <- map["admins"]
    }
}
