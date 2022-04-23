//
//  AlertProtocol.swift
//  Converter
//
//  Created by abhisheksingh03 on 23/04/22.
//

import UIKit

protocol AlertProtocol {
    func presentAlert(title: String?, message: String?)
    func presentAlert(title: String?,
                      message: String?,
                      dismissTitle: String?,
                      dismissAction: (() -> Void)?)
}

extension AlertProtocol {
    func presentAlert(title: String?, message: String?) {
        presentAlertView(title: title, message: message)
    }

    func presentAlert(title: String?,
                      message: String?,
                      dismissTitle: String?,
                      dismissAction: (() -> Void)?) {
        presentAlertView(title: title, message: message, dismissTitle: dismissTitle, dismissAction: dismissAction)
    }

    var appDelegate: SceneDelegate {
        guard let sceneDelegate = UIApplication.shared.connectedScenes
            .first!.delegate as? SceneDelegate else {
                fatalError("SceneDelegate not available"~)
        }
        return sceneDelegate
    }

    var rootController: UIViewController {
        guard let viewController = appDelegate.window?.rootViewController else {
            fatalError("RootViewController not available"~)
        }
        return viewController
    }

    private func presentAlertView(title: String?,
                                  message: String?,
                                  dismissTitle: String? = nil,
                                  dismissAction: (() -> Void)? = nil) {
        // Resign keyboard
        rootController.view.endEditing(true)
        UIApplication.shared.sendAction(#selector(rootController.resignFirstResponder), to: nil, from: nil, for: nil)
        // create alert controller
        var titleText = ""
        var dismissText = "Ok"~
        if title != nil {
            titleText = title ?? ""
        }
        if dismissTitle != nil {
            dismissText = dismissTitle ?? ""
        }
        let alertController = UIAlertController(title: titleText, message: message, preferredStyle: .alert)
        let dismissAlertAction = UIAlertAction(title: dismissText, style: .default) { _ in
            dismissAction?()
        }
        alertController.addAction(dismissAlertAction)
        // present alert controller
        rootController.present(alertController, animated: true, completion: nil)
    }
}
