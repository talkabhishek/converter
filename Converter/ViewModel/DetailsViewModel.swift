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
    let apiServiceManager: APIServiceProtocol
    let historicalValue: BehaviorRelay<ConverterData?> = BehaviorRelay(value: nil)
    let errorData: BehaviorRelay<ErrorData?> = BehaviorRelay(value: nil)
    
    init(fromSymbol: String, toSymbol: String, baseValue: Double, apiServiceManager: APIServiceProtocol = APIServiceManager()) {
        self.fromSymbol = fromSymbol
        self.toSymbol = toSymbol
        self.baseValue = baseValue
        self.apiServiceManager = apiServiceManager
    }

    // MARK: - API Actions
    func getHistoricalValues() {
        Loader.shared.show()
        apiServiceManager.getHistorical(date: "2022-04-20", symbols: "USD,AUD", format: "1") { (result) in
            Loader.shared.hide()
            switch result {
            case .success(let value):
                if value?.success == true {
                    self.historicalValue.accept(value)
                } else {
                    self.errorData.accept(value?.error)
                }
            case .failure(let error):
                self.errorData.accept(error.error)
            }
        }
    }
}
