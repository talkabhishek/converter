//
//  ConverterViewController.swift
//  Converter
//
//  Created by abhisheksingh03 on 23/04/22.
//

import UIKit
import RxSwift
import RxCocoa

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
    private let disposeBag = DisposeBag()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupObserver()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.getLatestValues()
        viewModel.getHistoricalValues()
    }

    // MARK: User Defined function
    private func setupObserver() {
        viewModel.latestValue.asObservable()
            .subscribe(onNext: {
                [unowned self] value in
                self.updateView(value: value)
            })
            .disposed(by: disposeBag)

        viewModel.historicalValue.asObservable()
            .subscribe(onNext: {
                [unowned self] value in
                self.updateView(value: value)
            })
            .disposed(by: disposeBag)
    }

    func updateView(value: ConverterData?) {
    }

}

