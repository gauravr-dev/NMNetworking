//
//  Types.swift
//  Created by Gaurav Rajput

import Foundation

public typealias HTTPHeaders = [String: String]

public typealias Parameters = [String: Any]

public typealias ResultCallback = (Result<Any, HTTPError>) -> Void
