//
//  ConverterViewModel.swift
//  Converter
//
//  Created by abhisheksingh03 on 23/04/22.
//

import Foundation
import RxSwift
import RxCocoa

struct ConverterViewModel {
    // MARK: - Instance variables
    let apiServiceManager: APIServiceProtocol
    let latestValue: BehaviorRelay<ConverterData?> = BehaviorRelay(value: nil)
    let errorData: BehaviorRelay<ErrorData?> = BehaviorRelay(value: nil)
    let fromButtonValue: BehaviorRelay<String> = BehaviorRelay(value: "From")
    let toButtonValue: BehaviorRelay<String> = BehaviorRelay(value: "To")
    let fromFieldValue: BehaviorRelay<String?> = BehaviorRelay(value: nil)
    let toFieldValue: BehaviorRelay<String?> = BehaviorRelay(value: nil)
    var currienties: [String] {
        guard let list = latestValue.value?.rates?.keys.sorted() else {
            return ["USD", "INR", "ALL", "BCG", "YUN"]
        }
        return list
    }

    init(apiServiceManager: APIServiceProtocol = APIServiceManager()) {
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
                } else {
                    self.errorData.accept(value.error)
                }
            case .failure(let error):
                self.errorData.accept(error.error)
            }
        }
    }

    func swapSymbols() {
        guard fromButtonValue.value != "From" &&
                toButtonValue.value != "To" else {
            return
        }
        let swapSymbol = fromButtonValue.value
        fromButtonValue.accept(toButtonValue.value)
        toButtonValue.accept(swapSymbol)
        let swapValue = fromFieldValue.value
        fromFieldValue.accept(toFieldValue.value)
        toFieldValue.accept(swapValue)
    }

    func setTo(fromValue: String?) {
        let toValue = convert(
            value: fromValue,
            fromSymbol: fromButtonValue.value,
            toSymbol: toButtonValue.value)
        toFieldValue.accept(toValue)
    }

    func setFrom(toValue: String?) {
        let fromValue = convert(
            value: toValue,
            fromSymbol: toButtonValue.value,
            toSymbol: fromButtonValue.value)
        fromFieldValue.accept(fromValue)
    }

    func convert(value: String?, fromSymbol: String, toSymbol: String) -> String? {
        guard let value = value,
              let doubleValue = Double(value),
              let rates = latestValue.value?.rates,
              let fromValue = rates[fromSymbol],
              let toValue = rates[toSymbol] else {
            return nil
        }
        let result = toValue / fromValue * doubleValue
        return result.twoFractionString
    }
}
