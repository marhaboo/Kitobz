//
//  ReviewCardCell.swift
//  Kitobz
//
//  Created by Boymurodova Marhabo on 04/12/25.
//

import UIKit
import SnapKit

final class ReviewCardCell: UICollectionViewCell {
    static let id = "ReviewCardCell"

    private let cardView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(named: "cardBg") ?? .systemBackground
        v.layer.cornerRadius = 14
        v.layer.masksToBounds = true
        return v
    }()

    private let coverImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 8
        iv.backgroundColor = .clear
        return iv
    }()

    private let starsStack: UIStackView = {
        let s = UIStackView()
        s.axis = .horizontal
        s.spacing = 4
        s.alignment = .center
        return s
    }()

    private let bookTitleLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 13, weight: .semibold)
        l.textColor = .label
        l.numberOfLines = 2
        l.lineBreakMode = .byWordWrapping
        l.setContentHuggingPriority(.defaultLow, for: .vertical)
        l.setContentCompressionResistancePriority(.required, for: .vertical)
        return l
    }()

    private let nameLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 16, weight: .semibold)
        l.textColor = .label
        return l
    }()

    private let dateLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 12, weight: .regular)
        l.textColor = .secondaryLabel
        return l
    }()

    private let moodImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .systemGreen
        iv.setContentHuggingPriority(.required, for: .horizontal)
        return iv
    }()

    private let separator: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.separator.withAlphaComponent(0.22)
        return v
    }()

    private let reviewLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 14, weight: .regular)
        l.textColor = .label
        l.numberOfLines = 4
        l.lineBreakMode = .byTruncatingTail
        return l
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(cardView)

        // -------------------- LEFT COLUMN --------------------
        let leftColumn = UIView()
        cardView.addSubview(leftColumn)

        leftColumn.addSubview(coverImageView)
        leftColumn.addSubview(starsStack)
        leftColumn.addSubview(bookTitleLabel)

        coverImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.width.equalTo(120)
            make.height.equalTo(140)
        }

        starsStack.snp.makeConstraints { make in
            make.top.equalTo(coverImageView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
        }

        bookTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(starsStack.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(34)
            make.bottom.equalToSuperview()
        }

        leftColumn.snp.makeConstraints { make in
            make.width.equalTo(coverImageView)
            make.top.bottom.equalToSuperview()
        }

        // -------------------- RIGHT COLUMN --------------------
        let nameDateStack = UIStackView(arrangedSubviews: [nameLabel, dateLabel])
        nameDateStack.axis = .vertical
        nameDateStack.spacing = 2

        let headerStack = UIStackView(arrangedSubviews: [nameDateStack, UIView(), moodImageView])
        headerStack.axis = .horizontal
        headerStack.alignment = .center

        let rightColumn = UIStackView(arrangedSubviews: [headerStack, separator, reviewLabel])
        rightColumn.axis = .vertical
        rightColumn.spacing = 14

        let rightWrapper = UIView()
        rightWrapper.addSubview(rightColumn)
        rightColumn.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.trailing.bottom.equalToSuperview()
        }

        // -------------------- HORIZONTAL STACK --------------------
        let hStack = UIStackView(arrangedSubviews: [leftColumn, rightWrapper])
        hStack.axis = .horizontal
        hStack.alignment = .top
        hStack.spacing = 16

        cardView.addSubview(hStack)

        cardView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        hStack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(12)
        }

        separator.snp.makeConstraints { make in
            make.height.equalTo(1)
        }

        // -------------------- Stars --------------------
        for _ in 0..<5 {
            let star = UIImageView(image: UIImage(systemName: "star.fill"))
            star.contentMode = .scaleAspectFit
            star.tintColor = .systemYellow
            star.snp.makeConstraints { make in
                make.width.height.equalTo(16)
            }
            starsStack.addArrangedSubview(star)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        coverImageView.image = nil
        nameLabel.text = nil
        dateLabel.text = nil
        bookTitleLabel.text = nil
        bookTitleLabel.textAlignment = .center
        reviewLabel.text = nil
        updateStars(rating: 0)
        moodImageView.image = nil
    }

    func configure(with item: ReviewItem) {
        coverImageView.image = UIImage(named: item.bookCoverImageName)
        nameLabel.text = item.userName
        dateLabel.text = item.date
        bookTitleLabel.text = item.bookTitle
        reviewLabel.text = item.reviewText
        updateStars(rating: item.rating)
        moodImageView.image = moodIcon(for: item.mood)
    }

    private func updateStars(rating: Int) {
        let clamped = max(0, min(5, rating))
        for (idx, v) in starsStack.arrangedSubviews.enumerated() {
            guard let iv = v as? UIImageView else { continue }
            iv.image = UIImage(systemName: idx < clamped ? "star.fill" : "star")
            iv.tintColor = .systemYellow
        }
    }

    private func moodIcon(for mood: ReviewMood) -> UIImage? {
        switch mood {
        case .happy:
            return UIImage(systemName: "face.smiling")?.withRenderingMode(.alwaysTemplate)
        case .neutral:
            return UIImage(systemName: "face.neutral")?.withRenderingMode(.alwaysTemplate)
        case .sad:
            return UIImage(systemName: "face.frown")?.withRenderingMode(.alwaysTemplate)
        }
    }
}
