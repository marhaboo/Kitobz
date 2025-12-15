//
//  BookListCell.swift
//  Kitobz
//
//  Created by Boymurodova Marhabo on 12/12/25.
//

import UIKit
import SnapKit

final class BookListCell: UICollectionViewCell {
    static let id = "BookListCell"

    private let coverImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 12
        iv.backgroundColor = .secondarySystemBackground
        return iv
    }()

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 17, weight: .semibold)
        l.textColor = .label
        l.numberOfLines = 2
        l.lineBreakMode = .byTruncatingTail
        return l
    }()

    private let authorLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 14)
        l.textColor = .secondaryLabel
        l.numberOfLines = 1
        return l
    }()

    private let ratingIcon: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 13, weight: .semibold)
        l.text = "★"
        l.textColor = .systemYellow
        return l
    }()

    private let ratingValueLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 13, weight: .semibold)
        l.textColor = .label
        return l
    }()

    private let reviewsCountLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 13, weight: .semibold)
        l.textColor = .secondaryLabel
        return l
    }()

    private let priceLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 18, weight: .bold)
        l.textColor = UIColor(named: "TextColor") ?? .label
        return l
    }()

    private let favoriteButton: UIButton = {
        let b = UIButton(type: .system)
        b.tintColor = .secondaryLabel
        b.setImage(UIImage(systemName: "heart"), for: .normal)
        return b
    }()

    var onFavoriteToggle: ((Bool) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        contentView.backgroundColor = .clear

        contentView.addSubview(coverImageView)
        contentView.addSubview(favoriteButton)

        let rightStack = UIStackView()
        rightStack.axis = .vertical
        rightStack.alignment = .fill
        rightStack.spacing = 6

        let ratingRow = UIStackView()
        ratingRow.axis = .horizontal
        ratingRow.spacing = 6
        ratingRow.alignment = .center


        ratingRow.addArrangedSubview(ratingIcon)
        ratingRow.addArrangedSubview(ratingValueLabel)
        ratingRow.addArrangedSubview(reviewsCountLabel)
        ratingRow.addArrangedSubview(UIView())

        rightStack.addArrangedSubview(titleLabel)
        rightStack.addArrangedSubview(authorLabel)
        rightStack.addArrangedSubview(ratingRow)
        rightStack.addArrangedSubview(priceLabel)

        contentView.addSubview(rightStack)

        coverImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(96)
            make.height.equalTo(128)
        }

        favoriteButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(4)
            make.width.height.equalTo(28)
        }

        rightStack.snp.makeConstraints { make in
            make.leading.equalTo(coverImageView.snp.trailing).offset(16)
            make.trailing.equalTo(favoriteButton.snp.leading).offset(-12)
            make.centerY.equalToSuperview()
        }

        favoriteButton.addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)
    }

    @objc private func toggleFavorite() {
        let isFav = favoriteButton.currentImage == UIImage(systemName: "heart.fill")
        let newIsFav = !isFav
        favoriteButton.setImage(UIImage(systemName: newIsFav ? "heart.fill" : "heart"), for: .normal)
        favoriteButton.tintColor = newIsFav ? .systemRed : .secondaryLabel
        onFavoriteToggle?(newIsFav)
    }

    func configure(with book: Book) {
        coverImageView.image = UIImage(named: book.coverImageName) ?? UIImage(systemName: "book")
        titleLabel.text = book.title
        authorLabel.text = book.author

        let count = max(book.reviews.count, 0)
        reviewsCountLabel.text = "(\(count))"

        if book.rating > 0 {
            ratingIcon.isHidden = false
            ratingValueLabel.isHidden = false
            ratingValueLabel.text = String(format: "%.1f", book.rating)
        } else {
            ratingIcon.isHidden = true
            ratingValueLabel.isHidden = true
            ratingValueLabel.text = ""
        }

        priceLabel.text = book.price

        let isFav = FavoritesManager.shared.isFavorite(bookID: book.id) || book.isFavorite
        favoriteButton.setImage(UIImage(systemName: isFav ? "heart.fill" : "heart"), for: .normal)
        favoriteButton.tintColor = isFav ? .systemRed : .secondaryLabel
    }
}
