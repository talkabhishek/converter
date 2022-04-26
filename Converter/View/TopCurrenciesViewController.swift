//
//  TopCurrenciesViewController.swift
//  Converter
//
//  Created by abhisheksingh03 on 25/04/22.
//

import UIKit
import RxSwift
import RxCocoa

class TopCurrenciesViewController: UIViewController, AlertProtocol {
    // MARK: - Instance variables
    @IBOutlet private var tableView: UITableView!

    var viewModel: TopCurrenciesViewModel!
    private let disposeBag = DisposeBag()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupObserver()
        viewModel.getLatestValues()
    }

    // MARK: User Defined function
    private func setupObserver() {
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

        // SetupCellConfiguration
        viewModel.currenciesCellViewModels
          .bind(to: tableView
            .rx
            .items(cellIdentifier: CurrenciesViewCell.identifier(),
                   cellType: CurrenciesViewCell.self)) {
                    row, viewModel, cell in
                    cell.viewModel = viewModel
          }
          .disposed(by: disposeBag)
    }

}
