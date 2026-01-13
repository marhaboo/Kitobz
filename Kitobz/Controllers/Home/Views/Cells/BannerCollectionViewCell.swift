//
//  BannerCollectionViewCell.swift
//  Kitobz
//
//  Created by Boymurodova Marhabo on 02/12/25.
//

import UIKit

class BannerCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    static let id = "BannerCollectionViewCell"
    
    // MARK: - UI ELEMENTS
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 10
        return iv
    }()
    
    private let gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.6)]
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1)
        return gradient
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        imageView.layer.addSublayer(gradientLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.bounds
        gradientLayer.frame = imageView.bounds
    }

    func configure(with banner: Banner) {
        imageView.image = UIImage(named: banner.imageName)
    }
}
