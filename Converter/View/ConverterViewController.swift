//
//  ConverterViewController.swift
//  Converter
//
//  Created by abhisheksingh03 on 23/04/22.
//

import UIKit
import RxSwift
import RxCocoa

class ConverterViewController: BaseViewController, Injectable {
    // MARK: - Instance variables
    @IBOutlet private var fromButton: UIButton!
    @IBOutlet private var toButton: UIButton!
    @IBOutlet private var fromTextField: UITextField!
    @IBOutlet private var toTextField: UITextField!
    @IBOutlet private var swapButton: UIButton!
    @IBOutlet private var detailsButton: UIButton!
    let dropdown = DropdownView()

    typealias Dependencies = HasConverterViewModel
    var dependencies: Dependencies!
    lazy var viewModel = dependencies.converterViewModel

    private let throttleIntervalInMilliseconds = 100
    private let disposeBag = DisposeBag()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Converter"~
        hideKeyboardWhenTappedAround()
        setupObserver()
        viewModel.getLatestValues()
    }

    // MARK: User Defined function
    private func setupObserver() {
        // Observe Combined observable
        Observable.combineLatest(viewModel.fromButtonValue, viewModel.toButtonValue, viewModel.fromFieldValue).subscribe { [unowned self] from, to, fromValue in
            self.viewModel.isSwapEnabled.accept(from != "From"~ &&
                                                    to != "To"~)
            self.viewModel.isDetailEnabled.accept(from != "From"~ &&
                                                    to != "To"~ &&
                                                    fromValue != nil &&
                                                    fromValue != "")
        }.disposed(by: disposeBag)

        viewModel.isSwapEnabled
            .bind(to: swapButton.rx.isEnabled)
            .disposed(by: disposeBag)

        viewModel.isDetailEnabled
            .bind(to: detailsButton.rx.isEnabled)
            .disposed(by: disposeBag)

        // Observe Dropdown selection
        dropdown.selectedItem.asObservable().subscribe(onNext: { [unowned self] value in
            guard let value = value else {
                return
            }
            if self.dropdown.sourceView == self.fromButton {
                self.viewModel.fromButtonValue.accept(value)
                let fromValue = self.viewModel.fromFieldValue.value
                self.viewModel.setTo(fromValue: fromValue)
            } else {
                self.viewModel.toButtonValue.accept(value)
                let toValue = self.viewModel.toFieldValue.value
                self.viewModel.setFrom(toValue: toValue)
            }
        }).disposed(by: disposeBag)

        // Observe From & To Button
        viewModel.fromButtonValue
            .bind(to: fromButton.rx.title())
            .disposed(by: disposeBag)
        fromButton.rx.tap
            .asObservable()
            .subscribe(onNext: { [unowned self] _ in
                self.showDropdown(source: self.fromButton,
                                  dataSource: self.viewModel.currencies)
            })
            .disposed(by: disposeBag)

        viewModel.toButtonValue
            .bind(to: toButton.rx.title())
            .disposed(by: disposeBag)
        toButton.rx.tap
            .asObservable()
            .subscribe(onNext: { [unowned self] _ in
                self.showDropdown(source: self.toButton,
                                  dataSource: self.viewModel.currencies)
            })
            .disposed(by: disposeBag)

        // Observe Swap Button
        swapButton.rx.tap
            .asObservable()
            .subscribe(onNext: { [unowned self] _ in
                self.viewModel.swapSymbols()
            })
            .disposed(by: disposeBag)

        // Observer Textfield change
        bind(textField: fromTextField, to: viewModel.fromFieldValue)
        fromTextField.rx.text
            .observe(on: MainScheduler.asyncInstance)
            .throttle(.milliseconds(throttleIntervalInMilliseconds), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] value in
                self.viewModel.setTo(fromValue: value)
            })
            .disposed(by: disposeBag)

        bind(textField: toTextField, to: viewModel.toFieldValue)
        toTextField.rx.text
            .observe(on: MainScheduler.asyncInstance)
            .throttle(.milliseconds(throttleIntervalInMilliseconds), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] value in
                self.viewModel.setFrom(toValue: value)
            })
            .disposed(by: disposeBag)

        // Observe Error
        viewModel.errorData
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [unowned self] value in
                guard let error = value else {
                    return
                }
                self.presentAlert(title: nil, message: error.info)
            })
            .disposed(by: disposeBag)

        // Observe Detail tap
        detailsButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.showDetails()
            })
            .disposed(by: disposeBag)
    }

    private func bind(textField: UITextField, to behaviorRelay: BehaviorRelay<String?>) {
        behaviorRelay.asObservable()
            .bind(to: textField.rx.text)
            .disposed(by: disposeBag)
        textField.rx.text.orEmpty
            .bind(to: behaviorRelay)
            .disposed(by: disposeBag)
    }

    func showDropdown(source: UIButton, dataSource: [String]) {
        self.view.addSubview(dropdown)
        dropdown.translatesAutoresizingMaskIntoConstraints = false
        dropdown.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        dropdown.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        dropdown.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        dropdown.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true

        dropdown.showDropdown(list: dataSource, source: source)
    }

    func showDetails() {
        guard let baseValueStr = viewModel.fromFieldValue.value,
              let baseValue = Double(baseValueStr) else {
            return
        }
        let dependencies = DetailsModule(fromSymbol: viewModel.fromButtonValue.value, toSymbol: viewModel.toButtonValue.value, baseValue: baseValue)
        let storyboard = UIStoryboard(.main)
        let detailsVC: DetailsViewController = storyboard.inflateVC(with: dependencies)
        show(detailsVC, sender: self)
    }

}
