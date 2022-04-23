//
//  ConverterViewController.swift
//  Converter
//
//  Created by abhisheksingh03 on 23/04/22.
//

import UIKit

class ConverterViewController: UIViewController {
    // MARK: - Instance variables
    @IBOutlet private var fromButton: UIButton!
    @IBOutlet private var toButton: UIButton!
    @IBOutlet private var fromTextField: UITextField!
    @IBOutlet private var toTextField: UITextField!
    @IBOutlet private var swapButton: UIButton!
    @IBOutlet private var detailsButton: UIButton!
    lazy var viewModel: ConverterViewModel = {
        let viewModel = ConverterViewModel()
        return viewModel
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

}

