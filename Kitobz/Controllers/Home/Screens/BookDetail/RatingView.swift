//
//  RatingView.swift
//  Kitobz
//
//  Created by Boymurodova Marhabo on 12/12/25.
//

import SnapKit
import UIKit

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
