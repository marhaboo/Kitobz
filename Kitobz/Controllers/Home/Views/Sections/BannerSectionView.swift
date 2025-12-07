//
//  BannerSectionView.swift
//  Kitobz
//
//  Created by Boymurodova Marhabo on 03/12/25.
//

import UIKit
import SnapKit

final class BannerSectionView: UIView {

    // MARK: - Properties
    private let collectionView: UICollectionView
    private let pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.hidesForSinglePage = true
        pc.currentPageIndicatorTintColor = .label
        pc.pageIndicatorTintColor = UIColor.label.withAlphaComponent(0.2)
        return pc
    }()
    
    private var banners: [Banner] = [] {
        didSet {
            collectionView.reloadData()
            pageControl.numberOfPages = banners.count
        }
    }

    // MARK: - Init
    override init(frame: CGRect) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        let spacing: CGFloat = 12
        layout.minimumLineSpacing = spacing
        layout.sectionInset = .zero

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.contentInsetAdjustmentBehavior = .never
        
        super.init(frame: frame)

        // Add visual padding (Correct way!)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)

        setupCollectionView()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(BannerCollectionViewCell.self,
                                forCellWithReuseIdentifier: BannerCollectionViewCell.id)
        addSubview(collectionView)
        addSubview(pageControl)
    }

    private func setupLayout() {
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(collectionView.snp.width).multipliedBy(0.42)
        }

        pageControl.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

    func setBanners(_ banners: [Banner]) {
        self.banners = banners
    }
}

// MARK: - CollectionView DataSource & Delegate
extension BannerSectionView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return banners.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: BannerCollectionViewCell.id,
            for: indexPath
        ) as! BannerCollectionViewCell
        cell.configure(with: banners[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = collectionView.bounds.width - 32
        let height = collectionView.bounds.height
        return CGSize(width: width, height: height)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.width
        let page = Int(round(scrollView.contentOffset.x / pageWidth))
        pageControl.currentPage = max(0, min(page, banners.count - 1))
    }
}
