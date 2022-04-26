//
//  HistoricalCellViewModelTest.swift
//  ConverterTests
//
//  Created by abhisheksingh03 on 26/04/22.
//

import XCTest
@testable import Converter

class HistoricalCellViewModelTest: XCTestCase {
    var fromSymbol: String! = "USD"
    var toSymbol: String! = "INR"
    var baseValue: Double! = 1
    var converterData: ConverterData!
    var viewModel: HistoricalCellViewModel!

    override func setUpWithError() throws {
        guard let response = Utilities.readJSON("Historical", type: ConverterData.self) else {
            return
        }
        converterData = response
        viewModel = HistoricalCellViewModel(fromSymbol: fromSymbol, toSymbol: toSymbol, baseValue: baseValue, converterData: converterData)
    }

    override func tearDownWithError() throws {
        viewModel = nil
        fromSymbol = nil
        toSymbol = nil
        baseValue = nil
        converterData = nil
    }

    func testConvertedValue() throws {
        XCTAssertEqual(viewModel.convertedValue, "0.00")
        guard let response = Utilities.readJSON("Latest", type: ConverterData.self) else {
            return
        }
        converterData = response
        viewModel = HistoricalCellViewModel(fromSymbol: fromSymbol, toSymbol: toSymbol, baseValue: baseValue, converterData: converterData)
        XCTAssertEqual(viewModel.convertedValue, "76.51")
    }

    func testValueDate() throws {
        XCTAssertEqual(viewModel.valueDate, "20 April 2022")
        let converterData = ConverterData(success: nil, timestamp: nil, historical: nil, base: nil, date: nil, rates: nil, error: nil)
        viewModel = HistoricalCellViewModel(fromSymbol: fromSymbol, toSymbol: toSymbol, baseValue: baseValue, converterData: converterData)
        XCTAssertNil(viewModel.valueDate)
    }
}
