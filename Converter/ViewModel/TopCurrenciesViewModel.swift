//
//  TopCurrenciesViewModel.swift
//  Converter
//
//  Created by abhisheksingh03 on 25/04/22.
//

import Foundation
import RxSwift
import RxCocoa

struct TopCurrenciesViewModel {
    let fromSymbol: String
    let toSymbol: String
    let baseValue: Double
    let apiServiceManager: APIServiceProtocol
    let latestValue: BehaviorRelay<ConverterData?> = BehaviorRelay(value: nil)
    let errorData: BehaviorRelay<ErrorData?> = BehaviorRelay(value: nil)
    let currenciesCellViewModels: BehaviorRelay<[CurrenciesCellViewModel]> = BehaviorRelay(value: [])

    init(fromSymbol: String, toSymbol: String, baseValue: Double, apiServiceManager: APIServiceProtocol = APIServiceManager()) {
        self.fromSymbol = fromSymbol
        self.toSymbol = toSymbol
        self.baseValue = baseValue
        self.apiServiceManager = apiServiceManager
    }

    // MARK: - API Actions
    func getLatestValues() {
        Loader.shared.show()
        apiServiceManager.getLatest(symbols: "", format: "") { (result) in
            Loader.shared.hide()
            switch result {
            case .success(let value):
                if value.success == true {
                    self.latestValue.accept(value)
                    self.updateCurrenciesCellViewModels()
                } else {
                    self.errorData.accept(value.error)
                }
            case .failure(let error):
                self.errorData.accept(error.error)
            }
        }
    }

    func updateCurrenciesCellViewModels() {
        guard let converterData = latestValue.value else {
            return
        }
        var top12List = ["CAD", "USD", "CHF", "EUR", "GBP", "JOD", "OMR", "KWD", "KYD", "BHD", "INR", "CNY"]
        if let fromIndex = top12List.firstIndex(of: fromSymbol) {
            top12List.remove(at: fromIndex)
        }
        if let toIndex = top12List.firstIndex(of: toSymbol) {
            top12List.remove(at: toIndex)
        }
        let top10List = Array(top12List.prefix(10))
        let list = top10List.map { (symbol) -> CurrenciesCellViewModel in
            return CurrenciesCellViewModel(fromSymbol: fromSymbol, toSymbol: symbol, baseValue: baseValue, converterData: converterData)
        }
        currenciesCellViewModels.accept(list)
    }
}
