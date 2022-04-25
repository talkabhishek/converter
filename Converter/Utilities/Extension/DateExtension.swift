//
//  DateExtension.swift
//  Converter
//
//  Created by abhisheksingh03 on 25/04/22.
//

import Foundation

extension Date {
    static func -(lhs: Date, rhs: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: -rhs, to: lhs)!
    }
}
