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
        //viewModel.getHistoricalValues()
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

        viewModel.fromButtonValue
            .bind(to: fromButton.rx.title())
            .disposed(by: disposeBag)
        fromButton
            .rx
            .tap
            .asObservable()
            .subscribe(onNext: { [unowned self] _ in
                self.showDropdown(source: self.fromButton,
                                  dataSource: self.viewModel.currienties.value)
          })
          .disposed(by: disposeBag)

        viewModel.toButtonValue
            .bind(to: toButton.rx.title())
            .disposed(by: disposeBag)
        toButton
            .rx
            .tap
            .asObservable()
            .subscribe(onNext: { [unowned self] _ in
                self.showDropdown(source: self.toButton,
                                  dataSource: self.viewModel.currienties.value)
          })
          .disposed(by: disposeBag)
    }

    func updateView(value: ConverterData?) {
        
    }

    func showDropdown(source: UIButton, dataSource: [String]) {
        let dropdown = DropdownView(list: dataSource, source: source)
        self.view.addSubview(dropdown)
        dropdown.translatesAutoresizingMaskIntoConstraints = false
        dropdown.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        dropdown.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        dropdown.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        dropdown.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true

        dropdown.showDropdown()
        dropdown.selectedItem.asObservable().subscribe(onNext: { value in
            guard let value = value else {
                return
            }
            //source.setTitle(value, for: .normal)
            if source == self.fromButton {
                self.viewModel.fromButtonValue.accept(value)
            } else {
                self.viewModel.toButtonValue.accept(value)
            }
        }).disposed(by: disposeBag)
    }

}

