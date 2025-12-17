//
//  BookCardCell.swift
//  Kitobz
//
//  Created by Boymurodova Marhabo on 03/12/25.
//

import UIKit
import SnapKit

final class BookCardCell: UICollectionViewCell {
    static let id = "BookCardCell"

    // MARK: - UI Elements
    private let coverImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 12
        return iv
    }()

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 15, weight: .semibold)
        l.numberOfLines = 1
        l.textColor = .label
        return l
    }()

    private let authorLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 13, weight: .regular)
        l.textColor = .secondaryLabel
        l.numberOfLines = 1
        return l
    }()

    private let priceLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 15, weight: .bold)
        l.textColor = UIColor(named: "TextColor")
        return l
    }()

    private let oldPriceLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 12)
        l.textColor = .secondaryLabel
        return l
    }()

    private let discountBadge: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 12, weight: .bold)
        l.textColor = .white
        l.textAlignment = .center
        l.backgroundColor = .systemRed
        l.layer.cornerRadius = 12
        l.clipsToBounds = true
        
        // Shadow for depth
        l.layer.shadowColor = UIColor.black.cgColor
        l.layer.shadowOffset = CGSize(width: 1, height: 1)
        l.layer.shadowOpacity = 0.3
        l.layer.shadowRadius = 2
        
        l.isHidden = true
        return l
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup UI
    private func setupUI() {
        contentView.layer.cornerRadius = 16
        contentView.backgroundColor = .clear
        contentView.layer.masksToBounds = false // allow shadow

        contentView.addSubview(coverImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(authorLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(oldPriceLabel)
        contentView.addSubview(discountBadge)

        coverImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.trailing.equalToSuperview().inset(8)
            make.height.equalTo(coverImageView.snp.width).multipliedBy(1.30)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(coverImageView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(12)
        }

        authorLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.trailing.equalTo(titleLabel)
        }

        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(authorLabel.snp.bottom).offset(8)
            make.leading.equalTo(titleLabel)
        }

        oldPriceLabel.snp.makeConstraints { make in
            make.centerY.equalTo(priceLabel)
            make.leading.equalTo(priceLabel.snp.trailing).offset(6)
        }

        // New badge position: top-right with ribbon style
        discountBadge.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().inset(-8)
            make.height.equalTo(24)
            make.width.greaterThanOrEqualTo(40)
        }
        
        // Optional rotation for ribbon effect
        discountBadge.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 12))
    }

    // MARK: - Configure
    func configure(with model: Book) {
        coverImageView.image = UIImage(named: model.coverImageName)
        titleLabel.text = model.title
        authorLabel.text = model.author
        priceLabel.text = model.price

        if let old = model.oldPrice {
            let attribute = NSAttributedString(
                string: old,
                attributes: [
                    .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                    .foregroundColor: UIColor.red
                ]
            )
            oldPriceLabel.attributedText = attribute
        } else {
            oldPriceLabel.attributedText = nil
        }

        if let discount = model.discountText {
            discountBadge.text = discount
            discountBadge.isHidden = false
        } else {
            discountBadge.isHidden = true
        }
    }
}
