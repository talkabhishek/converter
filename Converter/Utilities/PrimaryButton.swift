//
//  PrimaryButton.swift
//  Converter
//
//  Created by abhisheksingh03 on 02/05/22.
//

import UIKit

class PrimaryButton: UIButton {
    override open var isEnabled: Bool {
        didSet {
            backgroundColor = isEnabled ? UIColor(named: "AccentColor") : UIColor(named: "DisableColor")
        }
    }
}

class TintButton: UIButton {
    override open var isEnabled: Bool {
        didSet {
            tintColor = isEnabled ? UIColor(named: "AccentColor") : UIColor.darkGray
        }
    }
}
