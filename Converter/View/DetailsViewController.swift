//
//  DetailsViewController.swift
//  Converter
//
//  Created by abhisheksingh03 on 25/04/22.
//

import UIKit
import RxSwift
import RxCocoa

class DetailsViewController: UIViewController, AlertProtocol, IdentifierProtocol {
    // MARK: - Instance variables
    
    var viewModel: DetailsViewModel!
    private let disposeBag = DisposeBag()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Details"~
        setupObserver()
    }

    // MARK: User Defined function
    private func setupObserver() {
        // Observe API response
        viewModel.historicalValue.asObservable()
            .subscribe(onNext: { [unowned self] value in
                self.updateView(value: value)
            })
            .disposed(by: disposeBag)

        // Observe Error
        viewModel.errorData
            .asObservable()
            .subscribe(onNext: { [unowned self] value in
                guard let error = value else {
                    return
                }
                self.presentAlert(title: nil, message: error.info)
            })
            .disposed(by: disposeBag)
    }

    func updateView(value: ConverterData?) {

    }
}
