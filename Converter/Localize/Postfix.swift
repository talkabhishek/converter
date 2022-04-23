//
//  Postfix.swift
//  Converter
//
//  Created by abhisheksingh03 on 23/04/22.
//

import Foundation

postfix operator ~
postfix func ~ (string: String) -> String {
    return NSLocalizedString(string, comment: "")
}
