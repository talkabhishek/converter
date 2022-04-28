//
//  HistoricalListViewCell.swift
//  Converter
//
//  Created by abhisheksingh03 on 25/04/22.
//

import UIKit

class HistoricalViewCell: UITableViewCell, IdentifierProtocol {
    @IBOutlet private var fromSymbolLabel: UILabel!
    @IBOutlet private var toSymbolLabel: UILabel!
    @IBOutlet private var fromValueLabel: UILabel!
    @IBOutlet private var toValueLabel: UILabel!
    @IBOutlet private var dateLabel: UILabel!

    var viewModel: HistoricalCellViewModel? {
        didSet {
            fromSymbolLabel.text = viewModel?.fromSymbol
            toSymbolLabel.text = viewModel?.toSymbol
            fromValueLabel.text = viewModel?.baseValue.twoFractionString
            toValueLabel.text = viewModel?.convertedValue
            dateLabel.text = viewModel?.valueDate
        }
    }

}
