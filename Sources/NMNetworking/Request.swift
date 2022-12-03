//
//  Request.swift
//  Created by Gaurav Rajput


import Foundation

let TIMEOUT_INTERVAL: TimeInterval = 180

public protocol Request {
    
    associatedtype Response = Any
    
    var baseURL: URL? { get }
    
    var path: String { get }
    
    var httpMethod: HTTPMethod { get }
    
    var task: HTTPTask { get }
    
    var headers: HTTPHeaders { get }
        
    var contentType: ContentType { get }
    
    func build() throws -> URLRequest
    
}

extension Request {
   public func build() throws -> URLRequest {
        // check if url is configured properly or not
        guard let baseURL = self.baseURL else {
            throw HTTPError.missingURL
        }
        
        var request = URLRequest(url: baseURL.appendingPathComponent(self.path), cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: TIMEOUT_INTERVAL)
        if self.path.isEmpty {
            request = URLRequest(url: baseURL, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: TIMEOUT_INTERVAL)
        }
                
        request.httpMethod = self.httpMethod.rawValue
        setHeaders(headers: headers, request: &request)
        
        do {
            switch task {
                case .request(let bodyParameters, let urlParameters, let additionalHeaders):
                setHeaders(headers: additionalHeaders, request: &request)
                    
                try configureParameters(bodyParameters: bodyParameters, urlParameters: urlParameters, request: &request)
                case .download(let parameters):
                try configureParameters(bodyParameters: parameters, urlParameters: [:], request: &request)
            default:
                print("case not handled")
            }
        } catch {
            throw error
        }
        
        // set content type for this request
        setContentType(urlRequest: &request)
        
        return request
    }
    
    private func setContentType(urlRequest: inout URLRequest) {
        urlRequest.setValue(contentType.rawValue, forHTTPHeaderField: "Content-Type")
    }
    
    private func configureParameters(bodyParameters: Parameters?, urlParameters: Parameters?, request: inout URLRequest) throws {
        do {
            if let bodyParameters = bodyParameters, bodyParameters.count > 0 {
                if contentType == .json {
                    try JSONParameterEncoder.encode(urlRequest: &request, with: bodyParameters)
                } else {
                    try FormParameterEncoder.encode(urlRequest: &request, with: bodyParameters)
                }
            }
            if let urlParameters = urlParameters, urlParameters.count > 0 {
                try URLParameterEncoder.encode(urlRequest: &request, with: urlParameters)
            }
        } catch {
            throw error
        }
    }
    
    private func setHeaders(headers: HTTPHeaders?, request: inout URLRequest ) {
        guard let headers = headers else {
            return
        }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
}


