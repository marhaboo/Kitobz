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


