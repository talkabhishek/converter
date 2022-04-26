//
//  DetailsViewModelTest.swift
//  ConverterTests
//
//  Created by abhisheksingh03 on 26/04/22.
//

import XCTest
@testable import Converter

class DetailsViewModelTest: XCTestCase {
    var fromSymbol: String! = "USD"
    var toSymbol: String! = "INR"
    var baseValue: Double! = 1
    var apiServiceManager: APIServiceProtocolMock!
    var viewModel: DetailsViewModel!

    override func setUpWithError() throws {
        apiServiceManager = APIServiceProtocolMock()
        viewModel = DetailsViewModel(fromSymbol: fromSymbol, toSymbol: toSymbol, baseValue: baseValue, apiServiceManager: apiServiceManager)
    }

    override func tearDownWithError() throws {
        viewModel = nil
        fromSymbol = nil
        toSymbol = nil
        baseValue = nil
        apiServiceManager = nil
    }

    func testGetHistoricalValues() throws {
        guard let response = Utilities.readJSON("Historical", type: ConverterData.self) else {
            return
        }
        apiServiceManager.callbackResult = .success(response)
        viewModel.getHistoricalValues(date: Date())
        XCTAssertEqual(viewModel.historicalValues.value.count, 1)
        XCTAssertNil(viewModel.errorData.value)
    }

    func testGetHistoricalValues2() throws {
        guard let response = Utilities.readJSON("Error", type: ConverterData.self) else {
            return
        }
        apiServiceManager.callbackResult = .success(response)
        viewModel.getHistoricalValues(date: Date())
        XCTAssertEqual(viewModel.historicalValues.value.count, 0)
        XCTAssertNotNil(viewModel.errorData.value)
    }

    func testGetHistoricalValues3() throws {
        guard let response = Utilities.readJSON("Error", type: ErrorResponse.self) else {
            return
        }
        apiServiceManager.callbackResult = .failure(response)
        viewModel.getHistoricalValues(date: Date())
        XCTAssertEqual(viewModel.historicalValues.value.count, 0)
        XCTAssertNotNil(viewModel.errorData.value)
    }

    func testGetLastThreeDaysData() throws {
        guard let response = Utilities.readJSON("Historical", type: ConverterData.self) else {
            return
        }
        apiServiceManager.callbackResult = .success(response)
        viewModel.getLastThreeDaysData()
        XCTAssertEqual(viewModel.historicalValues.value.count, 3)
        XCTAssertNil(viewModel.errorData.value)
    }

    func testGetLatestValues() throws {
        guard let response = Utilities.readJSON("Latest", type: ConverterData.self) else {
            return
        }
        apiServiceManager.callbackResult = .success(response)
        viewModel.getLatestValues()
        XCTAssertNotNil(viewModel.latestValue.value)
        XCTAssertNil(viewModel.errorData.value)
    }

    func testGetLatestValues2() throws {
        guard let response = Utilities.readJSON("Error", type: ConverterData.self) else {
            return
        }
        apiServiceManager.callbackResult = .success(response)
        viewModel.getLatestValues()
        XCTAssertNil(viewModel.latestValue.value)
        XCTAssertNotNil(viewModel.errorData.value)
    }

    func testGetLatestValues3() throws {
        guard let response = Utilities.readJSON("Error", type: ErrorResponse.self) else {
            return
        }
        apiServiceManager.callbackResult = .failure(response)
        viewModel.getLatestValues()
        XCTAssertNil(viewModel.latestValue.value)
        XCTAssertNotNil(viewModel.errorData.value)
    }

    func testUpdateChartViewModel() throws {
        guard let response = Utilities.readJSON("Latest", type: ConverterData.self) else {
            return
        }
        viewModel.historicalValues.accept([response])
        viewModel.updateChartViewModel()
        XCTAssertNotNil(viewModel.chartViewModel.value)
    }

    func testUpdateHistoricalCellViewModels() throws {
        guard let response = Utilities.readJSON("Historical", type: ConverterData.self) else {
            return
        }
        viewModel.historicalValues.accept([response])
        viewModel.updateHistoricalCellViewModels()
        XCTAssertEqual(viewModel.historicalCellViewModels.value.count, 1)
    }

    func testUpdateCurrenciesCellViewModels() throws {
        viewModel.updateCurrenciesCellViewModels()
        XCTAssertEqual(viewModel.currenciesCellViewModels.value.count, 0)
        guard let response = Utilities.readJSON("Latest", type: ConverterData.self) else {
            return
        }
        viewModel.latestValue.accept(response)
        viewModel.updateCurrenciesCellViewModels()
        XCTAssertEqual(viewModel.currenciesCellViewModels.value.count, 10)
    }
}
