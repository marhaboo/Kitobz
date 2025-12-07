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

    private lazy var warAndPeace: Book = Book(
        coverImageName: "book1",
        title: "Война и мир",
        author: "Лев Толстой",
        price: "75 TJS",
        bookDescription: "«Война и мир» Л. Н. Толстого — книга на все времена. Кажется, что она существовала всегда, настолько знакомым кажется текст, едва мы открываем первые страницы романа, настолько памятны многие его эпизоды: охота и святки, первый бал Наташи Ростовой, лунная ночь в Отрадном, князь Андрей в сражении при Аустерлице... Сцены «мирной», семейной жизни сменяются картинами, имеющими значение для хода всей мировой истории, но для Толстого они равноценны, связаны в едином потоке времени. Каждый эпизод важен не только для развития сюжета, но и как одно из бесчисленных проявлений жизни, которая насыщена в каждом своем моменте и которую учит любить Толстой.",
        rating: 4.8,
        ageRating: "12+",
        language: "Русский",
        coverType: "Твёрдый",
        pageCount: 1225,
        publishYear: 1869
    )

    private lazy var crimeAndPunishment: Book = Book(
        coverImageName: "book2",
        title: "Преступление и наказание",
        author: "Фёдор Достоевский",
        price: "63 TJS",
        bookDescription: """
        "Преступление и наказание" - высочайший образец криминального романа. В рамках жанра полицейского расследования писатель поставил вопросы, и по сей день не решенные. Кем должен быть человек: "тварью дрожащей", как говорит Раскольников, или "Наполеоном"? И это проблема уже XXI века. Написанный в 1866 году роман "Преступление и наказание" до сих пор остается самой читаемой в мире книгой и входит в большинство школьных программ по литературе.
        """,
        rating: 4.7,
        ageRating: "16+",
        language: "Русский",
        coverType: "Мягкий",
        pageCount: 671,
        publishYear: 1866
    )

    private lazy var annaKarenina: Book = Book(
        coverImageName: "book3",
        title: "Анна Каренина",
        author: "Лев Толстой",
        price: "52 TJS",
        bookDescription: """
            "Анна Каренина" - лучший роман о женщине, написанный в XIX веке. По словам Ф.М.Достоевского, "Анна Каренина" поразила современников "не только вседневностью содержания, но и огромной психологической разработкой души человеческой, страшной глубиной и силой". Уже к началу 1900-х годов роман Толстого был переведен на многие языки мира, а в настоящее время входит в золотой фонд мировой литературы."
        """,
        rating: 4.6,
        ageRating: "14+",
        language: "Русский",
        coverType: "Твёрдый",
        pageCount: 864,
        publishYear: 1878
    )

    private lazy var fahrenheit451: Book = Book(
        coverImageName: "book4",
        title: "451 градус по Фаренгейту",
        author: "Рэй Брэдбери",
        price: "42 TJS",
        bookDescription: "Философская антиутопия Брэдбери рисует беспросветную картину развития постиндустриального общества. Роман, принесший своему творцу мировую известность.",
        rating: 4.5,
        ageRating: "16+",
        language: "Русский",
        coverType: "Мягкий",
        pageCount: 256,
        publishYear: 1953
    )

    private lazy var hpStone: Book = Book(
        coverImageName: "book5",
        title: "Гарри Поттер и философский камень",
        author: "Дж. К. Роулинг",
        price: "60 TJS",
        bookDescription: "Книга, покорившая мир, эталон литературы для читателей всех возрастов, синоним успеха. Книга, сделавшая Джоан Роулинг самым читаемым писателем современности. Книга, ставшая культовой уже для нескольких поколений. «Гарри Поттер и Философский камень» - история начинается.",
        rating: 4.9,
        ageRating: "12+",
        language: "Русский",
        coverType: "Твёрдый",
        pageCount: 334,
        publishYear: 1997
    )

    private lazy var reviews: [ReviewItem] = [
        .init(bookId: warAndPeace.id,
              userName: "Shukrullo",
              date: "01.08.2025",
              bookCoverImageName: "book1",
              bookTitle: "Джордж Оруэлл: 1984 (М)",
              rating: 5,
              reviewText: "Первая книга которую я читал и до сих пор иногда читаю...",
              mood: .happy),
        .init(bookId: crimeAndPunishment.id,
              userName: "SGR",
              date: "01.07.2025",
              bookCoverImageName: "book2",
              bookTitle: "Элбом Митч: Вторники с Морри, или",
              rating: 5,
              reviewText: "Книга в целом простая по форме, но глубокая по содержанию...",
              mood: .happy)
    ]

    // Sections data
    private lazy var bestBooks: [Book] = [warAndPeace, crimeAndPunishment, annaKarenina]
    private lazy var recommendedBooks: [Book] = [fahrenheit451, hpStone]
    private lazy var discountBooks: [Book] = [crimeAndPunishment, annaKarenina]

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

    private var socialMediaItems: [SocialMediaItem] = [
        .init(iconName: "InstagramIcon", link: URL(string: "https://instagram.com/kitobz.tj")!),
        .init(iconName: "FacebookIcon", link: URL(string: "https://facebook.com/kitobz")!),
        .init(iconName: "TelegramIcon", link: URL(string: "https://t.me/kitobz")!),
        .init(iconName: "ViberIcon", link: URL(string: "tel:903022298")!)
    
    ]

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "Background")
        configureNavigationBar()
        setupScrollView()
        setupSections()
        loadData()
        setupBookTapHandlers()
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
            roundCardSection,
            bestBooksSection,
            recommendedSection,
            discountSection,
            reviewSection,
            socialMediaSection,
            quoteSection,

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

    // MARK: - Book Tap Handling
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

    private func openBookDetail(_ book: Book) {
        let filtered = reviews.filter { $0.bookId == book.id }
        let vc = BookDetailViewController(book: book, reviews: filtered)
        navigationController?.pushViewController(vc, animated: true)
    }

    // MARK: - Actions
    @objc private func didTapThemeToggle() {
        let isDark = traitCollection.userInterfaceStyle == .dark
        overrideUserInterfaceStyle = isDark ? .light : .dark
        navigationController?.overrideUserInterfaceStyle = overrideUserInterfaceStyle
        applyAppearanceForCurrentStyle()
    }

}
