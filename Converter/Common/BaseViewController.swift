//
//  BaseViewController.swift
//  Converter
//
//  Created by abhisheksingh03 on 28/04/22.
//

import UIKit

class BaseViewController: UIViewController, AlertProtocol {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(BaseViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

}
