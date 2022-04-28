//
//  TopCurrenciesViewCell.swift
//  Converter
//
//  Created by abhisheksingh03 on 25/04/22.
//

import UIKit

class CurrenciesViewCell: UITableViewCell, IdentifierProtocol {
    @IBOutlet private var symbolLabel: UILabel!
    @IBOutlet private var valueLabel: UILabel!

    var viewModel: CurrenciesCellViewModel? {
        didSet {
            symbolLabel.text = viewModel?.toSymbol
            valueLabel.text = viewModel?.convertedValue
        }
    }

}
