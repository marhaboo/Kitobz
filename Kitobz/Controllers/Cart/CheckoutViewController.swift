//
//  CheckoutViewController.swift
//  Kitobz
//
//  Created by Ilmhona 11 on 12/9/25.
//

import UIKit

class CheckoutViewController: UIViewController {

    var selectedItems: [CartItem] = [] {
        didSet {
            updateSummary()
        }
    }

    private let summaryLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 18, weight: .semibold)
        l.textColor = .label
        l.numberOfLines = 0
        l.textAlignment = .center
        return l
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Оформление"

        view.addSubview(summaryLabel)
        summaryLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            summaryLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            summaryLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            summaryLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20),
            summaryLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20)
        ])

        updateSummary()
    }

    private func updateSummary() {
        let total = selectedItems.reduce(0) { $0 + $1.price }
        let count = selectedItems.count
        summaryLabel.text = count > 0
        ? "Вы выбрали \(count) товар(ов)\nИтого: \(total) сомони"
        : "Нет выбранных товаров"
    }
}
