//
//  ChartViewModel.swift
//  Converter
//
//  Created by abhisheksingh03 on 26/04/22.
//

import Foundation

struct ChartViewModel {
    let toSymbol: String
    let toValues: [Double]

    func getEquatableValue(_ value: Double) -> Double {
        guard let firstVal = toValues.first else {
            return 0
        }
        let result = 100 / firstVal * value
        let equatable = 100 + ((result - 100) * 100)
        return min(max(equatable, 0.0), 250.0)
    }
}
