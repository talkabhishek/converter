//
//  APIServiceManagerProtocolMock.swift
//  ConverterTests
//
//  Created by abhisheksingh03 on 26/04/22.
//

import Foundation
@testable import Converter

class APIServiceProtocolMock: APIServiceProtocol {
    var callbackResult: Result<Any, ErrorResponse>?
    private func getResponse<T: Decodable>(completion: @escaping(Callback<T>)) {
        switch callbackResult {
        case .success(let value):
            if let value = value as? T {
                completion(.success(value))
            } else {
                completion(.failure(ErrorResponse(error: "Type Mismatch")))
            }
        case .failure(let error):
            completion(.failure(error))
        case .none:
            completion(.failure(ErrorResponse(error: "No Data")))
        }
    }

    func getLatest(symbols: String, format: String, completion: @escaping (Callback<ConverterData>)) {
        getResponse(completion: completion)
    }

    func getHistorical(date: String, symbols: String, format: String, completion: @escaping (Callback<ConverterData>)) {
        getResponse(completion: completion)
    }
}
