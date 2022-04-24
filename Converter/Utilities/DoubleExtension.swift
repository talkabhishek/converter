//
//  DoubleExtension.swift
//  Converter
//
//  Created by abhisheksingh03 on 24/04/22.
//

import Foundation

extension Double {
    var twoFractionString: String {
        let locale: Locale = Locale.current
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.locale = locale
        let stringValue = numberFormatter.string(from: NSNumber(value: self))
        return stringValue ?? ""
    }
}
