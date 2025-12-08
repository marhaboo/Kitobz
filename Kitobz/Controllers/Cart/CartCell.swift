//
//  CartCell.swift
//  Kitobz
//
//  Created by Ilmhona 11 on 12/8/25.
//

import UIKit
import SnapKit

class CartCell: UITableViewCell {
    
    private let bookImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "book1")
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 10
        image.clipsToBounds = true
        return image
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.numberOfLines = 1
        return label
    }()
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .darkGray
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .medium)
        return label
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        let icon = UIImage(systemName: "trash")
        button.setImage(icon, for: .normal)
        button.tintColor = .red
        return button
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: - Layout
    
    private func setupLayout() {
        
        contentView.addSubview(bookImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(authorLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(deleteButton)
        
        bookImageView.snp.makeConstraints { make in
            make.left.top.equalToSuperview().offset(15)
            make.width.height.equalTo(70)
            make.bottom.equalToSuperview().inset(15)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(15)
            make.width.height.equalTo(25)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(bookImageView.snp.top)
            make.left.equalTo(bookImageView.snp.right).offset(15)
            make.right.equalTo(deleteButton.snp.left).offset(-10)
        }
        
        authorLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(3)
            make.left.equalTo(titleLabel)
            make.right.equalTo(titleLabel)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(authorLabel.snp.bottom).offset(3)
            make.left.equalTo(titleLabel)
        }
    }
    
    // MARK: - Configure
    
    func configure(bookName: String, author: String, price: Int) {
        titleLabel.text = bookName
        authorLabel.text = author
        priceLabel.text = "\(price) сомони"
    }
}

