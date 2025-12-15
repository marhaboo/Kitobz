//  BookSectionView.swift
//  Kitobz
//
//  Created by Boymurodova Marhabo on 03/12/25.
//

import UIKit
import SnapKit

final class BookSectionView: UIView {
    
    var onBookSelected: ((Book) -> Void)?
    // New: callback for "Все"
    var onShowAll: (([Book], String) -> Void)?
    
    private let titleLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        l.textColor = .label
        return l
    }()
    
    private let collectionView: UICollectionView
    
    private var books: [Book] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private let allLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        l.textColor = UIColor(named: "AccentColor2")
        l.text = "Все"
        l.textAlignment = .right
        l.isUserInteractionEnabled = true // make tappable
        return l
    }()

    private var sectionTitle: String = ""
    
    init(title: String) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 0
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        
        super.init(frame: .zero)
        titleLabel.text = title
        sectionTitle = title
        
        addSubview(titleLabel)
        addSubview(allLabel)
        addSubview(collectionView)

        // Tap on "Все"
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapAll))
        allLabel.addGestureRecognizer(tap)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(BookCardCell.self, forCellWithReuseIdentifier: BookCardCell.id)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.lessThanOrEqualTo(allLabel.snp.leading).offset(-8)
        }

        allLabel.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.trailing.equalToSuperview().inset(16)
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(250)
        }
    }
    
    func setBooks(_ books: [Book]) {
        self.books = books
    }
    
    @objc private func didTapAll() {
        onShowAll?(books, sectionTitle)
    }
}

extension BookSectionView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return books.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookCardCell.id, for: indexPath) as! BookCardCell
        cell.configure(with: books[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let book = books[indexPath.item]
        onBookSelected?(book)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = 120
        let height: CGFloat = 240
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
}
