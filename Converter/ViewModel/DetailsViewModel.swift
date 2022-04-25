//
//  DetailsViewModel.swift
//  Converter
//
//  Created by abhisheksingh03 on 25/04/22.
//

import Foundation
import RxSwift
import RxCocoa

struct DetailsViewModel {
    let fromSymbol: String
    let toSymbol: String
    let baseValue: Double
    
    init(fromSymbol: String, toSymbol: String, baseValue: Double) {
        self.fromSymbol = fromSymbol
        self.toSymbol = toSymbol
        self.baseValue = baseValue
    }

}
