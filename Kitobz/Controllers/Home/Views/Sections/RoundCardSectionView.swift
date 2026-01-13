//
//  RoundCardSectionView.swift
//  Kitobz
//
//  Created by Boymuroдова Marhabo on 03/12/25.
//

import UIKit
import SnapKit

final class RoundCardSectionView: UIView {

    // MARK: - UI
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .clear
        return cv
    }()

    // MARK: - Data
    var items: [RoundCardItem] = [] {
        didSet { collectionView.reloadData() }
    }

    // Seen flags to control ring style
    var seenFlags: [Bool] = [] {
        didSet { collectionView.reloadData() }
    }

    // Tap callback
    var onItemSelected: ((Int) -> Void)?

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupCollectionView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup
    private func setupViews() {
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(130)
        }
    }

    private func setupCollectionView() {
        collectionView.register(RoundCardCell.self, forCellWithReuseIdentifier: RoundCardCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    func reloadItem(at index: Int) {
        guard index >= 0, index < items.count else { return }
        collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
    }
}

extension RoundCardSectionView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RoundCardCell.identifier, for: indexPath) as? RoundCardCell else {
            return UICollectionViewCell()
        }
        let seen = (indexPath.item < seenFlags.count) ? seenFlags[indexPath.item] : false
        cell.configure(with: items[indexPath.item], seen: seen)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 96, height: 122)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onItemSelected?(indexPath.item)
    }
}

