//
//  ChartViewModelTest.swift
//  ConverterTests
//
//  Created by abhisheksingh03 on 26/04/22.
//

import XCTest
@testable import Converter

class ChartViewModelTest: XCTestCase {
    var toSymbol: String! = "INR"
    var toValues:  [Double]! = [76, 77, 78]
    var viewModel: ChartViewModel!
    
    override func setUpWithError() throws {
        viewModel = ChartViewModel(toSymbol: toSymbol, toValues: toValues)
    }

    override func tearDownWithError() throws {
        viewModel = nil
        toSymbol = nil
        toValues = nil
    }

    func testGetEquatableValue() throws {
        viewModel = ChartViewModel(toSymbol: "INR", toValues: [])
        XCTAssertEqual(viewModel.getEquatableValue(100), 0.0)
    }

}
