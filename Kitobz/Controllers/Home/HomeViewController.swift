//
//  HomeViewController.swift
//  Kitobz
//
//  Created by Boymurodova Marhabo on 01/12/25.
//

import UIKit
import SnapKit

final class HomeViewController: UIViewController {

    // MARK: - Nav items
    private var themeToggleButton: UIBarButtonItem?

    // MARK: - ScrollView
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    // MARK: - Sections
    private let bannerSection = BannerSectionView()
    private let bestBooksSection = BookSectionView(title: "Лучшие книги")
    private let recommendedSection = BookSectionView(title: "Рекомендуем")
    private let discountSection = BookSectionView(title: "Скидки")
    private let reviewSection = ReviewSectionView()
    private let quoteSection = QuoteSectionView()
    private let roundCardSection = RoundCardSectionView()
    private let socialMediaSection = SocialMediaSectionView()

    // MARK: - Mock Data
    private var banners: [Banner] = [
        Banner(imageName: "banner"),
        Banner(imageName: "banner2"),
        Banner(imageName: "banner")
    ]

    private var bestBooks: [Book] = [
        .init(coverImageName: "book1", title: "Война и мир", author: "Лев Толстой", price: "75 TJS", oldPrice: nil, discountText: nil),
        .init(coverImageName: "book2", title: "Преступление и наказание", author: "Фёдор Достоевский", price: "63 TJS", oldPrice: nil, discountText: nil),
        .init(coverImageName: "book3", title: "Анна Каренина", author: "Лев Толстой", price: "52 TJS", oldPrice: nil, discountText: nil),
        .init(coverImageName: "book1", title: "Война и мир", author: "Лев Толстой", price: "75 TJS", oldPrice: nil, discountText: nil),
        .init(coverImageName: "book2", title: "Преступление и наказание", author: "Фёдор Достоевский", price: "63 TJS", oldPrice: nil, discountText: nil),
        .init(coverImageName: "book3", title: "Анна Каренина", author: "Лев Толстой", price: "52 TJS", oldPrice: nil, discountText: nil)
    ]

    private var recommendedBooks: [Book] = [
        .init(coverImageName: "book1", title: "451 градус по Фаренгейту", author: "Рэй Брэдбери", price: "42 TJS", oldPrice: nil, discountText: nil),
        .init(coverImageName: "book2", title: "Гарри Поттер", author: "Дж. К. Роулинг", price: "60 TJS", oldPrice: nil, discountText: nil),
        .init(coverImageName: "book1", title: "451 градус по Фаренгейту", author: "Рэй Брэдбери", price: "42 TJS", oldPrice: nil, discountText: nil),
        .init(coverImageName: "book2", title: "Гарри Поттер", author: "Дж. К. Роулинг", price: "60 TJS", oldPrice: nil, discountText: nil)
    ]

    private var discountBooks: [Book] = [
        .init(coverImageName: "book3", title: "Старик и море", author: "Эрнест Хемингуэй", price: "30 TJS", oldPrice: "45 TJS", discountText: "-33%"),
        .init(coverImageName: "book1", title: "Алхимик", author: "Пауло Коэльо", price: "35 TJS", oldPrice: "50 TJS", discountText: "-30%"),
        .init(coverImageName: "book3", title: "Старик и море", author: "Эрнест Хемингуэй", price: "30 TJS", oldPrice: "45 TJS", discountText: "-33%"),
        .init(coverImageName: "book1", title: "Алхимик", author: "Пауло Коэльо", price: "35 TJS", oldPrice: "50 TJS", discountText: "-30%")
    ]

    private var quotes: [Quote] = [
        .init(authorName: "АГАТА КРИСТИ", authorImageName: "author1", text: "Нет ничего более увлекательного, чем тайна, которую предстоит разгадать"),
        .init(authorName: "СЕРГЕЙ ЕСЕНИН", authorImageName: "author2", text: "Если тронуть страсти в человеке, то, конечно, правды не найдешь"),
        .init(authorName: "ФЁДОР ДОСТОЕВСКИЙ", authorImageName: "author3", text: "Перестать читать книги — значит перестать мыслить")
    ]
    
    private var roundCardItems: [RoundCardItem] = [
        .init(title: "Доставка", imageName: "Delivery"),
        .init(title: "Рассрочка", imageName: "Installment"),
        .init(title: "Соц. сети", imageName: "SocialMedia"),
        .init(title: "Гифт карты", imageName: "GiftCards"),
        .init(title: "Отзывы", imageName: "Reviews"),
        .init(title: "О нас", imageName: "AboutUs"),
        .init(title: "Аккаунт", imageName: "Account")
    ]

    private var reviews: [ReviewItem] = [
        .init(userName: "Shukrullo",
              date: "01.08.2025",
              bookCoverImageName: "book1",
              bookTitle: "Джордж Оруэлл: 1984 (М)",
              rating: 5,
              reviewText: "Первая книга которую я читал и до сих пор иногда читаю...",
              mood: .happy),
        .init(userName: "SGR",
              date: "01.07.2025",
              bookCoverImageName: "book2",
              bookTitle: "Элбом Митч: Вторники с Морри, или",
              rating: 5,
              reviewText: "Книга в целом простая по форме, но глубокая по содержанию. Чтение вызывает эмоции — от тёплой улыбки до слёз. Она будто напоминает что самое главное в жизни...",
              mood: .happy)
    ]
    
    private var socialMediaItems: [SocialMediaItem] = [
        .init(platform: "Instagram", iconName: "InstagramIcon", username: "@kitobz.tj"),
        .init(platform: "Facebook", iconName: "FacebookIcon", username: "@kitobz"),
        .init(platform: "Telegram", iconName: "TelegramIcon", username: "@kitobz"),
        .init(platform: "Viber", iconName: "ViberIcon", username: "+992903022298")
    ]

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "Background")
        configureNavigationBar()
        setupScrollView()
        setupSections()
        loadData()
    }

    // MARK: - Navigation Bar
    private func configureNavigationBar() {
        let bar = navigationController?.navigationBar
        bar?.prefersLargeTitles = false
        bar?.tintColor = UIColor.label

        // Left menu button
        let menuButton = UIButton(type: .system)
        menuButton.setImage(UIImage(systemName: "line.horizontal.3"), for: .normal)
        menuButton.tintColor = UIColor.label
        menuButton.addTarget(self, action: #selector(didTapThemeToggle), for: .touchUpInside)
        menuButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 28, height: 28))
        }
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: menuButton)

        // Center logo as titleView
        let logo = UIImageView(image: UIImage(named: "logo"))
        logo.contentMode = .scaleAspectFit
        let titleWrapper = UIView()
        
        titleWrapper.addSubview(logo)
        logo.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(26)
            make.width.lessThanOrEqualTo(120)
        }
        navigationItem.titleView = titleWrapper

        // Right theme toggle button
        let themeButton = UIButton(type: .system)
        themeButton.addTarget(self, action: #selector(didTapThemeToggle), for: .touchUpInside)
        themeButton.tintColor = UIColor.label
        themeButton.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 17, weight: .semibold), forImageIn: .normal)
        themeButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 28, height: 28))
        }
        let themeItem = UIBarButtonItem(customView: themeButton)
        self.themeToggleButton = themeItem
        navigationItem.rightBarButtonItem = themeItem
        updateThemeToggleIcon(on: themeButton)

        applyAppearanceForCurrentStyle()
    }

    private func applyAppearanceForCurrentStyle() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "Background") ?? .systemBackground
        appearance.shadowColor = UIColor.separator.withAlphaComponent(0.22)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.label]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.label]

        let bar = navigationController?.navigationBar
        bar?.standardAppearance = appearance
        bar?.compactAppearance = appearance
        bar?.scrollEdgeAppearance = appearance
        bar?.tintColor = UIColor.label
    }

    private func updateThemeToggleIcon(on button: UIButton? = nil) {
        let isDark = traitCollection.userInterfaceStyle == .dark
        let symbolName = isDark ? "sun.max" : "moon"
        let image = UIImage(systemName: symbolName)
        let target = button ?? (themeToggleButton?.customView as? UIButton)
        target?.setImage(image, for: .normal)
        target?.tintColor = UIColor.label
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateThemeToggleIcon()
        applyAppearanceForCurrentStyle()
    }

    // MARK: - ScrollView Setup
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        contentView.snp.makeConstraints { make in
            make.edges.width.equalToSuperview()
        }
    }

    // MARK: - Sections Layout
    private func setupSections() {
        let sections: [UIView] = [
            bannerSection,
            bestBooksSection,
            recommendedSection,
            roundCardSection,
            socialMediaSection,
            discountSection,
            reviewSection,
            quoteSection
        ]

        var lastView: UIView? = nil
        for section in sections {
            contentView.addSubview(section)
            section.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview()
                if let last = lastView {
                    make.top.equalTo(last.snp.bottom).offset(12)
                } else {
                    make.top.equalToSuperview().offset(12)
                }
            }
            lastView = section
        }

        lastView?.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(12)
        }
    }

    // MARK: - Load Data
    private func loadData() {
        bannerSection.setBanners(banners)
        bestBooksSection.setBooks(bestBooks)
        recommendedSection.setBooks(recommendedBooks)
        discountSection.setBooks(discountBooks)
        roundCardSection.items = roundCardItems
        socialMediaSection.items = socialMediaItems
        reviewSection.items = reviews
        quoteSection.setQuotes(quotes)
    }

    // MARK: - Actions
    @objc private func didTapThemeToggle() {
        let isDark = traitCollection.userInterfaceStyle == .dark
        overrideUserInterfaceStyle = isDark ? .light : .dark
        applyAppearanceForCurrentStyle()
        
        navigationController?.navigationBar.setNeedsLayout()
        navigationController?.navigationBar.layoutIfNeeded()

        if let button = themeToggleButton?.customView as? UIButton {
            updateThemeToggleIcon(on: button)
        }
    }
}

