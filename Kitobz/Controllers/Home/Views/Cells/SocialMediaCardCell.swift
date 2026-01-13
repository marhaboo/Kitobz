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
    
    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.tintColor = .label
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear
        contentView.addSubview(iconImageView)
        
        iconImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(48)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with item: SocialMediaItem) {
        iconImageView.image = UIImage(named: item.iconName)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
    }
}
