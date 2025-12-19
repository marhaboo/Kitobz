//
//  SearchViewController.swift
//  Kitobz
//
//  Created by Boymurodova Marhabo on 01/12/25.
//

import UIKit
import SnapKit

final class SearchViewController: UIViewController {

    // MARK: - Properties

    private var filteredBooks: [Book] = []
    var allBooks: [Book] = []
    var onBookSelected: ((Book) -> Void)?

    private let searchController = UISearchController(searchResultsController: nil)

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 12
        let width = (UIScreen.main.bounds.width - 16 - 16 - 12 * 2) / 3
        layout.itemSize = CGSize(width: width, height: width * 1.8)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.contentInset = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        return cv
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "Background")
        title = "Поиск книг"
        if allBooks.isEmpty {
            allBooks = BooksProvider.updatedBooks()
        }
        setupSearchController()
        setupCollectionView()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateItemSizeForThreeColumns()
    }

    // MARK: - Setup

    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchBar.placeholder = "Поиск по названию или автору"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }

    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(BookCardCell.self, forCellWithReuseIdentifier: BookCardCell.id)
    }

    // MARK: - Layout

    private func updateItemSizeForThreeColumns() {
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        let contentInsets = collectionView.contentInset
        let availableWidth = collectionView.bounds.width - contentInsets.left - contentInsets.right
        let columns: CGFloat = 3
        let interItem: CGFloat = layout.minimumInteritemSpacing
        let totalSpacing = interItem * (columns - 1)
        let itemWidth = floor((availableWidth - totalSpacing) / columns)
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.8)
        layout.invalidateLayout()
    }
}

// MARK: - UICollectionViewDataSource & Delegate

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        filteredBooks.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookCardCell.id, for: indexPath) as? BookCardCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: filteredBooks[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let book = filteredBooks[indexPath.item]
        searchController
        if let onBookSelected {
            onBookSelected(book)
        } else {
            let reviews = ReviewsProvider.loadReviews(for: [book]).filter { $0.bookId == book.id }
            let vc = BookDetailViewController(book: book, reviews: reviews)
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

// MARK: - UISearchResultsUpdating

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let raw = searchController.searchBar.text ?? ""
        let query = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else {
            filteredBooks = []
            collectionView.reloadData()
            return
        }

        let lower = query.lowercased()

        struct ScoredBook {
            let book: Book
            let score: Int
        }

        let scored: [ScoredBook] = allBooks.compactMap { b in
            let title = b.title.lowercased()
            let author = b.author.lowercased()
            var score = 0
            if title.hasPrefix(lower) { score += 100 }
            if author.hasPrefix(lower) { score += 80 }
            if title.contains(lower) { score += 60 }
            if author.contains(lower) { score += 40 }
            return score > 0 ? ScoredBook(book: b, score: score) : nil
        }

        let sorted = scored.sorted {
            if $0.score != $1.score { return $0.score > $1.score }
            return $0.book.title.localizedCaseInsensitiveCompare($1.book.title) == .orderedAscending
        }

        filteredBooks = sorted.map { $0.book }
        collectionView.reloadData()
    }
}
