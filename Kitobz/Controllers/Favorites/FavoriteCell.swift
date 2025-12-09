//
//  FavoriteCell.swift
//  Kitobz
//
//  Created by Madina on 09/12/25.
//

import UIKit

protocol FavoriteCellDelegate: AnyObject {
    func favoriteCellDidToggleFavorite(_ cell: FavoriteCell)
}

final class FavoriteCell: UITableViewCell {
    static let reuseId = "FavoriteCell"

    weak var delegate: FavoriteCellDelegate?

    private let coverImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 8
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 16, weight: .semibold)
        l.numberOfLines = 2
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let authorLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 13)
        l.textColor = .secondaryLabel
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let priceLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 15, weight: .medium)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    // Heart button
    private lazy var heartButton: UIButton = {
        let b = UIButton(type: .system)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.addTarget(self, action: #selector(didTapHeart), for: .touchUpInside)
        b.tintColor = .systemRed
        return b
    }()

    private var currentBook: Book?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        selectionStyle = .none
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setupLayout() {
        contentView.addSubview(coverImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(authorLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(heartButton)

        NSLayoutConstraint.activate([
            coverImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            coverImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            coverImageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -12),
            coverImageView.widthAnchor.constraint(equalToConstant: 56),
            coverImageView.heightAnchor.constraint(equalToConstant: 80),

            heartButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            heartButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            heartButton.widthAnchor.constraint(equalToConstant: 34),
            heartButton.heightAnchor.constraint(equalToConstant: 34),

            titleLabel.leadingAnchor.constraint(equalTo: coverImageView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: heartButton.leadingAnchor, constant: -12),
            titleLabel.topAnchor.constraint(equalTo: coverImageView.topAnchor),

            authorLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),

            priceLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            priceLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 8),
            priceLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -12)
        ])
    }

    func configure(with book: Book, isFavorite: Bool) {
        currentBook = book
        titleLabel.text = book.title
        authorLabel.text = book.author
        priceLabel.text = "\(book.price) сомони"
        coverImageView.image = (book.imageName != nil) ? UIImage(named: book.imageName!) : UIImage(systemName: "book")
        let heartName = isFavorite ? "heart.fill" : "heart"
        heartButton.setImage(UIImage(systemName: heartName)?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 18, weight: .regular)), for: .normal)
    }

    @objc private func didTapHeart() {
        // анимация и делегирование
        UIView.animate(withDuration: 0.12, animations: {
            self.heartButton.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        }, completion: { _ in
            UIView.animate(withDuration: 0.12) {
                self.heartButton.transform = .identity
            }
            self.delegate?.favoriteCellDidToggleFavorite(self)
        })
    }
    
    
}
