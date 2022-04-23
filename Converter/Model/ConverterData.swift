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
    let timestamp: Int?
    let historical: Bool?
    let base, date: String?
    let rates: [String: Double]?
    let error: ErrorData?
}
