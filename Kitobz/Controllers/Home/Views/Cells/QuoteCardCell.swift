//
//  QuoteItem.swift
//  Kitobz
//
//  Created by Boymurodova Marhabo on 02/12/25.
//

import UIKit
import SnapKit


// MARK: - PaddedLabel
final class PaddedLabel: UILabel {
    var textInsets: UIEdgeInsets = .zero {
        didSet { invalidateIntrinsicContentSize() }
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
    }
    
    override var intrinsicContentSize: CGSize {
        let base = super.intrinsicContentSize
        return CGSize(width: base.width + textInsets.left + textInsets.right,
                      height: base.height + textInsets.top + textInsets.bottom)
    }
}

final class QuoteCardCell: UICollectionViewCell {
    
    static let id = "QuoteCardCell"
    
    // Card background
    private let cardView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(named: "cardBg") ?? UIColor.systemBackground
        v.layer.cornerRadius = 14
        v.layer.masksToBounds = true
        
        let bgImageView = UIImageView(image: UIImage(named: "cardBgImage"))
           bgImageView.contentMode = .scaleAspectFill
           bgImageView.clipsToBounds = true
           v.addSubview(bgImageView)
           bgImageView.translatesAutoresizingMaskIntoConstraints = false
           NSLayoutConstraint.activate([
               bgImageView.topAnchor.constraint(equalTo: v.topAnchor),
               bgImageView.bottomAnchor.constraint(equalTo: v.bottomAnchor),
               bgImageView.leadingAnchor.constraint(equalTo: v.leadingAnchor),
               bgImageView.trailingAnchor.constraint(equalTo: v.trailingAnchor)
           ])

           return v
    }()
    
    // Author image (circular)
    private let avatarImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 92/2
        iv.backgroundColor = .secondarySystemBackground
        return iv
    }()
    
    // Quote label
    private let quoteLabel: UILabel = {
        let l = UILabel()
        l.textColor = .label
        l.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        l.numberOfLines = .zero
        l.textAlignment = .left
        l.lineBreakMode = .byTruncatingTail
        return l
    }()
    
    // Author badge (padded)
    private let authorBadge: PaddedLabel = {
        let l = PaddedLabel()
        l.textAlignment = .center
        l.textColor = .white
        l.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        l.backgroundColor = UIColor(named: "AccentColor2")
        l.layer.cornerRadius = 10
        l.layer.masksToBounds = true
        l.textInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        l.setContentHuggingPriority(.required, for: .vertical)
        l.setContentCompressionResistancePriority(.required, for: .vertical)
        return l
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)


        contentView.addSubview(cardView)
        cardView.addSubview(avatarImageView)
        cardView.addSubview(quoteLabel)
        cardView.addSubview(authorBadge)

        setupConstraints()
        layoutIfNeeded()

        avatarImageView.layer.cornerRadius = 92/2
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        cardView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        avatarImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 92, height: 92))
        }
        
        quoteLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14)
            make.leading.equalTo(avatarImageView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(28)
            make.centerY.equalToSuperview()
            make.bottom.equalTo(authorBadge.snp.top)
            
        }
        quoteLabel.setContentCompressionResistancePriority(.required, for: .vertical)

        
        authorBadge.snp.makeConstraints { make in
            make.top.equalTo(quoteLabel.snp.bottom)
            make.leading.equalTo(quoteLabel).offset(16)
            make.trailing.equalTo(quoteLabel).inset(16)
            make.height.equalTo(20)
            make.bottom.equalToSuperview().inset(25)
        }
        


    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.height / 2
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImageView.image = nil
        quoteLabel.text = nil
        authorBadge.text = nil
    }
    
    func configure(with item: Quote) {
        avatarImageView.image = UIImage(named: item.authorImageName)
        quoteLabel.text = "«\(item.text)»"
        authorBadge.text = item.authorName.uppercased()
    }
}
