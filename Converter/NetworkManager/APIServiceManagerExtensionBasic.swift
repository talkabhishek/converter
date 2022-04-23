//
//  APIServiceManagerExtension.swift
//  Converter
//
//  Created by abhisheksingh03 on 23/04/22.
//

import Foundation

extension APIServiceManager: APIServiceProtocol {
    func getLatest(symbols: String, format: String, completion: @escaping (Callback<ConverterData?>)) {
        getResponseSession(service: APIService.latest(symbols: symbols, format: format)
        ) { (response: Result<ConverterData?, ErrorResponse>) in
            completion(response)
        }
    }

    func getHistorical(date: String, symbols: String, format: String, completion: @escaping (Callback<ConverterData?>)) {
        getResponseSession(service: APIService.historical(date: date, symbols: symbols, format: format)
        ) { (response: Result<ConverterData?, ErrorResponse>) in
            completion(response)
        }
    }
}
