//  HomeViewController.swift
//  Kitobz
//
//  Created by Boymuroдова Marhabo on 01/12/25.
//

import UIKit
import SnapKit

final class HomeViewController: UIViewController {

    private var themeToggleButton: UIBarButtonItem?

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let bannerSection = BannerSectionView()
    private let bestBooksSection = BookSectionView(title: "Лучшие книги")
    private let recommendedSection = BookSectionView(title: "Рекомендуем")
    private let discountSection = BookSectionView(title: "Скидки")
    private let reviewSection = ReviewSectionView()
    private let quoteSection = QuoteSectionView()
    private let roundCardSection = RoundCardSectionView()
    private let socialMediaSection = SocialMediaSectionView()

    private var banners: [Banner] = []
    private var allBooks: [Book] = []
    private var bestBooks: [Book] = []
    private var recommendedBooks: [Book] = []
    private var discountBooks: [Book] = []
    private var reviews: [ReviewItem] = []
    private var quotes: [Quote] = []
    private var roundCardItems: [RoundCardItem] = []
    private var socialMediaItems: [SocialMediaItem] = []
    private var stories: [Story] = []
    private weak var storiesNavController: UINavigationController?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "Background")
        configureNavigationBar()
        setupScrollView()
        setupSections()
        loadData()
        setupBookTapHandlers()
        setupStoriesTapHandler()
        setupShowAllHandlers()
        setupReviewsSection()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Ensure icon and appearance are in sync if changed elsewhere (e.g., Settings)
        updateThemeToggleIcon()
        applyAppearanceForCurrentStyle()
    }

    private func configureNavigationBar() {
        let bar = navigationController?.navigationBar
        bar?.prefersLargeTitles = false
        bar?.tintColor = UIColor.label

        let menuButton = UIButton(type: .system)
        menuButton.setImage(UIImage(systemName: "line.horizontal.3"), for: .normal)
        menuButton.tintColor = UIColor.label
        menuButton.addTarget(self, action: #selector(didTapThemeToggle), for: .touchUpInside)
        menuButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 28, height: 28))
        }
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: menuButton)

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
        appearance.backgroundColor = UIColor(named: "Background")
        appearance.titleTextAttributes = [.foregroundColor: UIColor.label]
        appearance.shadowColor = UIColor.separator.withAlphaComponent(0.2)

        let bar = navigationController?.navigationBar
        bar?.standardAppearance = appearance
        bar?.scrollEdgeAppearance = appearance
        bar?.compactAppearance = appearance
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
        view.backgroundColor = UIColor(named: "Background")
        updateThemeToggleIcon()
        applyAppearanceForCurrentStyle()
    }

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

    private func setupSections() {
        let sections: [UIView] = [
            bannerSection,
            roundCardSection,
            bestBooksSection,
            recommendedSection,
            discountSection,
            reviewSection,
            socialMediaSection,
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

    private func loadData() {
        let baseBooks = BooksProvider.baseBooks()

        reviews = ReviewsProvider.loadReviews(for: baseBooks)

        let reviewsByBookId: [String: [ReviewItem]] = Dictionary(grouping: reviews, by: { $0.bookId })

        let updatedBooks: [Book] = baseBooks.map { book in
            let bookReviews = reviewsByBookId[book.id] ?? []
            let newRating: Double
            if !bookReviews.isEmpty {
                let sum = bookReviews.reduce(0) { $0 + $1.rating }
                let avg = Double(sum) / Double(bookReviews.count)
                newRating = avg
            } else {
                newRating = book.rating
            }

            return Book(
                coverImageName: book.coverImageName,
                title: book.title,
                author: book.author,
                price: book.price,
                oldPrice: book.oldPrice,
                discountText: book.discountText,
                id: book.id,
                bookDescription: book.bookDescription,
                rating: newRating,
                ageRating: book.ageRating,
                language: book.language,
                coverType: book.coverType,
                pageCount: book.pageCount,
                publishYear: book.publishYear,
                reviews: bookReviews,
                quotes: book.quotes,
                otherBooksByAuthor: book.otherBooksByAuthor,
                isFavorite: FavoritesManager.shared.isFavorite(bookID: book.id) || book.isFavorite
            )
        }

        allBooks = updatedBooks

        if allBooks.count >= 5 {
            bestBooks = [allBooks[0], allBooks[3], allBooks[0], allBooks[4]]
            recommendedBooks = [allBooks[4], allBooks[3], allBooks[0], allBooks[4]]
            discountBooks = [allBooks[1], allBooks[2], allBooks[1], allBooks[2]]
        } else {
            bestBooks = allBooks
            recommendedBooks = allBooks
            discountBooks = allBooks
        }

        banners = BannersProvider.loadBanners()
        quotes = QuotesProvider.loadQuotes()
        roundCardItems = RoundCardsProvider.loadItems()
        socialMediaItems = SocialMediaProvider.loadItems()

        stories = StoriesProvider.loadStories()
        roundCardSection.items = stories.map { RoundCardItem(title: $0.title, imageName: $0.coverImageName) }
        roundCardSection.seenFlags = stories.map { $0.isSeen }

        bannerSection.setBanners(banners)
        bestBooksSection.setBooks(bestBooks)
        recommendedSection.setBooks(recommendedBooks)
        discountSection.setBooks(discountBooks)
        socialMediaSection.items = socialMediaItems
        reviewSection.items = reviews
        quoteSection.setQuotes(quotes)
    }

    private func setupBookTapHandlers() {
        bestBooksSection.onBookSelected = { [weak self] book in
            self?.openBookDetail(book)
        }
        recommendedSection.onBookSelected = { [weak self] book in
            self?.openBookDetail(book)
        }
        discountSection.onBookSelected = { [weak self] book in
            self?.openBookDetail(book)
        }
    }

    private func setupStoriesTapHandler() {
        roundCardSection.onItemSelected = { [weak self] index in
            self?.presentStory(at: index)
        }
    }

    private func setupShowAllHandlers() {
        bestBooksSection.onShowAll = { [weak self] books, title in
            self?.showAllBooks(books, title: title)
        }
        recommendedSection.onShowAll = { [weak self] books, title in
            self?.showAllBooks(books, title: title)
        }
        discountSection.onShowAll = { [weak self] books, title in
            self?.showAllBooks(books, title: title)
        }
    }

    private func setupReviewsSection() {
        reviewSection.presentingViewController = self
        
        reviewSection.onTapShowAllReviews = { [weak self] in
            guard let self = self else { return }
            
            let allReviewsVC = AllReviewsViewController(
                bookTitle: "Все отзывы",
                reviews: self.reviews
            )
            self.navigationController?.pushViewController(allReviewsVC, animated: true)
        }
    }

    private func showAllBooks(_ books: [Book], title: String) {
        let vc = AllBooksViewController(title: title, books: books)
        navigationController?.pushViewController(vc, animated: true)
    }

    private func presentStory(at index: Int) {
        guard index >= 0, index < stories.count else { return }
        let story = stories[index]
        let viewer = StoriesViewerViewController(story: story)

        viewer.onFinished = { [weak self] in
            guard let self = self else { return }
            self.stories[index].isSeen = true
            self.roundCardSection.seenFlags[index] = true
            self.roundCardSection.reloadItem(at: index)

            if let nav = self.storiesNavController, nav.viewControllers.count <= 1 {
                nav.dismiss(animated: true)
            }
        }

        viewer.onRequestNextStory = { [weak self] in
            guard let self = self else { return }
            let nextIndex = index + 1
            if nextIndex < self.stories.count {
                self.pushNextStory(at: nextIndex)
            } else {
                self.storiesNavController?.dismiss(animated: true)
            }
        }

        if let nav = storiesNavController {
            nav.pushViewController(viewer, animated: true)
        } else {
            let nav = UINavigationController(rootViewController: viewer)
            nav.isNavigationBarHidden = true
            nav.modalPresentationStyle = .fullScreen
            self.storiesNavController = nav
            present(nav, animated: true)
        }
    }

    private func pushNextStory(at index: Int) {
        guard index >= 0, index < stories.count else { return }
        guard let nav = storiesNavController else {
            presentStory(at: index)
            return
        }
        let story = stories[index]
        let viewer = StoriesViewerViewController(story: story)

        viewer.onFinished = { [weak self] in
            guard let self = self else { return }
            self.stories[index].isSeen = true
            self.roundCardSection.seenFlags[index] = true
            self.roundCardSection.reloadItem(at: index)

            if nav.viewControllers.count <= 1 {
                nav.dismiss(animated: true)
            }
        }

        viewer.onRequestNextStory = { [weak self] in
            guard let self = self else { return }
            let nextIndex = index + 1
            if nextIndex < self.stories.count {
                self.pushNextStory(at: nextIndex)
            } else {
                nav.dismiss(animated: true)
            }
        }

        nav.pushViewController(viewer, animated: true)
    }

    private func openBookDetail(_ book: Book) {
        let filtered = reviews.filter { $0.bookId == book.id }
        let vc = BookDetailViewController(book: book, reviews: filtered)
        navigationController?.pushViewController(vc, animated: true)
    }

    // Toggle theme like in Settings: persist and apply at window level
    @objc private func didTapThemeToggle() {
        let current = UserDefaults.standard.bool(forKey: "darkMode")
        let newValue = !current
        UserDefaults.standard.set(newValue, forKey: "darkMode")

        if let window = view.window ?? UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first?.windows.first {
            UIView.transition(with: window, duration: 0.3, options: [.transitionCrossDissolve, .allowAnimatedContent]) {
                window.overrideUserInterfaceStyle = newValue ? .dark : .light
            }
        } else {
            // Fallback: apply to nav and self if window not yet available
            overrideUserInterfaceStyle = newValue ? .dark : .light
            navigationController?.overrideUserInterfaceStyle = overrideUserInterfaceStyle
        }

        updateThemeToggleIcon()
        applyAppearanceForCurrentStyle()
    }
}

