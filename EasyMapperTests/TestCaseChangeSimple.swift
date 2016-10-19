//
//  TestSnakeSimple.swift
//  EasyMapper
//
//  Created by Jacob Lubecki on 10/17/16.
//
//

import XCTest
@testable import EasyMapper

class TestCaseChangeSimple: XCTestCase {
    
    let snakeMemberClassName = "MemberSnake"
    let camelMemberClassName = "MemberCamel"
    
    func snakeSimpleString() -> String {
        return "\n\nimport ObjectMapper\n\nclass \(snakeMemberClassName): Mappable {\n\n\t\t// MARK: - Properties\n\n\t\tvar name: String?\n\t\tvar hobbies: [String]?\n\t\tvar books_read: Int?\n\t\tvar age: Int?\n\t\tvar can_drive: Int?\n\t\tvar cats_owned: Int?\n\t\tvar favorite_color: String?\n\t\tvar is_only_child: Int?\n\n\n\t\t// MARK: - Init\n\n\t\trequired init?(map: Map) { }\n\n\n\t\t// MARK: - Mappable\n\n\t\tfunc mapping(map: Map) {\n\t\t\tname           <- map[\"name\"]\n\t\t\thobbies        <- map[\"hobbies\"]\n\t\t\tbooks_read     <- map[\"books_read\"]\n\t\t\tage            <- map[\"age\"]\n\t\t\tcan_drive      <- map[\"can_drive\"]\n\t\t\tcats_owned     <- map[\"cats_owned\"]\n\t\t\tfavorite_color <- map[\"favorite_color\"]\n\t\t\tis_only_child  <- map[\"is_only_child\"]\n\t\t}\n}"
    }
    
    func camelSimpleString() -> String {
        return "\n\nimport ObjectMapper\n\nclass \(camelMemberClassName): Mappable {\n\n\t\t// MARK: - Properties\n\n\t\tvar name: String?\n\t\tvar hobbies: [String]?\n\t\tvar booksRead: Int?\n\t\tvar age: Int?\n\t\tvar canDrive: Int?\n\t\tvar catsOwned: Int?\n\t\tvar favoriteColor: String?\n\t\tvar isOnlyChild: Int?\n\n\n\t\t// MARK: - Init\n\n\t\trequired init?(map: Map) { }\n\n\n\t\t// MARK: - Mappable\n\n\t\tfunc mapping(map: Map) {\n\t\t\tname           <- map[\"name\"]\n\t\t\thobbies        <- map[\"hobbies\"]\n\t\t\tbooksRead      <- map[\"books_read\"]\n\t\t\tage            <- map[\"age\"]\n\t\t\tcanDrive       <- map[\"can_drive\"]\n\t\t\tcatsOwned      <- map[\"cats_owned\"]\n\t\t\tfavoriteColor  <- map[\"favorite_color\"]\n\t\t\tisOnlyChild    <- map[\"is_only_child\"]\n\t\t}\n}"
    }
    
    private var testJson: [String : AnyObject]!
    
    override func setUp() {
        super.setUp()
        
        // Fail every test if json can't be read.
        self.testJson = testJsonDictionary(forFileNamed: "snk_simple")
        
        guard self.testJson != nil else {
            XCTFail("Error reading test JSON file in.")
            return
        }
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testSimpleJsonToSnakeClassString() {
        let classString = BaseFormatter.formatJsonAsMappableObjectClass(named: snakeMemberClassName, forJson: testJson)
        
        XCTAssertEqual(classString, snakeSimpleString())
    }
    
    func testSimpleJsonToCamelClassString() {
        let classString = BaseFormatter.formatJsonAsMappableObjectClass(named: camelMemberClassName, forJson: testJson, withCaseChange: .snakeToCamel)
        
        XCTAssertEqual(classString, camelSimpleString())
    }
    
    func testSimpleJsonToCamelToSnakeClassString() {
        let classString = BaseFormatter.formatJsonAsMappableObjectClass(named: snakeMemberClassName, forJson: testJson, withCaseChange: .custom { input in
            CaseChange.camelToSnake.transform(CaseChange.snakeToCamel.transform(input))
            })
        
        XCTAssertEqual(classString, snakeSimpleString())
    }
}
