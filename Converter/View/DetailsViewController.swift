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

}
