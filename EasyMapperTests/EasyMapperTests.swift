//
//  EasyMapperTests.swift
//  EasyMapperTests
//
//  Created by Jacob Lubecki on 10/11/16.
//
//

import Foundation
import XCTest
import Alamofire
import ObjectMapper
@testable import EasyMapper

class EasyMapperTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // MARK: - ClassFormatter Tests
    
    private struct ExpectedStrings {
        static let WeatherResponse = ["class WeatherResponse: Mappable {",
                                      "var location: String?",
                                      "var three_day_forecast: [Three_Day_Forecast]?",
                                      "required init?(map: Map) { }",
                                      "func mapping(map: Map) {",
                                      "location            <- map[\"location\"]",
                                      "three_day_forecast  <- map[\"three_day_forecast\"]"]
        
        static let ForecastResponse = ["class Forecast: Mappable {",
                                       "var day: String?",
                                       "var temperature: Int?",
                                       "var conditions: String?",
                                       "required init?(map: Map) { }",
                                       "func mapping(map: Map) {",
                                       "day          <- map[\"day\"]",
                                       "temperature  <- map[\"temperature\"]",
                                       "conditions   <- map[\"conditions\"]"]
        
        static let ForecastSubstructure = ["class Three_Day_Forecast: Mappable {",
                                           "var day: String?",
                                           "var temperature: Int?",
                                           "var conditions: String?",
                                           "required init?(map: Map) { }",
                                           "func mapping(map: Map) {",
                                           "day          <- map[\"day\"]",
                                           "temperature  <- map[\"temperature\"]",
                                           "conditions   <- map[\"conditions\"]"]
    }
    
    func testResponseObjectClassFormatting() {
        let URL = "https://raw.githubusercontent.com/tristanhimmelman/AlamofireObjectMapper/d8bb95982be8a11a2308e779bb9a9707ebe42ede/sample_json"
        let expectation = self.expectation(description: "\(URL)")
        
        Alamofire.request(URL, method: .get).responseConvertedToMappable(className: "WeatherResponse") { (response: DataResponse<String>) in
            expectation.fulfill()
            
            let objectString = response.result.value ?? ""
            
            for value in ExpectedStrings.WeatherResponse {
                XCTAssertTrue(objectString.contains(value))
            }
        }
        
        waitForExpectations(timeout: 10) { error in
            XCTAssertNil(error, "\(error)")
        }
    }
    
    
    func testResponseObjectClassFormattingWithKeypath() {
        let URL = "https://raw.githubusercontent.com/tristanhimmelman/AlamofireObjectMapper/2ee8f34d21e8febfdefb2b3a403f18a43818d70a/sample_keypath_json"
        let expectation = self.expectation(description: "\(URL)")
        
        Alamofire.request(URL, method: .get).responseConvertedToMappable(keyPath: "data", className: "WeatherResponse") { (response: DataResponse<String>) in
            expectation.fulfill()
            
            let objectString = response.result.value ?? ""
            
            for value in ExpectedStrings.WeatherResponse {
                XCTAssertTrue(objectString.contains(value))
            }
        }
        
        waitForExpectations(timeout: 10) { error in
            XCTAssertNil(error, "\(error)")
        }
    }
    
    
    func testResponseObjectClassFormattingWithNestedKeypath() {
        let URL = "https://raw.githubusercontent.com/tristanhimmelman/AlamofireObjectMapper/97231a04e6e4970612efcc0b7e0c125a83e3de6e/sample_keypath_json"
        let expectation = self.expectation(description: "\(URL)")
        
        Alamofire.request(URL, method: .get).responseConvertedToMappable(keyPath: "response.data", className: "WeatherResponse") { (response: DataResponse<String>) in
            expectation.fulfill()
            
            let objectString = response.result.value ?? ""
            
            for value in ExpectedStrings.WeatherResponse {
                XCTAssertTrue(objectString.contains(value))
            }
        }
        
        waitForExpectations(timeout: 10) { error in
            XCTAssertNil(error, "\(error)")
        }
    }
    
    func testResponseArrayClassFormatting() {
        let URL = "https://raw.githubusercontent.com/tristanhimmelman/AlamofireObjectMapper/f583be1121dbc5e9b0381b3017718a70c31054f7/sample_array_json"
        let expectation = self.expectation(description: "\(URL)")
        
        Alamofire.request(URL, method: .get).responseConvertedToMappable(className: "Forecast") { (response: DataResponse<String>) in
            expectation.fulfill()
            
            let objectString = response.result.value ?? ""
            
            for value in ExpectedStrings.ForecastResponse {
                XCTAssertTrue(objectString.contains(value))
            }
        }
        
        waitForExpectations(timeout: 10) { error in
            XCTAssertNil(error, "\(error)")
        }
    }
    
    
    func testResponseArrayClassFormattingWithKeypath() {
        let URL = "https://raw.githubusercontent.com/tristanhimmelman/AlamofireObjectMapper/2ee8f34d21e8febfdefb2b3a403f18a43818d70a/sample_json"
        let expectation = self.expectation(description: "\(URL)")
        
        Alamofire.request(URL, method: .get).responseConvertedToMappable(keyPath: "three_day_forecast", className: "Forecast") { (response: DataResponse<String>) in
            expectation.fulfill()
            
            let objectString = response.result.value ?? ""
            
            for value in ExpectedStrings.ForecastResponse {
                XCTAssertTrue(objectString.contains(value))
            }
        }
        
        waitForExpectations(timeout: 10) { error in
            XCTAssertNil(error, "\(error)")
        }
    }
    
    
    func testResponseArrayClassFormattingWithNestedKeypath() {
        
        // This is an example of a functional test case.
        let URL = "https://raw.githubusercontent.com/tristanhimmelman/AlamofireObjectMapper/97231a04e6e4970612efcc0b7e0c125a83e3de6e/sample_keypath_json"
        let expectation = self.expectation(description: "\(URL)")
        
        Alamofire.request(URL, method: .get).responseConvertedToMappable(keyPath: "response.data.three_day_forecast", className: "Forecast") { (response: DataResponse<String>) in
            expectation.fulfill()
            
            let objectString = response.result.value ?? ""
            
            for value in ExpectedStrings.ForecastResponse {
                XCTAssertTrue(objectString.contains(value))
            }
        }
        
        waitForExpectations(timeout: 10) { error in
            XCTAssertNil(error, "\(error)")
        }
    }
    
    
    func testResponseObjectClassFormattingWithNestedStructures() {
        
        // This is an example of a functional test case.
        let URL = "https://raw.githubusercontent.com/tristanhimmelman/AlamofireObjectMapper/d8bb95982be8a11a2308e779bb9a9707ebe42ede/sample_json"
        let expectation = self.expectation(description: "\(URL)")
        
        Alamofire.request(URL, method: .get).responseConvertedToMappable(className: "WeatherResponse", includeSubstructures: true) { (response: DataResponse<String>) in
            expectation.fulfill()
            
            let objectString = response.result.value ?? ""
            
            for value in ExpectedStrings.WeatherResponse {
                XCTAssertTrue(objectString.contains(value))
            }
            
            for value in ExpectedStrings.ForecastSubstructure {
                XCTAssertTrue(objectString.contains(value))
            }
        }
        
        waitForExpectations(timeout: 10) { error in
            XCTAssertNil(error, "\(error)")
        }
    }
    
}

class WeatherResponse: Mappable {
    var location: String?
    var threeDayForecast: [Forecast]?
    var date: Date?
    
    init(){}
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        location <- map["location"]
        threeDayForecast <- map["three_day_forecast"]
    }
}

class Forecast: Mappable {
    var day: String?
    var temperature: Int?
    var conditions: String?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        day <- map["day"]
        temperature <- map["temperature"]
        conditions <- map["conditions"]
    }
}
