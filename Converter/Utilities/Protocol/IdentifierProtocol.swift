//
//  IdentifierProtocol.swift
//  Converter
//
//  Created by abhisheksingh03 on 25/04/22.
//

import Foundation

protocol IdentifierProtocol {
    static func identifier() -> String
}

extension IdentifierProtocol {
    static func identifier() -> String {
        return String(describing: self)
    }
}
