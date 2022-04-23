//
//  Loader.swift
//  Converter
//
//  Created by abhisheksingh03 on 23/04/22.
//

import UIKit

class Loader {

    static let shared = Loader()
    let backView = UIView()
    let indicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)

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

    private init() {
        backView.backgroundColor = UIColor.black
        backView.alpha = 0.75
        backView.layer.cornerRadius = 10
        backView.layer.masksToBounds = true;
        indicator.color = UIColor.white
        backView.addSubview(indicator)

        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.heightAnchor.constraint(equalToConstant: 40).isActive = true
        indicator.widthAnchor.constraint(equalToConstant: 40).isActive = true
        indicator.centerXAnchor.constraint(equalTo: backView.centerXAnchor, constant: 0).isActive = true
        indicator.centerYAnchor.constraint(equalTo: backView.centerYAnchor, constant: 0).isActive = true
    }

    func show() {
        rootController.view.addSubview(backView)
        backView.translatesAutoresizingMaskIntoConstraints = false
        backView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        backView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        backView.centerXAnchor.constraint(equalTo: rootController.view.centerXAnchor, constant: 0).isActive = true
        backView.centerYAnchor.constraint(equalTo: rootController.view.centerYAnchor, constant: 0).isActive = true
        indicator.startAnimating()
    }

    func hide() {
        self.indicator.stopAnimating()
        self.backView.removeFromSuperview()
    }
}
