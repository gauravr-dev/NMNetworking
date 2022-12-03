//
//  HTTPTask.swift
//  Created by Gaurav Rajput

import Foundation


public enum HTTPTask {

    case request(
        bodyParameters: Parameters? = [:],
        urlParameters: Parameters? = [:],
        additionalHeaders: HTTPHeaders? = [:]
    )

    case download(parameters: Parameters? = [:])

    case upload(data: Data, parameters: Parameters? = [:])

    case uploadFile(filePath: String, parameters: Parameters? = [:])
    
}
