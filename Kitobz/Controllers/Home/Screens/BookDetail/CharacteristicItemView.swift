//
//  CharacteristicItemView.swift
//  Kitobz
//
//  Created by Boymurodova Marhabo on 05/12/25.
//

import UIKit
import SnapKit

final class CharacteristicItemView: UIView {
    private let titleLabel = UILabel()
    private let valueLabel = UILabel()
    private let stack = UIStackView()

    init() {
        super.init(frame: .zero)
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 2
        addSubview(stack)
        stack.snp.makeConstraints { $0.edges.equalToSuperview() }

        stack.addArrangedSubview(valueLabel)
        stack.addArrangedSubview(titleLabel)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func configure(value: String, title: String, valueFont: CGFloat = 14, titleFont: CGFloat = 12) {
        valueLabel.text = value
        valueLabel.font = .systemFont(ofSize: valueFont, weight: .bold)
        valueLabel.textColor = .label
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: titleFont, weight: .medium)
        titleLabel.textColor = .secondaryLabel
    }
}

final class RatingView: UIView {
    private let starLabel = UILabel()
    private let ratingLabel = UILabel()
    private let countLabel = UILabel()

    private let vStack = UIStackView()
    private let hStack = UIStackView()

    init() {
        super.init(frame: .zero)

        hStack.axis = .horizontal
        hStack.alignment = .center
        hStack.spacing = 4

        starLabel.text = "★"
        starLabel.textColor = .systemYellow
        starLabel.font = .systemFont(ofSize: 16, weight: .regular)

        ratingLabel.textColor = .label
        ratingLabel.font = .systemFont(ofSize: 16, weight: .semibold)

        hStack.addArrangedSubview(starLabel)
        hStack.addArrangedSubview(ratingLabel)

        vStack.axis = .vertical
        vStack.alignment = .center
        vStack.spacing = 2

        countLabel.font = .systemFont(ofSize: 10)
        countLabel.textColor = .secondaryLabel
        countLabel.textAlignment = .center

        vStack.addArrangedSubview(hStack)
        vStack.addArrangedSubview(countLabel)

        addSubview(vStack)
        vStack.snp.makeConstraints { $0.edges.equalToSuperview() }
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func configure(stars: Double, count: Int) {
        let isWhole = stars.rounded() == stars
        if isWhole {
            ratingLabel.text = String(Int(stars))
        } else {
            ratingLabel.text = String(format: "%.1f", stars)
        }
        countLabel.text = "\(count)"
    }
}
