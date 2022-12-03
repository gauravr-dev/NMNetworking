//
//  Response.swift
//  Created by Gaurav Rajput

import Foundation

typealias JSON = AnyObject

infix operator >>>=

public func >>>= <T,U>(optional : T?, f : (T) -> U?) -> U? {
    return flatten(x: optional.map(f))
}

public func flatten<T>(x: T??) -> T? {
    if let y = x { return y }
    return nil
}

public struct SCMError: Error {
    var errorMessage = "Something went wrong..." // default error code
    var description = ""
    var code = 0
    
    init(data:[String: Any]) {
        if let status = data["status"] as? [String: Any] {
            
            errorMessage = status["message"] as? String ?? ""
            description = status["type"] as? String ?? ""
            code = status["code"] as? Int ?? 0
        } else {
            
            errorMessage = data["message"] as? String ?? ""
            description = data["type"] as? String ?? ""
            code = data["code"] as? Int ?? 0
        }
    }
    
    init(error:HTTPError) {
        description = error.message()
    }
    
    init(error:Error) {
        description = error.localizedDescription
    }
    
    init(message: String) {
        description = message
        errorMessage = message
    }
    
    public var localizedDescription: String {
        "Error: \(description) \n\(code): \(errorMessage) "
    }
}
