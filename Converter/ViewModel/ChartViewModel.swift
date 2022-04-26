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
        return result
    }
}
