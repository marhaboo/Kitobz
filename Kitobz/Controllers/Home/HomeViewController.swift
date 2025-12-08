//
//  HomeViewController.swift
//  Kitobz
//
//  Created by Boymurodova Marhabo on 01/12/25.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {
    
    // MARK: - Nav items
    private var themeToggleButton: UIBarButtonItem?
    
    // MARK: - Banner UI
    private let bannerCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        cv.isPagingEnabled = true
        cv.backgroundColor = .clear
        cv.contentInsetAdjustmentBehavior = .never
        return cv
    }()
    
    private let pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.hidesForSinglePage = true
        pc.currentPageIndicatorTintColor = .label
        pc.pageIndicatorTintColor = UIColor.label.withAlphaComponent(0.2)
        return pc
    }()
    
    // MARK: - Quotes UI
    private let quotesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .clear
        
        return cv
    }()
    
    private let quotesTitleLabel: UILabel = {
        let l = UILabel()
        l.text = "Цитаты"
        l.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        l.textColor = .label
        return l
    }()
    
    // MARK: - Mock Data
    private var banners: [Banner] = [
        Banner(imageName: "banner"),
        Banner(imageName: "banner2"),
        Banner(imageName: "banner")
    ]
    
    private var quotes: [QuoteItem] = [
        QuoteItem(authorName: "АГАТА КРИСТИ", authorImageName: "author1", quote: "Если ты суёшь свою голову в пасть льва, не жалуйся, когда однажды случится так, что он её откусит"),
        QuoteItem(authorName: "СЕРГЕЙ ЕСЕНИН", authorImageName: "author2", quote: "Если тронуть страсти в человеке, то, конечно, правды не найдешь"),
        QuoteItem(authorName: "ФЁДОР ДОСТОЕВСКИЙ", authorImageName: "author3", quote: "Перестать читать книги — значит перестать мыслить")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        view.backgroundColor = UIColor(named: "Background")
        
        setupBannerSection()
        setupQuotesSection()
    }
    
    // MARK: - Configure Navigation Bar
    private func configureNavigationBar() {
        let bar = navigationController?.navigationBar
        bar?.prefersLargeTitles = false
        bar?.tintColor = UIColor.label
        
        // Left: Menu Button
        let menuButton = UIButton(type: .system)
        menuButton.setImage(UIImage(systemName: "line.horizontal.3"), for: .normal)
        menuButton.tintColor = UIColor.label
        menuButton.addTarget(self, action: #selector(didTapMenuButton), for: .touchUpInside)
        menuButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 28, height: 28))
        }
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: menuButton)
        
        // Center: Logo as titleView
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
        
        // Right: Theme Toggle Button
        let themeButton = UIButton(type: .system)
        themeButton.addTarget(self, action: #selector(didTapThemeToggle), for: .touchUpInside)
        themeButton.tintColor = UIColor.label
        themeButton.setPreferredSymbolConfiguration(
            UIImage.SymbolConfiguration(pointSize: 17, weight: .semibold),
            forImageIn: .normal
        )
        themeButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 28, height: 28))
        }
        let themeItem = UIBarButtonItem(customView: themeButton)
        self.themeToggleButton = themeItem
        navigationItem.rightBarButtonItem = themeItem
        updateThemeToggleIcon(on: themeButton)
        
        // Appearance
        applyAppearanceForCurrentStyle()
    }
    
    // MARK: - Update Appearance
    private func applyAppearanceForCurrentStyle() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        
        let bgColor = UIColor(named: "Background") ?? UIColor.systemBackground
        appearance.backgroundColor = bgColor
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
    
    // MARK: - Left Menu Button Action
    @objc private func didTapMenuButton() {
        print("Menu button tapped")
    }
    
    // MARK: - Right Theme Toggle Action
    @objc private func didTapThemeToggle() {
        let isDark = traitCollection.userInterfaceStyle == .dark
        let newStyle: UIUserInterfaceStyle = isDark ? .light : .dark
        
        if let tab = self.tabBarController {
            tab.overrideUserInterfaceStyle = newStyle
        } else if let nav = self.navigationController {
            nav.overrideUserInterfaceStyle = newStyle
        } else {
            self.overrideUserInterfaceStyle = newStyle
        }
        
        if let button = self.themeToggleButton?.customView as? UIButton {
            self.updateThemeToggleIcon(on: button)
        }
        
        view.backgroundColor = UIColor(named: "Background") ?? UIColor.systemBackground
    }
}

// MARK: - Banner setup and data source
extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    private func setupBannerSection() {
        // Register cell
        bannerCollectionView.register(BannerCollectionViewCell.self, forCellWithReuseIdentifier: BannerCollectionViewCell.id)
        bannerCollectionView.dataSource = self
        bannerCollectionView.delegate = self
        
        // Add to view
        view.addSubview(bannerCollectionView)
        view.addSubview(pageControl)
        
        // Layout with SnapKit
        bannerCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(12)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().inset(16)
            make.height.equalTo(bannerCollectionView.snp.width).multipliedBy(0.42)
        }
        
        pageControl.snp.makeConstraints { make in
            make.top.equalTo(bannerCollectionView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        // Page control count
        pageControl.numberOfPages = banners.count
        pageControl.currentPage = 0
    }
    
    // MARK: Data Source (both collections)
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView === bannerCollectionView {
            return banners.count
        } else if collectionView === quotesCollectionView {
            return quotes.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView === bannerCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCollectionViewCell.id, for: indexPath) as? BannerCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: banners[indexPath.item])
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: QuoteCardCell.id, for: indexPath) as? QuoteCardCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: quotes[indexPath.item])
            return cell
        }
    }
    
    // MARK: Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView === bannerCollectionView {
            let width = collectionView.bounds.width
            let height = collectionView.bounds.height
            return CGSize(width: width, height: height)
        } else {
            let width = collectionView.bounds.width * 0.95
            let height: CGFloat = 160
            return CGSize(width: width, height: height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView === bannerCollectionView {
            return .zero
        } else {
            return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    // MARK: Page control sync
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        updatePageControl(for: scrollView)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            updatePageControl(for: scrollView)
        }
    }
    
    private func updatePageControl(for scrollView: UIScrollView) {
        guard scrollView === bannerCollectionView else { return }
        let page = Int(round(scrollView.contentOffset.x / max(scrollView.bounds.width, 1)))
        pageControl.currentPage = max(0, min(page, banners.count - 1))
    }
}

// MARK: - Quotes section setup
private extension HomeViewController {
    func setupQuotesSection() {
        
        view.addSubview(quotesTitleLabel)
        quotesTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(pageControl.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().inset(16)
        }
        
        quotesCollectionView.register(QuoteCardCell.self, forCellWithReuseIdentifier: QuoteCardCell.id)
        quotesCollectionView.dataSource = self
        quotesCollectionView.delegate = self
        view.addSubview(quotesCollectionView)
        quotesCollectionView.snp.makeConstraints { make in
            make.top.equalTo(quotesTitleLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(132)
        }
    }
}

