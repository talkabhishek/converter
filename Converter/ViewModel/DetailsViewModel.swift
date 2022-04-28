//
//  DetailsViewModel.swift
//  Converter
//
//  Created by abhisheksingh03 on 25/04/22.
//

import Foundation
import RxSwift
import RxCocoa

protocol HasDetailsViewModel{
    var detailsViewModel: DetailsViewModelConformable { get }
}

protocol DetailsViewModelConformable {
    var fromSymbol: String { get }
    var toSymbol: String { get }
    var baseValue: Double { get }
    var apiServiceManager: APIServiceProtocol { get }
    var historicalValues: BehaviorRelay<[ConverterData]> { get }
    var latestValue: BehaviorRelay<ConverterData?> { get }
    var errorData: BehaviorRelay<ErrorData?> { get }
    var apiResponseCount: BehaviorRelay<Int> { get }
    var chartViewModel: BehaviorRelay<ChartViewModel?> { get }
    var historicalCellViewModels: BehaviorRelay<[HistoricalCellViewModel]> { get }
    var currenciesCellViewModels: BehaviorRelay<[CurrenciesCellViewModel]> { get }

    func getHistoricalValues(date: Date)
    func getLatestValues()
    func getLastThreeDaysData()
}

struct DetailsViewModel: DetailsViewModelConformable {
    let fromSymbol: String
    let toSymbol: String
    let baseValue: Double
    let apiServiceManager: APIServiceProtocol
    let historicalValues: BehaviorRelay<[ConverterData]> = BehaviorRelay(value: [])
    let latestValue: BehaviorRelay<ConverterData?> = BehaviorRelay(value: nil)
    let errorData: BehaviorRelay<ErrorData?> = BehaviorRelay(value: nil)
    var apiResponseCount: BehaviorRelay<Int> = BehaviorRelay(value: 0)
    let chartViewModel: BehaviorRelay<ChartViewModel?> = BehaviorRelay(value: nil)
    let historicalCellViewModels: BehaviorRelay<[HistoricalCellViewModel]> = BehaviorRelay(value: [])
    let currenciesCellViewModels: BehaviorRelay<[CurrenciesCellViewModel]> = BehaviorRelay(value: [])

    init(fromSymbol: String, toSymbol: String, baseValue: Double, apiServiceManager: APIServiceProtocol = APIServiceManager()) {
        self.fromSymbol = fromSymbol
        self.toSymbol = toSymbol
        self.baseValue = baseValue
        self.apiServiceManager = apiServiceManager
        self.chartViewModel.accept(ChartViewModel(toSymbol: toSymbol, toValues: []))
    }

    // MARK: - API Actions
    func getHistoricalValues(date: Date) {
        let dateStr = DateFormatter.yyyyMMdd.string(from: date)
        apiServiceManager.getHistorical(date: dateStr,
                                        symbols: "\(fromSymbol),\(toSymbol)",
                                        format: "1") { (result) in
            self.apiResponseCount.accept(self.apiResponseCount.value + 1)
            switch result {
            case .success(let value):
                if value.success == true {
                    let newValue =  self.historicalValues.value + [value]
                    self.historicalValues.accept(newValue)
                    if newValue.count > 2 {
                        self.updateChartViewModel()
                    }
                    self.updateHistoricalCellViewModels()
                } else {
                    self.errorData.accept(value.error)
                }
            case .failure(let error):
                self.errorData.accept(error.error)
            }
        }
    }

    func getLatestValues() {
        apiServiceManager.getLatest(symbols: "", format: "") { (result) in
            self.apiResponseCount.accept(self.apiResponseCount.value + 1)
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

    func getLastThreeDaysData() {
        let today = Date()
        getHistoricalValues(date: today)
        getHistoricalValues(date: today - 1)
        getHistoricalValues(date: today - 2)
    }

    func updateChartViewModel() {
        var convertedValue: [Double] = []
        for item in historicalValues.value {
            if let rates = item.rates,
               let fromValue = rates[fromSymbol],
               let toValue = rates[toSymbol] {
                let result = toValue / fromValue * baseValue
                convertedValue.append(result)
            } else {
                convertedValue.append(0.0)
            }
        }
        chartViewModel.accept(ChartViewModel(toSymbol: toSymbol, toValues: convertedValue))
    }

    func updateHistoricalCellViewModels() {
        let list = historicalValues.value.map { (converterData) -> HistoricalCellViewModel in
            return HistoricalCellViewModel(fromSymbol: fromSymbol, toSymbol: toSymbol, baseValue: baseValue, converterData: converterData)
        }
        historicalCellViewModels.accept(list)
    }

    func updateCurrenciesCellViewModels() {
        guard let converterData = latestValue.value else {
            return
        }
        var top12List = ["EGP", "CAD", "USD", "CHF", "EUR", "GBP", "JOD", "OMR", "KWD", "KYD", "BHD", "INR", "CNY"]
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
