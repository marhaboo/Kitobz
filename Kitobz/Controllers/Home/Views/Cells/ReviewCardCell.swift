//
//  ReviewCardCell.swift
//  Kitobz
//
//  Created by Boyмuroдова Marhabo on 04/12/25.
//

import UIKit
import SnapKit

final class ReviewCardCell: UICollectionViewCell {
    static let id = "ReviewCardCell"
    
    var onMoreTapped: (() -> Void)?

    private var fullText: String = ""

    private let cardView: UIView = {
        let v = UIView()
        v.layer.cornerRadius = 24
        v.layer.masksToBounds = true
        v.backgroundColor = UIColor(named: "cardBg") ?? .secondarySystemBackground
        return v
    }()

    private let avatarView = InitialsAvatarView()
    
    private let nameLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 16, weight: .semibold)
        l.textColor = .label
        l.numberOfLines = 1
        return l
    }()

    private let dateLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 12, weight: .regular)
        l.textColor = .secondaryLabel
        l.numberOfLines = 1
        return l
    }()

    private let starsStack: UIStackView = {
        let s = UIStackView()
        s.axis = .horizontal
        s.alignment = .center
        s.spacing = 4
        return s
    }()
    
    private let reviewLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 14, weight: .regular)
        l.textColor = .label
        l.numberOfLines = 3
        l.lineBreakMode = .byWordWrapping
        return l
    }()
    
    private let moreButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("Далее", for: .normal)
        b.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        b.setTitleColor(UIColor(named: "AccentColor") ?? .systemBlue, for: .normal)
        b.contentEdgeInsets = .zero
        b.titleEdgeInsets = .zero
        b.contentHorizontalAlignment = .leading
        return b
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(cardView)
        
        let nameDateStack = UIStackView(arrangedSubviews: [nameLabel, dateLabel])
        nameDateStack.axis = .vertical
        nameDateStack.spacing = 2
        
        let headerLeft = UIStackView(arrangedSubviews: [avatarView, nameDateStack])
        headerLeft.axis = .horizontal
        headerLeft.alignment = .center
        headerLeft.spacing = 12
        
        let header = UIStackView(arrangedSubviews: [headerLeft, UIView(), starsStack])
        header.axis = .horizontal
        header.alignment = .center
        header.spacing = 8
        
        let body = UIStackView(arrangedSubviews: [reviewLabel, moreButton])
        body.axis = .vertical
        body.spacing = 0
        body.alignment = .leading
        
        let container = UIStackView(arrangedSubviews: [header, body])
        container.axis = .vertical
        container.spacing = 12
        container.alignment = .fill
        
        cardView.addSubview(container)
        
        cardView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 8))
        }
        avatarView.snp.makeConstraints { make in
            make.width.height.equalTo(36)
        }
        container.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(18)
            make.bottom.lessThanOrEqualToSuperview().inset(12)
        }
        
        for _ in 0..<5 {
            let iv = UIImageView(image: UIImage(systemName: "star.fill"))
            iv.tintColor = .systemYellow
            iv.contentMode = .scaleAspectFit
            iv.snp.makeConstraints { make in
                make.width.height.equalTo(14)
            }
            starsStack.addArrangedSubview(iv)
        }
        
        moreButton.addTarget(self, action: #selector(didTapMore), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapCard))
        cardView.addGestureRecognizer(tapGesture)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        dateLabel.text = nil
        reviewLabel.text = nil
        fullText = ""
        moreButton.isHidden = false
        updateStars(rating: 0)
    }
    
    func configure(with item: ReviewItem) {
        nameLabel.text = item.userName
        dateLabel.text = item.date
        avatarView.setInitials(from: item.userName)
        
        fullText = item.reviewText
        reviewLabel.text = item.reviewText
        
        updateStars(rating: item.rating)
        
        DispatchQueue.main.async { [weak self] in
            self?.updateMoreButtonVisibility()
        }
    }
    
    private func updateMoreButtonVisibility() {
        let shouldShowMore = textExceedsLines(
            text: fullText,
            label: reviewLabel,
            maxLines: 3
        )
        moreButton.isHidden = !shouldShowMore
    }
    
    private func textExceedsLines(text: String, label: UILabel, maxLines: Int) -> Bool {
        let font = label.font ?? UIFont.systemFont(ofSize: 14)
        let maxHeight = font.lineHeight * CGFloat(maxLines)
        
        let width = label.bounds.width
        guard width > 0 else { return false }
        
        let bounding = (text as NSString).boundingRect(
            with: CGSize(width: width, height: .greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [.font: font],
            context: nil
        )
        
        return bounding.height > maxHeight + 1
    }
    
    private func updateStars(rating: Int) {
        let clamped = max(0, min(5, rating))
        for (i, v) in starsStack.arrangedSubviews.enumerated() {
            guard let iv = v as? UIImageView else { continue }
            iv.image = UIImage(systemName: i < clamped ? "star.fill" : "star")
            iv.tintColor = .systemYellow
        }
    }
    
    @objc private func didTapMore() {
        onMoreTapped?()
    }
    
    @objc private func didTapCard() {
        onMoreTapped?()
    }
}

private final class InitialsAvatarView: UIView {
    private let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.systemGray4
        layer.cornerRadius = 18
        layer.masksToBounds = true
        
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textAlignment = .center
        label.textColor = .white
        
        addSubview(label)
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(4)
        }
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func setInitials(from name: String) {
        let parts = name.split(separator: " ")
        let initials = parts.prefix(2).compactMap { $0.first }.map { String($0) }.joined()
        label.text = initials.isEmpty ? "?" : initials.uppercased()
        backgroundColor = color(for: name)
    }
    
    private func color(for string: String) -> UIColor {
        let hash = abs(string.hashValue)
        let hue = CGFloat(hash % 256) / 256.0
        return UIColor(hue: hue, saturation: 0.5, brightness: 0.75, alpha: 1)
    }
}
