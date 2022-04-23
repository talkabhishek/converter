//
//  ErrorResponse.swift
//  Converter
//
//  Created by abhisheksingh03 on 23/04/22.
//

import Foundation

// MARK: - ErrorResponse
struct ErrorResponse: Codable, Error {
    let success: Bool?
    let error: ErrorData?

    init(error: Error) {
        if let errorResponse = error as? ErrorResponse {
            self = errorResponse
        } else {
            self.init(error: error.localizedDescription)
        }
    }

    init(error: String) {
        self.success = false
        self.error = ErrorData(code: nil, type: nil, info: error)
    }
}

// MARK: - Error
struct ErrorData: Codable {
    let code: Int?
    let type: String?
    let info: String?
}
