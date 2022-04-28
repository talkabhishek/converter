//
//  ConverterViewModelTest.swift
//  ConverterTests
//
//  Created by abhisheksingh03 on 26/04/22.
//

import XCTest
@testable import Converter

class ConverterViewModelTest: XCTestCase {
    var apiServiceManager: APIServiceProtocolMock!
    var viewModel: ConverterViewModel!

    override func setUpWithError() throws {
        apiServiceManager = APIServiceProtocolMock()
        viewModel = ConverterViewModel(apiServiceManager: apiServiceManager)
    }

    override func tearDownWithError() throws {
        viewModel = nil
        apiServiceManager = nil
    }

    func testCurrencies() throws {
        XCTAssertEqual(viewModel.currencies.count, 2)
        guard let response = Utilities.readJSON("Latest", type: ConverterData.self) else {
            return
        }
        viewModel.latestValue.accept(response)
        XCTAssertEqual(viewModel.currencies.count, 168)
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

    func testSwapSymbols() throws {
        viewModel.swapSymbols()
        viewModel.fromButtonValue.accept("USD")
        viewModel.toButtonValue.accept("INR")
        viewModel.swapSymbols()
        XCTAssertEqual(viewModel.fromButtonValue.value, "INR")
        XCTAssertEqual(viewModel.toButtonValue.value, "USD")
    }

    func testSetTo() throws {
        guard let response = Utilities.readJSON("Latest", type: ConverterData.self) else {
            return
        }
        viewModel.latestValue.accept(response)
        viewModel.fromButtonValue.accept("EUR")
        viewModel.toButtonValue.accept("INR")
        viewModel.setTo(fromValue: "1")
        XCTAssertEqual(viewModel.toFieldValue.value, "81.94")
    }

    func testSetFrom() throws {
        guard let response = Utilities.readJSON("Latest", type: ConverterData.self) else {
            return
        }
        viewModel.latestValue.accept(response)
        viewModel.fromButtonValue.accept("INR")
        viewModel.toButtonValue.accept("EUR")
        viewModel.setFrom(toValue: "1")
        XCTAssertEqual(viewModel.fromFieldValue.value, "81.94")
    }

}
