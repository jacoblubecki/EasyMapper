//
//  Genders.swift
//  EasyMapper
//
//  Created by Jacob Lubecki on 10/17/16.
//
//

import ObjectMapper

class Genders: Mappable {
    
    // MARK: - Properties
    
    var male: Int?
    var female: Int?
    var other: Int?
    
    
    // MARK: - Init
    
    required init?(map: Map) { }
    
    
    // MARK: - Mappable
    
    func mapping(map: Map) {
        male   <- map["male"]
        female <- map["female"]
        other  <- map["other"]
    }
}
