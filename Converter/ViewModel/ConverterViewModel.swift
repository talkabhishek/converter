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

    init(apiServiceManager: APIServiceProtocol = APIServiceManager()) {
        self.apiServiceManager = apiServiceManager
    }

    // MARK: - API Actions
    func getLatestValues() {
        Loader.shared.show()
        apiServiceManager.getLatest(symbols: "USD,AUD", format: "1") { (result) in
            Loader.shared.hide()
            switch result {
            case .success(let value):
                if value?.success == true {
                    self.latestValue.accept(value)
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
}
