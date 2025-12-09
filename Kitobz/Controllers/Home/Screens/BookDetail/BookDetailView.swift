//
//  BookDetail.swift
//  Kitobz
//
//  Created by Boymurodova Marhabo on 05/12/25.
//


import UIKit
import SnapKit

final class BookDetailView: UIView {

    // MARK: - Public UI (accessed by controller)
    let scrollView = UIScrollView()
    let contentView = UIView()

    let coverImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 12
        iv.backgroundColor = .secondarySystemBackground
        return iv
    }()

    let titleLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 22, weight: .semibold)
        l.numberOfLines = 0
        l.textAlignment = .left
        return l
    }()

    let authorLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 15, weight: .regular)
        l.textColor = .secondaryLabel
        return l
    }()

    let ratingLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 14, weight: .medium)
        l.textColor = .systemYellow
        return l
    }()

    let priceLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 18, weight: .bold)
        l.textAlignment = .right
        return l
    }()

    let descriptionLabel: UILabel = {
        let l = UILabel()
        let font = UIFont.systemFont(ofSize: 15)
        l.font = font
        l.numberOfLines = 0
        return l
    }()

    // Buttons exposed so controller can bind actions
    let favoriteButton: UIButton = {
        let b = UIButton(type: .system)
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.bordered()
            config.title = "Добавить в избранное"
            config.cornerStyle = .large
            config.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 14, bottom: 12, trailing: 14)
            // Mimic border color
            b.configuration = config
            b.configurationUpdateHandler = { button in
                button.configuration?.baseForegroundColor = .label
            }
            b.layer.borderWidth = 1
            b.layer.cornerRadius = 10
            b.layer.borderColor = UIColor.separator.cgColor
            b.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        } else {
            b.setTitle("Добавить в избранное", for: .normal)
            b.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
            b.layer.cornerRadius = 10
            b.layer.borderWidth = 1
            b.layer.borderColor = UIColor.separator.cgColor
            b.contentEdgeInsets = UIEdgeInsets(top: 12, left: 14, bottom: 12, right: 14)
        }
        return b
    }()

    let readSampleButton: UIButton = {
        let b = UIButton(type: .system)
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.filled()
            config.title = "Читать отрывок"
            config.cornerStyle = .large
            config.baseBackgroundColor = .systemBlue
            config.baseForegroundColor = .white
            config.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 14, bottom: 12, trailing: 14)
            b.configuration = config
            b.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        } else {
            b.setTitle("Читать отрывок", for: .normal)
            b.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
            b.layer.cornerRadius = 10
            b.backgroundColor = .systemBlue
            b.tintColor = .white
            b.contentEdgeInsets = UIEdgeInsets(top: 12, left: 14, bottom: 12, right: 14)
        }
        return b
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        applyTheme()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
        applyTheme()
    }

    private func applyTheme() {
        backgroundColor = UIColor(named: "Background") ?? .systemBackground
    }

    private func setup() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)

        // add subviews to contentView
        [coverImageView, titleLabel, authorLabel, ratingLabel, priceLabel, descriptionLabel, favoriteButton, readSampleButton].forEach {
            contentView.addSubview($0)
        }

        // scrollView constraints
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }

        // contentView must have width equal to scrollView for vertical scrolling
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }

        // cover
        coverImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.centerX.equalToSuperview()
            make.width.equalTo(170)
            make.height.equalTo(260)
        }

        // title
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(coverImageView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        // author
        authorLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        ratingLabel.snp.makeConstraints { make in
            make.top.equalTo(authorLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().inset(16)
        }

        priceLabel.snp.makeConstraints { make in
            make.centerY.equalTo(ratingLabel)
            make.trailing.equalToSuperview().inset(16)
            make.leading.greaterThanOrEqualTo(ratingLabel.snp.trailing).offset(8)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(ratingLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        favoriteButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(16)
            make.height.equalTo(48)
            make.bottom.equalToSuperview().inset(24)
        }

        readSampleButton.snp.makeConstraints { make in
            make.leading.equalTo(favoriteButton.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalTo(favoriteButton)
            make.height.equalTo(favoriteButton)
            make.width.equalTo(favoriteButton)
        }
    }

    // MARK: - Configure
    func configure(with book: Book) {
        if let image = UIImage(named: book.coverImageName) {
            coverImageView.image = image
        } else {
            coverImageView.image = UIImage(systemName: "book")
        }

        titleLabel.text = book.title
        authorLabel.text = book.author

        if book.rating > 0 {
            ratingLabel.text = "★ \(String(format: "%.1f", book.rating))"
        } else {
            ratingLabel.text = ""
        }

        priceLabel.text = book.price
        descriptionLabel.text = book.bookDescription.isEmpty ? "Описание отсутствует" : book.bookDescription
    }
}
