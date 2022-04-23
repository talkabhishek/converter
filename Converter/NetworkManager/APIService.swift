//
//  APIService.swift
//  Converter
//
//  Created by abhisheksingh03 on 23/04/22.
//

import Foundation

enum APIService {
    case latest(symbols: String, format: String)
    case historical(date: String, symbols: String, format: String)
}
// Path
extension APIService {
    var path: String {
        switch self {
        case .latest:
            return "latest"
        case let .historical(date, _, _):
            return "\(date)"
        }
    }
}
// Method
extension APIService {
    var baseUrl: String {
        return Environment.baseURL
    }
    var access_key: String {
        return Environment.apiKey
    }
    var method: String {
        switch self {
        default:
            return "GET"
        }
    }
}
// Parameters
extension APIService {
    var queryParams: [String: String] {
        switch self {
        case let .latest(symbols, format):
            return ["access_key": access_key, "symbols": symbols, "format": format]
        case let .historical(_, symbols, format):
            return ["access_key": access_key, "symbols": symbols, "format": format]
        }
    }
    var bodyParams: Any? {
        switch self {
        default:
            return nil
        }
    }
}
