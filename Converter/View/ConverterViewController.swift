//
//  ConverterViewController.swift
//  Converter
//
//  Created by abhisheksingh03 on 23/04/22.
//

import UIKit
import RxSwift
import RxCocoa

class ConverterViewController: UIViewController, AlertProtocol, Injectable {
    // MARK: - Instance variables
    @IBOutlet private var fromButton: UIButton!
    @IBOutlet private var toButton: UIButton!
    @IBOutlet private var fromTextField: UITextField!
    @IBOutlet private var toTextField: UITextField!
    @IBOutlet private var swapButton: UIButton!
    @IBOutlet private var detailsButton: UIButton!

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
        // Observe From & To Button
        viewModel.fromButtonValue
            .bind(to: fromButton.rx.title())
            .disposed(by: disposeBag)
        fromButton.rx.tap
            .asObservable()
            .subscribe(onNext: { [unowned self] _ in
                self.showDropdown(source: self.fromButton,
                                  dataSource: self.viewModel.currienties)
            })
            .disposed(by: disposeBag)

        viewModel.toButtonValue
            .bind(to: toButton.rx.title())
            .disposed(by: disposeBag)
        toButton.rx.tap
            .asObservable()
            .subscribe(onNext: { [unowned self] _ in
                self.showDropdown(source: self.toButton,
                                  dataSource: self.viewModel.currienties)
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
            .map { [unowned self] value in
                self.viewModel.setTo(fromValue: value)
            }.subscribe()
            .disposed(by: disposeBag)

        bind(textField: toTextField, to: viewModel.toFieldValue)
        toTextField.rx.text
            .observe(on: MainScheduler.asyncInstance)
            .map { [unowned self] value in
                self.viewModel.setFrom(toValue: value)
            }.subscribe()
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
            if source == self.fromButton {
                self.viewModel.fromButtonValue.accept(value)
                let fromValue = self.viewModel.fromFieldValue.value
                self.viewModel.setTo(fromValue: fromValue)
            } else {
                self.viewModel.toButtonValue.accept(value)
                let toValue = self.viewModel.toFieldValue.value
                self.viewModel.setFrom(toValue: toValue)
            }
        }).disposed(by: disposeBag)
    }

    func showDetails() {
        guard viewModel.fromButtonValue.value != "From" &&
                viewModel.toButtonValue.value != "To" else {
            return
        }
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

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
