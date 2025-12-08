//
//  ProfileCell.swift
//  Kitobz
//
//  Created by Ilmhona 12 on 04/12/25.
//

import UIKit
import SnapKit

class ProfileCell: UITableViewCell {
    
    static let id = "ProfileCellID"
    
    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .systemGray // Иконки по умолчанию серые
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = .label
        return label
    }()
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        // Устанавливаем иконку
        iconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        // Устанавливаем заголовок
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(15)
            make.trailing.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
        }
        
        // Добавляем стрелочку вправо по умолчанию
        accessoryType = .disclosureIndicator
    }
    
    // MARK: - Configuration
    
    func configure(with item: ProfileMenuItem) {
        titleLabel.text = item.title
        iconImageView.image = UIImage(systemName: item.iconName)
        
        if item.isDestructive {
            titleLabel.textColor = .systemRed
            iconImageView.tintColor = .systemRed
        } else {
            titleLabel.textColor = .label
            iconImageView.tintColor = .systemGray
        }
    }
}
