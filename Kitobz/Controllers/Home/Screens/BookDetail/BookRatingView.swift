//
//  BookRatingView.swift
//  Kitobz
//
//  Created by Boymurodova Marhabo on 12/12/25.
//

import SnapKit
import UIKit

final class BookRatingView: UIView {

    // Big average number (smaller)
    private let averageLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 32, weight: .bold) // was 36
        l.textColor = UIColor.label.withAlphaComponent(0.9)
        l.textAlignment = .center
        l.text = "—"
        return l
    }()

    // Ratings count line (smaller)
    private let countLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 13, weight: .medium) // was 14
        l.textColor = UIColor.secondaryLabel
        l.textAlignment = .center
        l.text = ""
        return l
    }()

    private let questionLabel: UILabel = {
        let label = UILabel()
        label.text = "Как вам книга?"
        label.font = .systemFont(ofSize: 16, weight: .medium) // was 18
        label.textColor = UIColor.label
        label.textAlignment = .center
        return label
    }()

    private var starButtons: [UIButton] = []
    var onRatingSelected: ((Int) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func setup() {
        backgroundColor = .clear

        addSubview(averageLabel)
        addSubview(countLabel)
        addSubview(questionLabel)

        averageLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }

        countLabel.snp.makeConstraints { make in
            make.top.equalTo(averageLabel.snp.bottom).offset(4) // was 6
            make.centerX.equalToSuperview()
        }

        questionLabel.snp.makeConstraints { make in
            make.top.equalTo(countLabel.snp.bottom).offset(10) // was 14
            make.centerX.equalToSuperview()
        }

        createStarButtons()
    }

    private func createStarButtons() {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 12 // was 14
        stack.alignment = .center
        stack.distribution = .equalCentering

        addSubview(stack)
        stack.snp.makeConstraints { make in
            make.top.equalTo(questionLabel.snp.bottom).offset(10) // was 14
            make.centerX.equalToSuperview()
            make.leading.greaterThanOrEqualToSuperview().offset(10)
            make.trailing.lessThanOrEqualToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(4) // was 6
        }

        // Smaller stars
        let starConfig = UIImage.SymbolConfiguration(pointSize: 22, weight: .regular) // was 24

        for i in 1...5 {
            let btn = UIButton(type: .system)
            btn.tag = i
            btn.tintColor = UIColor.tertiaryLabel
            btn.setImage(UIImage(systemName: "star.fill", withConfiguration: starConfig), for: .normal)

            btn.addAction(
                UIAction { [weak self] _ in
                    self?.updateStars(rating: i)
                    self?.onRatingSelected?(i)
                },
                for: .touchUpInside
            )

            starButtons.append(btn)
            stack.addArrangedSubview(btn)
        }
    }

    private func updateStars(rating: Int) {
        UIView.animate(withDuration: 0.15) {
            for btn in self.starButtons {
                btn.tintColor = btn.tag <= rating ? .systemYellow : UIColor.tertiaryLabel
            }
        }
    }

    // MARK: - Public API

    func configure(average: Double, count: Int) {
        let avgFormatter = NumberFormatter()
        avgFormatter.numberStyle = .decimal
        avgFormatter.minimumFractionDigits = 1
        avgFormatter.maximumFractionDigits = 1
        avgFormatter.locale = Locale.current
        let avgText = avgFormatter.string(from: NSNumber(value: average)) ?? String(format: "%.1f", average)
        averageLabel.text = avgText

        let countFormatter = NumberFormatter()
        countFormatter.numberStyle = .decimal
        countFormatter.groupingSeparator = " "
        countFormatter.locale = Locale.current
        let countText = countFormatter.string(from: NSNumber(value: count)) ?? "\(count)"
        let word = pluralizeRatings(count)
        countLabel.text = "\(countText) \(word)"
    }

    private func pluralizeRatings(_ n: Int) -> String {
        let nMod10 = n % 10
        let nMod100 = n % 100
        if nMod10 == 1 && nMod100 != 11 { return "оценка" }
        if (2...4).contains(nMod10) && !(12...14).contains(nMod100) { return "оценки" }
        return "оценки"
    }
}
