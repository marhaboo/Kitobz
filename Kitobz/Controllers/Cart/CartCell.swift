//
//  CartCell.swift
//  Kitobz
//
//  Created by Ilmhona 11 on 12/8/25.
//

import UIKit
import SnapKit

class CartCell: UITableViewCell {
    
    private let cardView: UIView = {
        let v = UIView()
        v.backgroundColor = .clear
        v.layer.cornerRadius = 16
        v.layer.masksToBounds = false
        return v
    }()
    
    private let checkButton: UIButton = {
        let button = UIButton(type: .system)
        let accent = UIColor(named: "AccentColor") ?? .systemBlue
        button.tintColor = accent
        button.setImage(UIImage(systemName: "circle"), for: .normal)
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        return button
    }()
    
    private let bookImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 12
        image.clipsToBounds = true
        image.backgroundColor = .secondarySystemBackground
        return image
    }()
    
    private let titleLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 15, weight: .semibold)
        l.textColor = .label
        l.numberOfLines = 2
        l.lineBreakMode = .byTruncatingTail
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
        l.textColor = UIColor(named: "TextColor") ?? .label
        return l
    }()
    
    private let oldPriceLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 12)
        l.textColor = .secondaryLabel
        l.isHidden = true
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
        l.isHidden = true
        return l
    }()
    
    var onCheckTap: (() -> Void)?
    var onImageTap: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        setupLayout()
        
        checkButton.addTarget(self, action: #selector(checkTapped), for: .touchUpInside)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        bookImageView.isUserInteractionEnabled = true
        bookImageView.addGestureRecognizer(tap)
    }
    
    @objc private func checkTapped() {
        UIView.animate(withDuration: 0.1, animations: {
            self.checkButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.checkButton.transform = .identity
            }
        }
        onCheckTap?()
    }
    
    @objc private func imageTapped() {
        onImageTap?()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupLayout() {
        contentView.addSubview(cardView)
        cardView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 16, bottom: 8, right: 16))
        }
        
        cardView.addSubview(checkButton)
        cardView.addSubview(bookImageView)
        cardView.addSubview(discountBadge)
        
        let priceStack = UIStackView(arrangedSubviews: [priceLabel, oldPriceLabel, UIView()])
        priceStack.axis = .horizontal
        priceStack.spacing = 6
        priceStack.alignment = .firstBaseline
        
        let textStack = UIStackView(arrangedSubviews: [titleLabel, authorLabel, priceStack])
        textStack.axis = .vertical
        textStack.spacing = 6
        cardView.addSubview(textStack)
        
        checkButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(26)
        }
        
        bookImageView.snp.makeConstraints { make in
            make.left.equalTo(checkButton.snp.right).offset(12)
            make.centerY.equalToSuperview()
            make.width.equalTo(80)
            make.height.equalTo(bookImageView.snp.width).multipliedBy(1.30)
            make.top.greaterThanOrEqualToSuperview().offset(12)
            make.bottom.lessThanOrEqualToSuperview().inset(12)
        }
        
        discountBadge.snp.makeConstraints { make in
            make.top.equalTo(bookImageView).offset(-4)
            make.trailing.equalTo(bookImageView).offset(4)
            make.height.equalTo(24)
            make.width.greaterThanOrEqualTo(40)
        }
        
        textStack.snp.makeConstraints { make in
            make.left.equalTo(bookImageView.snp.right).offset(16)
            make.top.greaterThanOrEqualToSuperview().offset(12)
            make.right.equalToSuperview().inset(12)
            make.centerY.equalTo(bookImageView.snp.centerY)
        }
        
        // Add rotation for ribbon effect
        discountBadge.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 12))
    }
    
    func configure(with book: Book, isSelected: Bool) {
        bookImageView.image = UIImage(named: book.coverImageName)
        titleLabel.text = book.title
        authorLabel.text = book.author
        priceLabel.text = book.price
        
        if let old = book.oldPrice, !old.isEmpty {
            let attribute = NSAttributedString(
                string: old,
                attributes: [
                    .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                    .foregroundColor: UIColor.red
                ]
            )
            oldPriceLabel.attributedText = attribute
            oldPriceLabel.isHidden = false
        } else {
            oldPriceLabel.attributedText = nil
            oldPriceLabel.isHidden = true
        }
        
        // Show discount badge like BookCardCell
        if let discount = book.discountText {
            discountBadge.text = discount
            discountBadge.isHidden = false
        } else {
            discountBadge.isHidden = true
        }
        
        let icon = isSelected ? "checkmark.circle.fill" : "circle"
        checkButton.setImage(UIImage(systemName: icon), for: .normal)
    }
}
