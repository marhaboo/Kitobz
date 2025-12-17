//
//  BooksViewController.swift
//  Favorites
//
//  Created by Madina on 01/12/25.
//

import UIKit

class FavoritesViewController: UIViewController {
    private var books: [Book] = []
    private var allReviews: [ReviewItem] = []
    private let collectionView: UICollectionView

    // MARK: - Init
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 20, right: 16)
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 20, right: 16)
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(coder: coder)
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: .favoritesDidChange, object: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "Background")
        title = "Избранные"
        setupCollectionView()
        setupObservers()
        loadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }

    private func setupCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceVertical = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.keyboardDismissMode = .onDrag
        collectionView.register(BookListCell.self, forCellWithReuseIdentifier: BookListCell.id)

        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleFavoritesChanged), name: .favoritesDidChange, object: nil)
    }

    @objc private func handleFavoritesChanged() {
        loadData()
    }

    private func loadData() {
        // 1) Load base books
        let base = BooksProvider.baseBooks()

        // 2) Load reviews for these books
        let reviews = ReviewsProvider.loadReviews(for: base)
        self.allReviews = reviews

        // 3) Group reviews by bookId and merge into books; recompute rating
        let reviewsByBookId = Dictionary(grouping: reviews, by: { $0.bookId })
        let merged: [Book] = base.map { book in
            let bookReviews = reviewsByBookId[book.id] ?? []
            let newRating: Double
            if !bookReviews.isEmpty {
                let sum = bookReviews.reduce(0) { $0 + $1.rating }
                newRating = Double(sum) / Double(bookReviews.count)
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

        // 4) Filter by FavoritesManager
        let favIDs = Set(FavoritesManager.shared.allFavoriteIDs())
        books = merged.filter { favIDs.contains($0.id) }

        // 5) Reload
        collectionView.reloadData()
    }

    private func book(at indexPath: IndexPath) -> Book {
        books[indexPath.item]
    }
}

extension FavoritesViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        books.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookListCell.id, for: indexPath) as! BookListCell
        let b = book(at: indexPath)
        cell.configure(with: b)

        cell.onFavoriteToggle = { isFav in
            FavoritesManager.shared.setFavorite(bookID: b.id, isFavorite: isFav)
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selected = book(at: indexPath)
        let reviewsForBook = allReviews.filter { $0.bookId == selected.id }
        let detail = BookDetailViewController(book: selected, reviews: reviewsForBook)
        navigationController?.pushViewController(detail, animated: true)
    }

    private func rowSize(for width: CGFloat) -> CGSize {
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        let insets = layout?.sectionInset ?? .zero
        let cellWidth = width - insets.left - insets.right
        let height: CGFloat = 120
        return CGSize(width: cellWidth, height: height)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        rowSize(for: collectionView.bounds.width)
    }
}
