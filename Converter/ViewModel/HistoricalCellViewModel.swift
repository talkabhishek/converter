//
//  HistoricalListCellViewModel.swift
//  Converter
//
//  Created by abhisheksingh03 on 25/04/22.
//

import Foundation

struct HistoricalCellViewModel {
    let fromSymbol: String
    let toSymbol: String
    let baseValue: Double
    let converterData: ConverterData
    var convertedValue: String? {
        guard let rates = converterData.rates,
              let fromValue = rates[fromSymbol],
              let toValue = rates[toSymbol] else {
            return "0.00"
        }
        let result = toValue / fromValue * baseValue
        return result.twoFractionString
    }
    var valueDate: String? {
        guard let date = converterData.date else {
            return nil
        }
        return DateFormatter.ddMMMMyyyy.string(from: date)
    }
    
    init(fromSymbol: String, toSymbol: String, baseValue: Double, converterData: ConverterData) {
        self.fromSymbol = fromSymbol
        self.toSymbol = toSymbol
        self.baseValue = baseValue
        self.converterData = converterData
    }

}
