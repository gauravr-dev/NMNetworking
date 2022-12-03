//
//  HTTPError.swift
//  Created by Gaurav Rajput

import Foundation

public enum HTTPError: Error, Equatable {
    case missingURL
    case encoding
    case decoding
    case authentication
    case badRequest
    case outdated
    case failed
    case server(message: String)
    case authorizationFail
    
    func message() -> String {
        "Error occurred."
    }
}
