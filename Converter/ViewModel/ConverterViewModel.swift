//
//  ConverterViewModel.swift
//  Converter
//
//  Created by abhisheksingh03 on 23/04/22.
//

import Foundation
import RxSwift
import RxCocoa

protocol HasConverterViewModel{
    var converterViewModel: ConverterViewModelConformable { get }
}

protocol ConverterViewModelConformable {
    var apiServiceManager: APIServiceProtocol { get }
    var latestValue: BehaviorRelay<ConverterData?> { get }
    var errorData: BehaviorRelay<ErrorData?> { get }
    var fromButtonValue: BehaviorRelay<String> { get }
    var toButtonValue: BehaviorRelay<String> { get }
    var fromFieldValue: BehaviorRelay<String?> { get }
    var toFieldValue: BehaviorRelay<String?> { get }
    var isSwapEnabled: BehaviorRelay<Bool> { get }
    var isDetailEnabled: BehaviorRelay<Bool> { get}
    var currencies: [String] { get }

    func getLatestValues()
    func swapSymbols()
    func setTo(fromValue: String?)
    func setFrom(toValue: String?)
}

struct ConverterViewModel: ConverterViewModelConformable {
    // MARK: - Instance variables
    var apiServiceManager: APIServiceProtocol
    var latestValue: BehaviorRelay<ConverterData?> = BehaviorRelay(value: nil)
    var errorData: BehaviorRelay<ErrorData?> = BehaviorRelay(value: nil)
    var fromButtonValue: BehaviorRelay<String> = BehaviorRelay(value: "From"~)
    var toButtonValue: BehaviorRelay<String> = BehaviorRelay(value: "To"~)
    var fromFieldValue: BehaviorRelay<String?> = BehaviorRelay(value: nil)
    var toFieldValue: BehaviorRelay<String?> = BehaviorRelay(value: nil)
    var isSwapEnabled: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var isDetailEnabled: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var currencies: [String] {
        guard let list = latestValue.value?.rates?.keys.sorted() else {
            return ["USD", "EGP", "INR"]
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
        let swapSymbol = fromButtonValue.value
        fromButtonValue.accept(toButtonValue.value)
        toButtonValue.accept(swapSymbol)
        let fromValue = fromFieldValue.value
        let toValue = toFieldValue.value
        fromFieldValue.accept(toValue)
        toFieldValue.accept(fromValue)
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
