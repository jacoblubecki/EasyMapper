//
//  MemberSnake.swift
//  EasyMapper
//
//  Created by Jacob Lubecki on 10/17/16.
//
//

import ObjectMapper

class MemberSnake: Mappable {
    
    // MARK: - Properties
    
    var name: String?
    var age: Int?
    var hobbies: [String]?
    var favorite_color: String?
    var cats_owned: Int?
    var can_drive: Bool?
    var is_only_child: Bool?
    var books_read: Int?
    
    
    // MARK: - Init
    
    required init?(map: Map) { }
    
    
    // MARK: - Mappable
    
    func mapping(map: Map) {
        name            <- map["name"]
        age             <- map["age"]
        hobbies         <- map["hobbies"]
        favorite_color  <- map["favorite_color"]
        cats_owned      <- map["cats_owned"]
        can_drive       <- map["can_drive"]
        is_only_child   <- map["is_only_child"]
        books_read      <- map["books_read"]
    }
}
