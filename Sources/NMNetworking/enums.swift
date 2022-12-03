//
//  enums.swift
//
//  Created by Gaurav Rajput


import Foundation

/// Encodes any encodable to a URLQueryItem list
enum URLQueryItemEncoder {
    static func encode<T: Encodable>(_ encodable: T) throws -> [URLQueryItem] {
        let parametersData = try JSONEncoder().encode(encodable)
        let parameters = try JSONDecoder().decode([String: HTTPParameter].self, from: parametersData)
        return parameters.map { URLQueryItem(name: $0, value: $1.description) }
    }
}

enum NetworkEnvironment {
    case qa
    case production
    case dev
    case staging
}

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

public enum ContentType: String {
    case form = "application/x-www-form-urlencoded"
    case json = "application/json"
    case imagePNG = "image/png"
    case imageJPG = "image/jpeg"
    case file = "application/txt"
    case data = "application/octet-stream"
}

