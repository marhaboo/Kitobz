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
    private let starsLabel = UILabel()
    private let countLabel = UILabel()
    private let stack = UIStackView()

    init() {
        super.init(frame: .zero)
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 2
        addSubview(stack)
        stack.snp.makeConstraints { $0.edges.equalToSuperview() }

        stack.addArrangedSubview(starsLabel)
        stack.addArrangedSubview(countLabel)

        starsLabel.font = .systemFont(ofSize: 14)
        starsLabel.textColor = .systemYellow
        countLabel.font = .systemFont(ofSize: 10)
        countLabel.textColor = .secondaryLabel
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func configure(stars: Double, count: Int) {
        let fullStars = Int(stars)
        let halfStar = (stars - Double(fullStars)) >= 0.5 ? 1 : 0
        let emptyStars = 5 - fullStars - halfStar

        starsLabel.text = String(repeating: "★", count: fullStars)
            + (halfStar == 1 ? "⯨" : "") 
            + String(repeating: "☆", count: emptyStars)
        countLabel.text = "\(count) оценок"
    }

}
