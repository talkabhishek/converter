//
//  ConverterViewModel.swift
//  Converter
//
//  Created by abhisheksingh03 on 23/04/22.
//

import Foundation
import RxSwift
import RxCocoa

struct ConverterViewModel: AlertProtocol {
    // MARK: - Instance variables
    //let sourceView: SourceViewType?
    let apiServiceManager: APIServiceProtocol
    let latestValue: BehaviorRelay<ConverterData?> = BehaviorRelay(value: nil)
    let historicalValue: BehaviorRelay<ConverterData?> = BehaviorRelay(value: nil)
    let currienties: BehaviorRelay<[String]> = BehaviorRelay(value: ["USD", "INR", "ALL", "BCG", "YUN"])
    let fromButtonValue: BehaviorRelay<String> = BehaviorRelay(value: "From")
    let toButtonValue: BehaviorRelay<String> = BehaviorRelay(value: "To")
    let fromFieldValue: BehaviorRelay<String?> = BehaviorRelay(value: nil)
    let toFieldValue: BehaviorRelay<String?> = BehaviorRelay(value: nil)

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
                if value?.success == true {
                    self.latestValue.accept(value)
                    guard let list = value?.rates?.keys.sorted() else {
                        return
                    }
                    self.currienties.accept(list)
                } else {
                    presentAlert(title: nil, message: value?.error?.info)
                }
            case .failure(let error):
                presentAlert(title: nil, message: error.error?.info)
            }
        }
    }

    func getHistoricalValues() {
        Loader.shared.show()
        apiServiceManager.getHistorical(date: "2022-04-20", symbols: "USD,AUD", format: "1") { (result) in
            Loader.shared.hide()
            switch result {
            case .success(let value):
                if value?.success == true {
                    self.historicalValue.accept(value)
                } else {
                    presentAlert(title: nil, message: value?.error?.info)
                }
            case .failure(let error):
                presentAlert(title: nil, message: error.error?.info)
            }
        }
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

    func convert(value: String?, fromSymbol: String, toSymbol: String) -> String {
        guard let value = value,
              let doubleValue = Double(value),
              let rates = latestValue.value?.rates,
              let fromValue = rates[fromSymbol],
              let toValue = rates[toSymbol] else {
            return ""
        }
        let result = toValue / fromValue * doubleValue
        return result.twoFractionString
    }
}
