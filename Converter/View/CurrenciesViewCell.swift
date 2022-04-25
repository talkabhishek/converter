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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
