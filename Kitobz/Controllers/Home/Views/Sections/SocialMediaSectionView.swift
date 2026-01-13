//
//  SocialMediaSectionView.swift
//  Kitobz
//
//  Created by Boymurodova Marhabo on 04/12/25.
//

import UIKit
import SnapKit

final class SocialMediaSectionView: UIView {
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = .zero
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.isScrollEnabled = false
        cv.delegate = self
        cv.dataSource = self
        cv.register(SocialMediaCardCell.self, forCellWithReuseIdentifier: SocialMediaCardCell.identifier)
        return cv
    }()
    
    private var heightConstraint: Constraint?
    
    var items: [SocialMediaItem] = [] {
        didSet {
            collectionView.reloadData()
            updateHeightConstraint()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(32)
            make.trailing.equalToSuperview().offset(-32)
            heightConstraint = make.height.equalTo(1).constraint
            make.bottom.equalToSuperview()
        }
    }
    
    private func updateHeightConstraint() {
        let width = bounds.width > 0 ? bounds.width : UIScreen.main.bounds.width
        let rowHeight = floor(width / 4.0)
        heightConstraint?.update(offset: rowHeight)
        layoutIfNeeded()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateHeightConstraint()
    }
}

extension SocialMediaSectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(items.count, 4)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SocialMediaCardCell.identifier,
            for: indexPath
        ) as! SocialMediaCardCell
        
        cell.configure(with: items[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let side = floor(width / 4)
        return CGSize(width: side, height: side)
    }

 
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = items[indexPath.item]
        UIApplication.shared.open(item.link)
    }

}

