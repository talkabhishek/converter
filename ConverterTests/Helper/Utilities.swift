//
//  Utilities.swift
//  ConverterTests
//
//  Created by abhisheksingh03 on 26/04/22.

import Foundation

struct Utilities {
    // Codable helper
    static func readJSON<T: Decodable>(_ fileName: String, type: T.Type) -> T? {
        let testBundle = Bundle(for: ConverterTests.self)
        if let url = testBundle.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(DateFormatter.yyyyMMdd)
                let jsonData = try decoder.decode(T.self, from: data)
                return jsonData
            } catch {
                print("error: \(error)")
                return nil
            }
        }
        return nil
    }

}

extension DateFormatter {

    static let yyyyMMdd: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.locale = Locale.current
        return formatter
    }()

    static let ddMMMMyyyy: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.locale = Locale.current
        return formatter
    }()

}
