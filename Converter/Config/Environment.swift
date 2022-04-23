//
//  Environment.swift
//  Converter
//
//  Created by abhisheksingh03 on 23/04/22.
//

import Foundation
/*
 Open your Project Build Settings and search for “Swift Compiler – Custom Flags” … “Other Swift Flags”.
 Add “-DDEVELOPMENT” to the Debug section
 Add “-DPRODUCTION” to the Release section
 */
public enum Environment {
    enum Keys {
        static let apiKey = "API_KEY"
        static let baseUrl = "BASE_URL"
    }

    //Getting plist
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("plist file not found")
        }
        return dict
    }()

    static let baseURL: String = {
        guard let value = Environment.infoDictionary[Keys.baseUrl] as? String else {
            fatalError("Base URL not set in string")
        }
        return value
    }()

    static let apiKey: String = {
        guard let value = Environment.infoDictionary[Keys.apiKey] as? String else {
            fatalError("Base URL not set in string")
        }
        return value
    }()
}
