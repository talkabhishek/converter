//
//  ConverterData.swift
//  Converter
//
//  Created by abhisheksingh03 on 23/04/22.
//

import Foundation
// MARK: - ConverterData
struct ConverterData: Codable {
    let success: Bool?
    let timestamp: TimeInterval?
    let historical: Bool?
    let base: String?
    let date: Date?
    let rates: [String: Double]?
    let error: ErrorData?
}
