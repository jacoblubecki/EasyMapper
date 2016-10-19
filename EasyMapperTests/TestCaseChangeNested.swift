//
//  TestCaseChangeNested.swift
//  EasyMapper
//
//  Created by Jacob Lubecki on 10/19/16.
//
//

import XCTest
@testable import EasyMapper

class TestCaseChangeNested: XCTestCase {
    
    private var testJson: [String : AnyObject]!
    
    override func setUp() {
        super.setUp()
        
        // Fail every test if json can't be read.
        self.testJson = testJsonDictionary(forFileNamed: "snk_nested")
        
        guard self.testJson != nil else {
            XCTFail("Error reading test JSON file in.")
            return
        }
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testSimpleJsonToCamelClassString() {
        let classStrings = BaseFormatter.serialize(json: testJson, withRootClassName: "GroupCamel", shouldIncludeSubstructures: true, withCaseChange: .snakeToCamel)
        
        classStrings.forEach { (value) in
            print(value)
        }
        
        XCTAssert(!classStrings.isEmpty)
    }
}
