//
//  AllBooksViewController.swift
//  Kitobz
//
//  Created by Boymurodova Marhabo on 12/12/25.
//

import UIKit
import SnapKit

final class AllBooksViewController: UIViewController {

    private let books: [Book]
    private let collectionView: UICollectionView

    var onBookSelected: ((Book) -> Void)?

    init(title: String, books: [Book]) {
        self.books = books

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 20, right: 16)

        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(nibName: nil, bundle: nil)

        self.title = title
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "Background") ?? .systemBackground
        setupNav()
        setupCollectionView()
        setupLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    private func setupNav() {
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.prefersLargeTitles = false
    }

    private func setupCollectionView() {
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceVertical = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.keyboardDismissMode = .onDrag
        collectionView.register(BookListCell.self, forCellWithReuseIdentifier: BookListCell.id)
    }

    private func setupLayout() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

    private func rowSize(for width: CGFloat) -> CGSize {
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        let insets = layout?.sectionInset ?? .zero
        let cellWidth = width - insets.left - insets.right
        let height: CGFloat = 120
        return CGSize(width: cellWidth, height: height)
    }

    private func book(at indexPath: IndexPath) -> Book {
        books[indexPath.item]
    }
}

extension AllBooksViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        books.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookListCell.id, for: indexPath) as! BookListCell
        cell.configure(with: book(at: indexPath))
        cell.onFavoriteToggle = { isFav in
            let b = self.book(at: indexPath)
            FavoritesManager.shared.setFavorite(bookID: b.id, isFavorite: isFav)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selected = book(at: indexPath)
        if let handler = onBookSelected {
            handler(selected)
        } else {
            let vc = BookDetailViewController(book: selected, reviews: nil)
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        rowSize(for: collectionView.bounds.width)
    }
}
