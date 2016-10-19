//
//  ClassFormatter.swift
//  EasyMapper
//
//  Created by Jacob Lubecki on 10/14/16.
//
//

import Foundation

public protocol ClassFormatter {
    static var sort: (((key: String, value: AnyObject), (key: String, value: AnyObject)) -> Bool)? { get }
    static func variableName(forKey key: String) -> String
    static func typeString(forKey key: String, andValue value: AnyObject) -> String
    static func classNameForSubstructure(withKey key: String) -> String
    static func date(fromString string: String) -> Date?
}

public enum CaseChange {
    case camelToSnake
    case snakeToCamel
    case none
    case custom(transform: (_ varName: String) -> String)
    
    func transform(_ varName: String) -> String {
        switch self {
        case .snakeToCamel:
            return self.convertFromSnakeToCamel(varName)
            
        case .camelToSnake:
            return self.convertFromCamelToSnake(varName)
            
        case .none:
            return varName
            
        case let .custom(transform):
            return transform(varName)
        }
    }
    
    func convertFromCamelToSnake(_ varName: String) -> String {
        return varName.replacingOccurrences(of: "([a-z])([A-Z])", with: "$1_$2", options: .regularExpression).lowercased()
    }
    
    func convertFromSnakeToCamel(_ varName: String) -> String {
        let items = varName.components(separatedBy: "_")
        var camelCase = ""
        items.enumerated().forEach { (offset: Int, element: String) in
            camelCase += ((offset == 0) ? element : element.capitalized)
        }
        return camelCase
    }
}

extension ClassFormatter {
    
    public static func serialize(json rootJson: [String : AnyObject], withRootClassName className: String, shouldIncludeSubstructures includeSubstructures: Bool, withCaseChange caseChange: CaseChange = .none) -> [String] {
        let allSubstructures: [(key: String, value: [String : AnyObject])] = includeSubstructures ? findSubstructures(withRootKey: className, inJson: rootJson) : [ (className, rootJson) ]
        
        let out: [String] = allSubstructures.map { (key, value) -> String in
            return formatJsonAsMappableObjectClass(named: key, forJson: value, withCaseChange: caseChange)
        }
        
        return out
    }
    
    /**
     Formats JSON content as a String representing a Mappable Swift class file.
     
     - parameter className: The name for the class that will be generated.
     - parameter json: The JSON that should define the class to be created.
     - parameter sort: How to sort the JSON. Response will not sort JSON if nil.
     
     - returns: The formatted class file as a String.
     */
    public static func formatJsonAsMappableObjectClass(named className: String, forJson json: [String : AnyObject], withCaseChange caseChange: CaseChange = .none) -> String {
        let longestKey = longestKeyLength(inJson: json)
        let formattedJson = sortedVariables(forJson: json)
        
        var out: String = "\n\n" // Add space to begin relevant logging on a new line
        
        out += "import ObjectMapper\n\nclass \(className): Mappable {\n\n" // Declare class name and implement Mappable
        out += "// MARK: - Properties\n\n".indent(1)
        
        for (key, value) in formattedJson {
            out += "var \(caseChange.transform(variableName(forKey: key))): \(typeString(forKey: key, andValue: value))?\n".indent(1)
        }
        
        out += "\n\n"
        out += "// MARK: - Init\n\n".indent(1)
        out += "required init?(map: Map) { }\n\n\n".indent(1) // end init
        
        out += "// MARK: - Mappable\n\n".indent(1)
        out += "func mapping(map: Map) {\n".indent(1)
        
        for (key, _) in formattedJson {
            let varName = caseChange.transform(variableName(forKey: key))
            out += "\(varName + Self.spaces(longestKey - varName.characters.count)) <- map[\"\(key)\"]\n".indent(2)
        }
        
        out += "}\n".indent(1)
        out += "}"
        
        return out
    }
    
    public static func sortedVariables(forJson json: [String : AnyObject]) -> [(key: String, value: AnyObject)] {
        var formattedJson: [(key: String, value: AnyObject)]
        
        if let sort = sort {
            formattedJson = json.sorted(by: sort)
        } else {
            formattedJson = json.map({ (pair: (key: String, value: AnyObject)) -> (key: String, value: AnyObject) in
                return (key: pair.key, value: pair.value)
            })
        }
        
        return formattedJson
    }
    
    public static func findSubstructures(withRootKey rootKey: String, inJson json: [String : AnyObject]) -> [(key: String, value: [String : AnyObject])] {
        var structures: [(key: String, value: [String : AnyObject])] = [ (rootKey, json) ]
        
        let substructures = json.filter { (pair: (key: String, value: AnyObject)) -> Bool in
            return pair.value is [String : AnyObject] || pair.value is [[String : AnyObject]]
            }.map { (pair: (key: String, value: AnyObject)) -> (key: String, value: [String : AnyObject]) in
                let formattedKey = Self.classNameForSubstructure(withKey: pair.key)
                
                if pair.value is [String : AnyObject] {
                    return (formattedKey, pair.value as! [String : AnyObject])
                } else if let jsonArray = pair.value as? [[String : AnyObject]], jsonArray.count > 0 {
                    return (formattedKey, jsonArray[0])
                } else {
                    return (formattedKey, [:])
                }
        }
        
        for structure in substructures {
            structures.append(contentsOf: findSubstructures(withRootKey: structure.key, inJson: structure.value))
        }
        
        var existingKeySets: Set<Set<String>> = Set()
        structures = structures.filter({ (pair: (key: String, value: [String : AnyObject])) -> Bool in
            let keyArr: [String] = pair.value.flatMap { $0.key }
            let currentKeySet = Set(keyArr)
            
            if !existingKeySets.contains(currentKeySet) {
                existingKeySets.insert(currentKeySet)
                return true
            }
            
            return false
        })
        
        return structures
    }
    
    /**
     Helper method to format the outputted class file String.
     
     - parameter numSpaces: The number of spaces to return
     
     - returns: A String consisting of the specified number of spaces
     */
    static func spaces(_ numSpaces: Int) -> String {
        
        var spaces = ""
        
        for _ in 0 ..< numSpaces {
            spaces += " "
        }
        
        return spaces
    }
    
    /**
     Helper method to format the outputted class file String.
     
     - parameter json: The JSON that will be checked for key lengths.
     
     - returns: The length of the longest key in the JSON after formatting as a variable name.
     */
    static func longestKeyLength(inJson json: [String : AnyObject]) -> Int {
        var longestCount = 0
        
        for (key, _) in json {
            let newCount = variableName(forKey: key).characters.count
            
            if newCount > longestCount {
                longestCount = newCount
            }
        }
        
        return longestCount
    }
}

public class BaseFormatter: ClassFormatter {
    
    public static let sort: (((key: String, value: AnyObject), (key: String, value: AnyObject)) -> Bool)? = nil
    
    public static func variableName(forKey key: String) -> String {
        return key
    }
    
    public static func classNameForSubstructure(withKey key: String) -> String {
        // Capitalize each word. Separate into alphanumeric components. Join all alphanumeric components.
        return key.capitalized.components(separatedBy: CharacterSet.alphanumerics.inverted).joined()
    }
    
    public static func typeString(forKey key: String, andValue value: AnyObject) -> String {
        switch value {
        case is String:
            if let _ = date(fromString: (value as! String)) {
                return "Date"
            } else {
                return "String"
            }
            
        case is Int:
            return "Int"
            
        case is Bool:
            return "Bool"
            
        case is Double:
            return "Double"
            
        case is [String]:
            if let arr = value as? [String], let _ = date(fromString: arr[0]) {
                return "[Date]"
            } else {
                return "[String]"
            }
            
        case is [Int]:
            return "[Int]"
            
        case is [Bool]:
            return "[Bool]"
            
        case is [Double]:
            return "[Double]"
            
        case is [String : AnyObject]:
            return classNameForSubstructure(withKey: key)
            
        case is [[String : AnyObject]]:
            return "[\(classNameForSubstructure(withKey: key))]"
            
        case is [AnyObject]:
            return "[AnyObject]"
            
        case is [[AnyObject]]:
            return "[[AnyObject]]"
            
        case is Date:
            return "Date"
            
        default:
            return "AnyObject"
        }
    }
    
    public static func date(fromString string: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'hh:mm:ss.SSSZ"
        dateFormatter.isLenient = true
        
        return dateFormatter.date(from: string)
    }
}

extension String {
    
    /**
     Helper method to format the outputted class file String.
     
     - parameter size: The number of tabs that should be appended to the beginning of the String.
     
     - returns: A String with the specified number of tabs appended to the beginning of the String.
     */
    internal func indent(_ size: Int) -> String {
        var out: String = ""
        
        for _ in 0 ... size {
            out += "\t"
        }
        
        return out + self
    }
}
