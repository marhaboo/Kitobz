//
//  BookDetailViewController.swift
//  Kitobz
//
//  Created by Boymurodova Marhabo on 05/12/25.
//

import UIKit
import SnapKit

final class BookDetailViewController: UIViewController {

    private let book: Book
    private let injectedReviews: [ReviewItem]?

    // MARK: - UI Elements
    private let backgroundImageView = UIImageView()
    private let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    private let bookImageView = UIImageView()
    private let bookTitleLabel = UILabel()
    private let authorLabel = UILabel()
    private let backButton = UIButton(type: .system)
    private let favoriteButton = UIButton(type: .system)

    private let ratingView = RatingView()
    private let reviewsView = CharacteristicItemView()
    private let pagesView = CharacteristicItemView()
    private let ageView = CharacteristicItemView()
    private let characteristicsStack = UIStackView()

    private let languageLabel = UILabel()
    private let yearLabel = UILabel()
    private let separatorLabel = UILabel()

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let bottomCardView = UIView()

    private let sectionTitleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let readMoreButton = UIButton(type: .system)

    private var isExpanded = false

    init(book: Book, reviews: [ReviewItem]? = nil) {
        self.book = book
        self.injectedReviews = reviews
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindData()
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground

        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view)
            $0.leading.trailing.bottom.equalToSuperview()
        }

        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }

        contentView.addSubview(backgroundImageView)
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.clipsToBounds = true
        backgroundImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(440)
        }

        contentView.addSubview(blurView)
        blurView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(440)
        }

        contentView.addSubviews([bookImageView, bookTitleLabel, authorLabel, backButton, favoriteButton])

        bookImageView.contentMode = .scaleAspectFill
        bookImageView.layer.cornerRadius = 12
        bookImageView.clipsToBounds = true
        bookImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(contentView.snp.top).offset(80)
            $0.width.equalTo(140)
            $0.height.equalTo(210)
        }

        bookTitleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        bookTitleLabel.textColor = .white
        bookTitleLabel.textAlignment = .center
        bookTitleLabel.numberOfLines = 2
        bookTitleLabel.snp.makeConstraints {
            $0.top.equalTo(bookImageView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(24)
        }

        authorLabel.font = .systemFont(ofSize: 16, weight: .medium)
        authorLabel.textColor = .white
        authorLabel.textAlignment = .center
        authorLabel.snp.makeConstraints {
            $0.top.equalTo(bookTitleLabel.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview().inset(24)
        }

        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = .white
        backButton.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        backButton.layer.cornerRadius = 20
        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        backButton.snp.makeConstraints {
            $0.top.equalTo(contentView).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.width.height.equalTo(40)
        }

        favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        favoriteButton.tintColor = .white
        favoriteButton.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        favoriteButton.layer.cornerRadius = 20
        favoriteButton.addTarget(self, action: #selector(didTapFavorite), for: .touchUpInside)
        favoriteButton.snp.makeConstraints {
            $0.top.equalTo(contentView).offset(16)
            $0.trailing.equalToSuperview().inset(16)
            $0.width.height.equalTo(40)
        }

        // Bottom card
        contentView.addSubview(bottomCardView)
        bottomCardView.backgroundColor = .systemBackground
        bottomCardView.layer.cornerRadius = 24
        bottomCardView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        bottomCardView.clipsToBounds = true
        bottomCardView.snp.makeConstraints {
            $0.top.equalTo(authorLabel.snp.bottom).offset(24)
            $0.leading.trailing.bottom.equalToSuperview()
        }

        // Characteristics
        bottomCardView.addSubview(characteristicsStack)
        characteristicsStack.axis = .horizontal
        characteristicsStack.distribution = .fillEqually
        characteristicsStack.alignment = .center
        characteristicsStack.spacing = 20
        characteristicsStack.snp.makeConstraints {
            $0.top.equalToSuperview().offset(18)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.greaterThanOrEqualTo(46)
        }
        characteristicsStack.addArrangedSubviews([ratingView, reviewsView, pagesView, ageView])

        // Language · Year
        separatorLabel.text = "·"
        separatorLabel.font = .systemFont(ofSize: 12)
        separatorLabel.textColor = .secondaryLabel
        languageLabel.font = .systemFont(ofSize: 12)
        languageLabel.textColor = .secondaryLabel
        yearLabel.font = .systemFont(ofSize: 12)
        yearLabel.textColor = .secondaryLabel

        let languageYearStack = UIStackView(arrangedSubviews: [languageLabel, separatorLabel, yearLabel])
        languageYearStack.axis = .horizontal
        languageYearStack.spacing = 6
        languageYearStack.alignment = .center
        bottomCardView.addSubview(languageYearStack)
        languageYearStack.snp.makeConstraints {
            $0.top.equalTo(characteristicsStack.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }

        // "О книге"
        sectionTitleLabel.text = "О книге"
        sectionTitleLabel.font = .systemFont(ofSize: 22, weight: .bold)
        sectionTitleLabel.textAlignment = .left
        bottomCardView.addSubview(sectionTitleLabel)
        sectionTitleLabel.snp.makeConstraints {
            $0.top.equalTo(languageYearStack.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
        }

        // Description + Read More
        descriptionLabel.font = .systemFont(ofSize: 15)
        descriptionLabel.numberOfLines = 5
        descriptionLabel.lineBreakMode = .byTruncatingTail
        descriptionLabel.textColor = .secondaryLabel

        // Configure link-style button with UIButton.Configuration on iOS 15+
        if #available(iOS 15.0, *) {
            var conf = UIButton.Configuration.plain()
            conf.baseForegroundColor = UIColor(named: "AccentColor")
            conf.title = "Далее"
            conf.contentInsets = .zero
            conf.background.backgroundColor = .clear
            readMoreButton.configuration = conf
            readMoreButton.addTarget(self, action: #selector(toggleReadMore), for: .touchUpInside)
        } else {
            readMoreButton.setTitle("Далее", for: .normal)
            readMoreButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
            readMoreButton.setTitleColor(UIColor(named: "AccentColor"), for: .normal)
            readMoreButton.backgroundColor = .clear
            readMoreButton.contentEdgeInsets = .zero
            readMoreButton.addTarget(self, action: #selector(toggleReadMore), for: .touchUpInside)
        }

        bottomCardView.addSubview(descriptionLabel)
        bottomCardView.addSubview(readMoreButton)

        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(sectionTitleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        readMoreButton.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(6)
            $0.leading.equalTo(descriptionLabel)
            $0.bottom.equalToSuperview().inset(24)
        }
    }

    private func bindData() {
        backgroundImageView.image = UIImage(named: book.coverImageName)
        bookImageView.image = UIImage(named: book.coverImageName)
        bookTitleLabel.text = book.title
        authorLabel.text = book.author

        let reviewsToShow = injectedReviews ?? book.reviews

        ratingView.configure(stars: book.rating, count: reviewsToShow.count)
        reviewsView.configure(value: "\(reviewsToShow.count)", title: "отзывов", valueFont: 18, titleFont: 11)
        pagesView.configure(value: "\(book.pageCount)", title: "стр.", valueFont: 18, titleFont: 11)
        ageView.configure(value: "\(book.ageRating)", title: "возраст", valueFont: 18, titleFont: 11)

        languageLabel.text = book.language
        yearLabel.text = "\(book.publishYear) год"

        descriptionLabel.text = book.bookDescription.isEmpty ? "Описание отсутствует" : book.bookDescription

        // Сброс состояния разворота
        isExpanded = false
        descriptionLabel.numberOfLines = 5
        descriptionLabel.lineBreakMode = .byTruncatingTail
        if #available(iOS 15.0, *) {
            readMoreButton.configuration?.title = "Далее"
        } else {
            readMoreButton.setTitle("Далее", for: .normal)
        }

        // Обновить видимость кнопки после того, как лейаут построен
        view.layoutIfNeeded()
        updateReadMoreVisibility()
    }

    private func updateReadMoreVisibility() {
        let text = descriptionLabel.text ?? ""
        var width = bottomCardView.bounds.width - 40
        if width <= 0 {
            view.layoutIfNeeded()
            width = bottomCardView.bounds.width - 40
        }
        let shouldTruncate = textExceedsLines(text: text, width: max(width, 1), font: descriptionLabel.font, maxLines: 5)
        readMoreButton.isHidden = !shouldTruncate
    }

    private func textExceedsLines(text: String, width: CGFloat, font: UIFont, maxLines: Int) -> Bool {
        let maxHeight = font.lineHeight * CGFloat(maxLines)
        let bounding = (text as NSString).boundingRect(
            with: CGSize(width: width, height: .greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [.font: font],
            context: nil
        )
        return bounding.height > maxHeight + 1
    }

    @objc private func toggleReadMore() {
        // Anchor to the top of description to avoid jump
        let anchorInScroll = descriptionLabel.convert(CGPoint.zero, to: scrollView).y
        let originalOffsetY = scrollView.contentOffset.y
        let anchorDelta = anchorInScroll - originalOffsetY

        isExpanded.toggle()
        descriptionLabel.alpha = 0.98 // tiny fade to soften change
        descriptionLabel.numberOfLines = isExpanded ? 0 : 5
        descriptionLabel.lineBreakMode = isExpanded ? .byWordWrapping : .byTruncatingTail
        if #available(iOS 15.0, *) {
            readMoreButton.configuration?.title = isExpanded ? "Свернуть" : "Далее"
        } else {
            readMoreButton.setTitle(isExpanded ? "Свернуть" : "Далее", for: .normal)
        }

        // Disable implicit animations on layers that should not animate
        CATransaction.begin()
        CATransaction.setDisableActions(true)

        let animator = UIViewPropertyAnimator(duration: 0.28, curve: .easeInOut) {
            self.view.layoutIfNeeded()

            // Keep the same anchor position visible during the animation
            let newAnchorInScroll = self.descriptionLabel.convert(CGPoint.zero, to: self.scrollView).y
            let targetOffsetY = newAnchorInScroll - anchorDelta
            let clamped = max(0, min(targetOffsetY, self.scrollView.contentSize.height - self.scrollView.bounds.height))
            self.scrollView.contentOffset.y = clamped

            self.descriptionLabel.alpha = 1.0
        }

        animator.addCompletion { _ in
            CATransaction.commit()
        }

        animator.startAnimation()
    }

    @objc private func didTapBack() { navigationController?.popViewController(animated: true) }

    @objc private func didTapFavorite() {
        favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        favoriteButton.tintColor = .systemRed
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
}

private extension UIView {
    func addSubviews(_ views: [UIView]) { views.forEach { addSubview($0) } }
}

private extension UIStackView {
    func addArrangedSubviews(_ views: [UIView]) { views.forEach { addArrangedSubview($0) } }
}
