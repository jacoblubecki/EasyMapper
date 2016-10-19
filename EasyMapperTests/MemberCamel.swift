//
//  MemberCamel.swift
//  EasyMapper
//
//  Created by Jacob Lubecki on 10/17/16.
//
//

import ObjectMapper

class MemberCamel: Mappable {
    
    // MARK: - Properties
    
    var name: String?
    var age: Int?
    var hobbies: [String]?
    var favoriteColor: String?
    var catsOwned: Int?
    var canDrive: Bool?
    var isOnlyChild: Bool?
    var booksRead: Int?
    
    
    // MARK: - Init
    
    required init?(map: Map) { }
    
    
    // MARK: - Mappable
    
    func mapping(map: Map) {
        name          <- map["name"]
        age           <- map["age"]
        hobbies       <- map["hobbies"]
        favoriteColor <- map["favorite_color"]
        catsOwned     <- map["cats_owned"]
        canDrive      <- map["can_drive"]
        isOnlyChild   <- map["is_only_child"]
        booksRead     <- map["books_read"]
    }
}
