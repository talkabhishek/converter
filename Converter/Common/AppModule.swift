//
//  MainModule.swift
//  Converter
//
//  Created by abhisheksingh03 on 26/04/22.
//

import UIKit

class ConverterModule: HasConverterViewModel {
    var converterViewModel: ConverterViewModelConformable {
        return ConverterViewModel()
    }
}

class DetailsModule: HasDetailsViewModel {
    let fromSymbol: String
    let toSymbol: String
    let baseValue: Double

    init(fromSymbol: String, toSymbol: String, baseValue: Double) {
        self.fromSymbol = fromSymbol
        self.toSymbol = toSymbol
        self.baseValue = baseValue
    }

    var detailsViewModel: DetailsViewModelConformable {
        return DetailsViewModel(fromSymbol: fromSymbol, toSymbol: toSymbol, baseValue: baseValue)
    }
}
