//
//  DropdownView.swift
//  Converter
//
//  Created by abhisheksingh03 on 24/04/22.
//

import UIKit
import RxSwift
import RxCocoa

class DropdownView: UIView {
    private let transparentView = UIView()
    private let tableView = UITableView()

    private let dataSource :[String]
    private let sourceView: UIView
    let selectedItem: BehaviorRelay<String?> = BehaviorRelay(value: nil)
    var firstWindow: UIWindow? {
        return UIApplication.shared.windows.first { $0.isKeyWindow }
    }

    init(list: [String], source: UIView) {
        // Setup Dropdown View
        dataSource = list
        sourceView = source
        super.init(frame: CGRect.zero)
        // Setup Table View
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func showDropdown() {
        addTransparentView()
    }

    private func addTransparentView() {
        guard let firstWindow = firstWindow else { return }
        self.addSubview(transparentView)
        transparentView.translatesAutoresizingMaskIntoConstraints = false
        transparentView.leadingAnchor.constraint(equalTo: firstWindow.leadingAnchor, constant: 0).isActive = true
        transparentView.trailingAnchor.constraint(equalTo: firstWindow.trailingAnchor, constant: 0).isActive = true
        transparentView.topAnchor.constraint(equalTo: firstWindow.topAnchor, constant: 0).isActive = true
        transparentView.bottomAnchor.constraint(equalTo: firstWindow.bottomAnchor, constant: 0).isActive = true

        self.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: sourceView.leadingAnchor, constant: 0).isActive = true
        tableView.topAnchor.constraint(equalTo: sourceView.topAnchor, constant: 42).isActive = true
        tableView.widthAnchor.constraint(equalTo: sourceView.widthAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(lessThanOrEqualTo: firstWindow.bottomAnchor, constant: -50).isActive = true
        let heightConstraint = tableView.heightAnchor.constraint(equalToConstant: CGFloat(dataSource.count * 50))
        heightConstraint.priority = .defaultLow
        heightConstraint.isActive = true

        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentView))
        transparentView.alpha = 0.5
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        transparentView.addGestureRecognizer(tapgesture)
        tableView.layer.cornerRadius = 5
        tableView.reloadData()
    }

    @objc private func removeTransparentView() {
        removeFromSuperview()
    }

}

extension DropdownView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedItem.accept(dataSource[indexPath.row])
        removeTransparentView()
    }
}
