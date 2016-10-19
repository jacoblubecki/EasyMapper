//
//  RelatedLink.swift
//  EasyMapper
//
//  Created by Jacob Lubecki on 10/17/16.
//
//

import ObjectMapper

class RelatedLink: Mappable {
    
    // MARK: - Properties
    
    var name: String?
    var url: String?
    
    
    // MARK: - Init
    
    required init?(map: Map) { }
    
    
    // MARK: - Mappable
    
    func mapping(map: Map) {
        name <- map["name"]
        url  <- map["url"]
    }
}
