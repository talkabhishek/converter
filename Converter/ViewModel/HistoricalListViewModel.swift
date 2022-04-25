//
//  HistoricalListViewModel.swift
//  Converter
//
//  Created by abhisheksingh03 on 25/04/22.
//

import Foundation
import RxSwift
import RxCocoa

struct HistoricalListViewModel {
    let fromSymbol: String
    let toSymbol: String
    let baseValue: Double
    let apiServiceManager: APIServiceProtocol
    let historicalValues: BehaviorRelay<[ConverterData]> = BehaviorRelay(value: [])
    let errorData: BehaviorRelay<ErrorData?> = BehaviorRelay(value: nil)
    let historicalCellViewModels: BehaviorRelay<[HistoricalCellViewModel]> = BehaviorRelay(value: [])

    init(fromSymbol: String, toSymbol: String, baseValue: Double, apiServiceManager: APIServiceProtocol = APIServiceManager()) {
        self.fromSymbol = fromSymbol
        self.toSymbol = toSymbol
        self.baseValue = baseValue
        self.apiServiceManager = apiServiceManager
    }

    // MARK: - API Actions
    func getHistoricalValues(date: Date) {
        let dateStr = DateFormatter.yyyyMMdd.string(from: date)
        Loader.shared.show()
        apiServiceManager.getHistorical(date: dateStr,
                                        symbols: "\(fromSymbol),\(toSymbol)",
                                        format: "1") { (result) in
            Loader.shared.hide()
            switch result {
            case .success(let value):
                if value.success == true {
                    let newValue =  self.historicalValues.value + [value]
                    self.historicalValues.accept(newValue)
                    self.updateHistoricalCellViewModels()
                } else {
                    self.errorData.accept(value.error)
                }
            case .failure(let error):
                self.errorData.accept(error.error)
            }
        }
    }

    func getLastThreeDaysData() {
        let today = Date()
        getHistoricalValues(date: today)
        getHistoricalValues(date: today - 1)
        getHistoricalValues(date: today - 2)
    }

    func updateHistoricalCellViewModels() {
        let list = historicalValues.value.map { (converterData) -> HistoricalCellViewModel in
            return HistoricalCellViewModel(fromSymbol: fromSymbol, toSymbol: toSymbol, baseValue: baseValue, converterData: converterData)
        }
        historicalCellViewModels.accept(list)
    }
}
