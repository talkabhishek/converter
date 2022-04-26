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
    @IBOutlet private var chartView: ChartView!
    @IBOutlet private var historicalTableView: UITableView!
    @IBOutlet private var currenciesTableView: UITableView!
    
    var viewModel: DetailsViewModel!
    private let disposeBag = DisposeBag()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Details"~
        setupObserver()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //viewModel.getLastThreeDaysData()
        //viewModel.getLatestValues()
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? HistoricalListViewController {
            viewController.viewModel = HistoricalListViewModel(
                fromSymbol: viewModel.fromSymbol,
                toSymbol: viewModel.toSymbol,
                baseValue: viewModel.baseValue)
        } else if let viewController = segue.destination as? TopCurrenciesViewController {
            viewController.viewModel = TopCurrenciesViewModel(
                fromSymbol: viewModel.fromSymbol,
                toSymbol: viewModel.toSymbol,
                baseValue: viewModel.baseValue)
        }
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

        // Observe ChartViewModel
        viewModel.chartViewModel
            .asObservable()
            .subscribe(onNext: { [unowned self] value in
                chartView.viewModel = value
            })
            .disposed(by: disposeBag)

        // Setup HistoricalCellConfiguration
        viewModel.historicalCellViewModels
          .bind(to: historicalTableView
            .rx
            .items(cellIdentifier: HistoricalViewCell.identifier(),
                   cellType: HistoricalViewCell.self)) {
                    row, viewModel, cell in
                    cell.viewModel = viewModel
          }
          .disposed(by: disposeBag)

        // Setup CurrenciesCellConfiguration
        viewModel.currenciesCellViewModels
          .bind(to: currenciesTableView
            .rx
            .items(cellIdentifier: CurrenciesViewCell.identifier(),
                   cellType: CurrenciesViewCell.self)) {
                    row, viewModel, cell in
                    cell.viewModel = viewModel
          }
          .disposed(by: disposeBag)
    }

}
