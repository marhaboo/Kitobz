//
//  CartCell.swift
//  Kitobz
//
//  Created by Ilmhona 11 on 12/8/25.
//

import UIKit
import SnapKit

class CartCell: UITableViewCell {
    
    // Чекмарка-кружок
    private let checkButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .red
        button.setImage(UIImage(systemName: "circle"), for: .normal)
        return button
    }()
    
    private let bookImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "book1")
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 10
        image.clipsToBounds = true
        return image
    }()
    
    private let titleLabel = UILabel()
    private let authorLabel = UILabel()
    private let priceLabel = UILabel()
    
    // callback
    var onCheckTap: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        
        checkButton.addTarget(self, action: #selector(checkTapped), for: .touchUpInside)
    }
    
    @objc private func checkTapped() {
        onCheckTap?()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupLayout() {
        
        contentView.addSubview(checkButton)
        contentView.addSubview(bookImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(authorLabel)
        contentView.addSubview(priceLabel)
        
        checkButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(28)
        }
        
        bookImageView.snp.makeConstraints { make in
            make.left.equalTo(checkButton.snp.right).offset(12)
            make.top.equalToSuperview().offset(15)
            make.width.height.equalTo(70)
            make.bottom.equalToSuperview().inset(15)
        }
        
        titleLabel.font = .boldSystemFont(ofSize: 16)
        authorLabel.font = .systemFont(ofSize: 14)
        authorLabel.textColor = .darkGray
        priceLabel.font = .systemFont(ofSize: 15, weight: .medium)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(bookImageView.snp.top)
            make.left.equalTo(bookImageView.snp.right).offset(15)
            make.right.equalToSuperview().inset(15)
        }
        
        authorLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(3)
            make.left.equalTo(titleLabel)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(authorLabel.snp.bottom).offset(3)
            make.left.equalTo(titleLabel)
        }
    }
    
    func configure(bookName: String, author: String, price: Int, isSelected: Bool) {
        titleLabel.text = bookName
        authorLabel.text = author
        priceLabel.text = "\(price) сомони"
        
        let icon = isSelected ? "checkmark.circle.fill" : "circle"
        checkButton.setImage(UIImage(systemName: icon), for: .normal)
    }
}

