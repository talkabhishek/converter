//
//  CurrenciesCellViewModelTest.swift
//  ConverterTests
//
//  Created by abhisheksingh03 on 26/04/22.
//

import XCTest
@testable import Converter

class CurrenciesCellViewModelTest: XCTestCase {
    var fromSymbol: String! = "USD"
    var toSymbol: String! = "INR"
    var baseValue: Double! = 1
    var converterData: ConverterData!
    var viewModel: CurrenciesCellViewModel!

    override func setUpWithError() throws {
        guard let response = Utilities.readJSON("Latest", type: ConverterData.self) else {
            return
        }
        converterData = response
        viewModel = CurrenciesCellViewModel(fromSymbol: fromSymbol, toSymbol: toSymbol, baseValue: baseValue, converterData: converterData)
    }

    override func tearDownWithError() throws {
        viewModel = nil
        fromSymbol = nil
        toSymbol = nil
        baseValue = nil
        converterData = nil
    }

    func testConvertedValue() throws {
        XCTAssertEqual(viewModel.convertedValue, "76.51")
        guard let response = Utilities.readJSON("Historical", type: ConverterData.self) else {
            return
        }
        converterData = response
        viewModel = CurrenciesCellViewModel(fromSymbol: fromSymbol, toSymbol: toSymbol, baseValue: baseValue, converterData: converterData)
        XCTAssertEqual(viewModel.convertedValue, "0.00")
    }

}
