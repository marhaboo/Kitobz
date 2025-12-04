//
//  SocialMediaCardCell.swift
//  Kitobz
//
//  Created by Boymurodova Marhabo on 04/12/25.
//

import UIKit
import SnapKit

final class SocialMediaCardCell: UICollectionViewCell {
    
    static let identifier = "SocialMediaCardCell"
    
    // MARK: - UI Components
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.08
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 8
        return view
    }()
    
    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let platformLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .label
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupViews() {
        contentView.addSubview(containerView)
        containerView.addSubview(iconImageView)
        containerView.addSubview(platformLabel)
        containerView.addSubview(usernameLabel)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.size.equalTo(50)
        }
        
        platformLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(16)
            make.trailing.equalToSuperview().inset(16)
            make.top.equalToSuperview().offset(20)
        }
        
        usernameLabel.snp.makeConstraints { make in
            make.leading.equalTo(platformLabel)
            make.trailing.equalToSuperview().inset(16)
            make.top.equalTo(platformLabel.snp.bottom).offset(4)
        }
    }
    
    // MARK: - Configuration
    func configure(with item: SocialMediaItem) {
        platformLabel.text = item.platform
        usernameLabel.text = item.username
        iconImageView.image = UIImage(named: item.iconName)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        platformLabel.text = nil
        usernameLabel.text = nil
        iconImageView.image = nil
    }
}
