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
    
    // MARK: - Callbacks
    var onMoreTapped: (() -> Void)?

    // MARK: - State
    private var fullText: String = ""

    // MARK: - Views
    
    private let cardView: UIView = {
        let v = UIView()
        v.layer.cornerRadius = 24
        v.layer.masksToBounds = true
        v.backgroundColor = UIColor(named: "cardBg") ?? .secondarySystemBackground
        return v
    }()

    // Header
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
    
    // Body
    private let reviewPrimaryLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 15, weight: .regular)
        l.textColor = .label
        l.numberOfLines = 3
        l.lineBreakMode = .byTruncatingTail
        return l
    }()
    
    private let reviewSecondaryLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 15, weight: .regular)
        l.textColor = .secondaryLabel
        l.numberOfLines = 1
        l.lineBreakMode = .byTruncatingTail
        return l
    }()
    
    private let moreButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("Далее", for: .normal)
        b.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        b.setTitleColor(UIColor(named: "AccentColor") ?? .systemBlue, for: .normal)
        b.contentEdgeInsets = .zero
        b.contentHorizontalAlignment = .leading
        return b
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(cardView)
        
        // Header
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
        
        // Body
        let body = UIStackView(arrangedSubviews: [reviewPrimaryLabel, reviewSecondaryLabel, moreButton])
        body.axis = .vertical
        body.spacing = 6
        
        let container = UIStackView(arrangedSubviews: [header, body])
        container.axis = .vertical
        container.spacing = 12
        
        cardView.addSubview(container)
        
        // Constraints
        cardView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
        avatarView.snp.makeConstraints { make in
            make.width.height.equalTo(40)
        }
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
        
        // Stars
        for _ in 0..<5 {
            let iv = UIImageView(image: UIImage(systemName: "star.fill"))
            iv.tintColor = .systemYellow
            iv.contentMode = .scaleAspectFit
            iv.snp.makeConstraints { make in
                make.width.height.equalTo(16)
            }
            starsStack.addArrangedSubview(iv)
        }
        
        moreButton.addTarget(self, action: #selector(didTapMore), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        dateLabel.text = nil
        reviewPrimaryLabel.text = nil
        reviewSecondaryLabel.text = nil
        fullText = ""
        updateStars(rating: 0)
    }
    
    func configure(with item: ReviewItem) {
        nameLabel.text = item.userName
        dateLabel.text = item.date
        avatarView.setInitials(from: item.userName)
        
        fullText = item.reviewText
        let (first, second) = split(text: item.reviewText)
        reviewPrimaryLabel.text = first
        reviewSecondaryLabel.text = second
        
        updateStars(rating: item.rating)
    }
    
    private func updateStars(rating: Int) {
        let clamped = max(0, min(5, rating))
        for (i, v) in starsStack.arrangedSubviews.enumerated() {
            guard let iv = v as? UIImageView else { continue }
            iv.image = UIImage(systemName: i < clamped ? "star.fill" : "star")
            iv.tintColor = .systemYellow
        }
    }
    
    private func split(text: String) -> (String, String) {
        if let range = text.firstIndex(of: "。") ?? text.firstIndex(of: ".") {
            let first = String(text[..<text.index(after: range)]).trimmingCharacters(in: .whitespacesAndNewlines)
            let second = String(text[text.index(after: range)...]).trimmingCharacters(in: .whitespacesAndNewlines)
            return (first, second)
        }
        let cut = min(max(0, text.count * 7 / 10), text.count)
        let idx = text.index(text.startIndex, offsetBy: cut)
        let first = String(text[..<idx]).trimmingCharacters(in: .whitespacesAndNewlines)
        let second = String(text[idx...]).trimmingCharacters(in: .whitespacesAndNewlines)
        return (first, second)
    }
    
    // MARK: - Actions
    @objc private func didTapMore() {
        // Вместо разворота — вызываем колбэк для перехода на экран "Все отзывы"
        onMoreTapped?()
    }
}

// MARK: - Helpers
private final class InitialsAvatarView: UIView {
    private let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.systemGray4
        layer.cornerRadius = 20
        layer.masksToBounds = true
        
        label.font = .systemFont(ofSize: 16, weight: .semibold)
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

