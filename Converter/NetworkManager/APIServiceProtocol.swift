//
//  APIServiceProtocol.swift
//  Converter
//
//  Created by abhisheksingh03 on 23/04/22.
//

import Foundation
typealias CallbackVoid = () -> Void
typealias Callback<T> = (Result<T, ErrorResponse>) -> Void

protocol APIServiceProtocol {
    func getLatest(symbols: String, format: String, completion: @escaping (Callback<ConverterData?>))
    func getHistorical(date: String, symbols: String, format: String, completion: @escaping (Callback<ConverterData?>))
}
