//
//  EasyMapper.swift
//  EasyMapper
//
//  Created by Jacob Lubecki on 10/14/16.
//
//

import Foundation
import Alamofire
import ObjectMapper
import AlamofireObjectMapper

extension DataRequest {
    
    enum ErrorCode: Int {
        case noData = 1
        case dataSerializationFailed = 2
    }
    
    internal static func newError(_ code: ErrorCode, failureReason: String) -> NSError {
        let errorDomain = "com.jlubecki.easymapper.error"
        
        let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
        let returnError = NSError(domain: errorDomain, code: code.rawValue, userInfo: userInfo)
        
        return returnError
    }
    
    
    /**
     Prints the JSON response from the request.
     
     - returns: The request.
     */
    public func responseDebugPrint() -> Self {
        return responseJSON() { response in
            
            if let  JSON: AnyObject = response.result.value as AnyObject?,
                let JSONData = try? JSONSerialization.data(withJSONObject: JSON, options: .prettyPrinted),
                let prettyString = NSString(data: JSONData, encoding: String.Encoding.utf8.rawValue) {
                debugPrint(prettyString)
            } else if let error = response.result.error {
                debugPrint("Error Debug Print: \(error.localizedDescription)")
            }
        }
    }
    
    public static func EasyMapperClassStringSerializer(keyPath: String?, className: String, includeSubstructures: Bool, formatter: ClassFormatter.Type) -> DataResponseSerializer<[String]> {
        return DataResponseSerializer { request, response, data, error in
            guard error == nil else {
                return .failure(error!)
            }
            
            guard let _ = data else {
                let failureReason = "Data could not be serialized. Input data was nil."
                let error = newError(.dataSerializationFailed, failureReason: failureReason)
                return .failure(error)
            }
            
            let jsonResponseSerializer = DataRequest.jsonResponseSerializer(options: .allowFragments)
            let result = jsonResponseSerializer.serializeResponse(request, response, data, error)
            
            let JSONToMap: Any?
            if let keyPath = keyPath, keyPath.isEmpty == false {
                JSONToMap = (result.value as AnyObject?)?.value(forKeyPath: keyPath)
            } else {
                JSONToMap = result.value
            }
            var JSONDictionary: [String : AnyObject]?
            
            if let json = JSONToMap as? [String : AnyObject] {
                JSONDictionary = json
            } else if let jsonArray = JSONToMap as? [[String : AnyObject]] , jsonArray.count > 0 {
                JSONDictionary  = jsonArray[0]
            }
            
            if let JSONDictionary = JSONDictionary {
                let output = formatter.serialize(json: JSONDictionary, withRootClassName: className, shouldIncludeSubstructures: includeSubstructures)
                return .success(output)
            }
            
            let failureReason = "Could not convert response to dictionary ([String : AnyObject])."
            let error = newError(.dataSerializationFailed, failureReason: failureReason)
            return .failure(error)
        }
        
    }
    
    
    /**
     Prints the JSON content of the response as a Mappable swift class.
     
     - parameter queue:             The queue on which the completion handler is dispatched.
     - parameter className:         The name for the class that will be generated.
     - parameter formatter:         The class that handles the formatting of the outputted text.
     - parameter keyPath:           The key path for the JSON that should define the class to be created.
     - parameter completionHandler: A closure to be executed once the request has finished.
     
     - returns: The request.
     */
    @discardableResult
    public func responseConvertedToMappable(queue: DispatchQueue? = nil, keyPath: String? = nil, className: String, includeSubstructures: Bool = false, formatter: ClassFormatter.Type = BaseFormatter.self, completionHandler: @escaping (DataResponse<[String]>) -> Void) -> Self {
        let serializer = DataRequest.EasyMapperClassStringSerializer(keyPath: keyPath, className: className, includeSubstructures: includeSubstructures, formatter: formatter)
        return response(queue: queue, responseSerializer: serializer, completionHandler: completionHandler)
    }
    
    @discardableResult
    public func responsePrintedAsMappable(queue: DispatchQueue? = nil, keyPath: String? = nil, className: String, includeSubstructures: Bool = false, formatter: ClassFormatter.Type = BaseFormatter.self) -> Self {
        return responseConvertedToMappable(keyPath: keyPath, className: className, includeSubstructures: includeSubstructures, completionHandler: { (response) in
            print(response.result.value ?? "No value.")
        })
    }
}
