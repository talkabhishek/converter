//
//  ChartView.swift
//  Converter
//
//  Created by abhisheksingh03 on 26/04/22.
//

import UIKit

class ChartView: UIView {
    @IBOutlet private var toSymbolLabel: UILabel!
    @IBOutlet private var toValuesLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func draw(_ rect: CGRect) {
        createChart()
    }

    var viewModel: ChartViewModel? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }
            toSymbolLabel.text = viewModel.toSymbol
            let values = viewModel.toValues.map { $0.twoFractionString }
            toValuesLabel.text = values.joined(separator: ", ")
            self.setNeedsDisplay(self.frame)
        }
    }

    func createChart() {
        if let viewModel = viewModel, viewModel.toValues.count > 2 {
            let path = UIBezierPath()
            let value = viewModel.getEquatableValue(viewModel.toValues[0])
            path.move(to: CGPoint(x: 160, y: value))
            let value2 = viewModel.getEquatableValue(viewModel.toValues[1])
            path.addLine(to: CGPoint(x: 240, y: value2))
            let value3 = viewModel.getEquatableValue(viewModel.toValues[2])
            path.addLine(to: CGPoint(x: 320, y: value3))

            UIColor.blue.setStroke()
            path.stroke()
        }
    }

}
