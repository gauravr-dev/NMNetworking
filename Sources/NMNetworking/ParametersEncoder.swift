//
//  ParametersEncoder.swift
//
//  Created by gaurav.rajput 

import Foundation

protocol ParameterEncoder {
    static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws
}

struct URLParameterEncoder: ParameterEncoder {
    // in case of GET request use this
    static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
        guard let url = urlRequest.url else {
            throw HTTPError.missingURL
        }
        
        // GET
        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) {
            urlComponents.queryItems = [URLQueryItem]()
            for (key, value) in parameters {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                urlComponents.queryItems?.append(queryItem)
                // addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)?.replacingOccurrences(of: ",", with: "%2C")
            }
            urlRequest.url = urlComponents.url
        }
    }
}

// in case of POST request use this
struct JSONParameterEncoder: ParameterEncoder {
    
    static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            urlRequest.httpBody = jsonData
        } catch {
            throw HTTPError.encoding
        }
    }
}

// in case of POST request use this
struct FormParameterEncoder: ParameterEncoder {
    
    static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
        do {
            
            guard let url = urlRequest.url else {
                throw HTTPError.missingURL
            }
            
            if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !parameters.isEmpty {
                urlComponents.queryItems = [URLQueryItem]()
                for (key, value) in parameters {
                    let queryItem = URLQueryItem(name: key, value: "\(value)")
                    urlComponents.queryItems?.append(queryItem)
                }
                urlRequest.httpBody = urlComponents.query?.data(using: .utf8)
            }
        } catch {
            throw HTTPError.encoding
        }
    }
}

