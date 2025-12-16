//
//  ReviewSectionView.swift
//  Kitobz
//
//  Created by Boymuroдова Marhabo on 04/12/25.
//

import UIKit
import SnapKit

final class ReviewSectionView: UIView {
    
    weak var presentingViewController: UIViewController?

    // Переход на экран "Все отзывы"
    var onTapShowAllReviews: (() -> Void)?

    var showLeaveReviewButton: Bool = false {
        didSet { updateLeaveReviewVisibility() }
    }
    
    var bookTitle: String = ""

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        l.textColor = .label
        l.numberOfLines = 1
        l.lineBreakMode = .byTruncatingTail
        l.text = "Отзывы"
        return l
    }()

    private let prevButton: UIButton = {
        let b = UIButton(type: .system)
        let image = UIImage(systemName: "chevron.left")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 16, weight: .bold))
        b.setImage(image, for: .normal)
        b.tintColor = .lightGray
        b.contentEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
        return b
    }()

    private let nextButton: UIButton = {
        let b = UIButton(type: .system)
        let image = UIImage(systemName: "chevron.right")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 16, weight: .bold))
        b.setImage(image, for: .normal)
        b.tintColor = .lightGray
        b.contentEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
        return b
    }()

    private let leaveReviewButton: UIButton = {
        let b = UIButton(type: .system)
        b.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.1)
        b.layer.cornerRadius = 16
        b.layer.masksToBounds = true
        
        let icon = UIImage(systemName: "plus")?.withConfiguration(
            UIImage.SymbolConfiguration(pointSize: 14, weight: .semibold)
        )
        b.setImage(icon, for: .normal)
        b.setTitle(" Оставить отзыв", for: .normal)
        b.setTitleColor(.systemBlue, for: .normal)
        b.tintColor = .systemBlue
        b.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        b.contentEdgeInsets = UIEdgeInsets(top: 12, left: 20, bottom: 12, right: 20)
        
        return b
    }()

    private let headerStack = UIStackView()
    private let buttonStack = UIStackView()
    private let collectionView: UICollectionView

    var items: [ReviewItem] = [] {
        didSet { collectionView.reloadData() }
    }

    private var bottomConstraintWithButton: Constraint?
    private var bottomConstraintWithoutButton: Constraint?

    override init(frame: CGRect) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.decelerationRate = .fast

        super.init(frame: frame)

        setupStacks()
        setupCollectionView()
        setupLayout()
        
        leaveReviewButton.addTarget(self, action: #selector(didTapLeaveReview), for: .touchUpInside)
        updateLeaveReviewVisibility()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupStacks() {
        buttonStack.axis = .horizontal
        buttonStack.alignment = .center
        buttonStack.spacing = 4
        buttonStack.addArrangedSubview(prevButton)
        buttonStack.addArrangedSubview(nextButton)

        prevButton.addTarget(self, action: #selector(didTapPrev), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)

        headerStack.axis = .horizontal
        headerStack.alignment = .center
        headerStack.spacing = 8
        headerStack.addArrangedSubview(titleLabel)
        headerStack.addArrangedSubview(UIView())
        headerStack.addArrangedSubview(buttonStack)

        titleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        buttonStack.setContentHuggingPriority(.required, for: .horizontal)

        addSubview(headerStack)
        addSubview(leaveReviewButton)
    }

    private func setupCollectionView() {
        addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ReviewCardCell.self, forCellWithReuseIdentifier: ReviewCardCell.id)
    }

    private func setupLayout() {
        headerStack.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().inset(16)
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(headerStack.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(210)
        }

        leaveReviewButton.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }

        bottomConstraintWithButton = leaveReviewButton.snp.prepareConstraints { make in
            make.bottom.equalToSuperview().inset(16)
        }.first

        bottomConstraintWithoutButton = collectionView.snp.prepareConstraints { make in
            make.bottom.equalToSuperview().inset(16)
        }.first

        prevButton.snp.makeConstraints { make in
            make.width.height.equalTo(16)
        }
        nextButton.snp.makeConstraints { make in
            make.width.height.equalTo(16)
        }
    }

    private func updateLeaveReviewVisibility() {
        leaveReviewButton.isHidden = !showLeaveReviewButton

        if showLeaveReviewButton {
            bottomConstraintWithoutButton?.deactivate()
            bottomConstraintWithButton?.activate()
        } else {
            bottomConstraintWithButton?.deactivate()
            bottomConstraintWithoutButton?.activate()
        }
        setNeedsLayout()
        layoutIfNeeded()
    }

    @objc private func didTapLeaveReview() {
        let vc = LeaveReviewViewController()
        vc.bookTitle = bookTitle.isEmpty ? "Книга" : bookTitle
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        
        vc.onReviewSubmitted = { [weak self] rating, reviewText in
            print("Rating: \(rating), Review: \(reviewText)")
        }
        
        presentingViewController?.present(vc, animated: false)
    }

    @objc private func didTapPrev() {
        guard let indexPath = centeredIndexPath() else {
            scrollToItem(at: 0)
            return
        }
        let prev = max(0, indexPath.item - 1)
        scrollToItem(at: prev)
    }

    @objc private func didTapNext() {
        guard let indexPath = centeredIndexPath() else {
            scrollToItem(at: 0)
            return
        }
        let next = min(items.count - 1, indexPath.item + 1)
        scrollToItem(at: next)
    }

    private func scrollToItem(at index: Int) {
        guard index >= 0, index < items.count else { return }
        let ip = IndexPath(item: index, section: 0)
        collectionView.scrollToItem(at: ip, at: .centeredHorizontally, animated: true)
    }

    private func centeredIndexPath() -> IndexPath? {
        let centerPoint = convert(collectionView.center, to: collectionView)
        return collectionView.indexPathForItem(at: centerPoint)
    }
}

extension ReviewSectionView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewCardCell.id, for: indexPath) as? ReviewCardCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: items[indexPath.item])
        cell.onMoreTapped = { [weak self] in
            self?.onTapShowAllReviews?()
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let flow = collectionViewLayout as? UICollectionViewFlowLayout else {
            return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
        }
        let insets = flow.sectionInset.left + flow.sectionInset.right
        let width = collectionView.bounds.width - insets
        let height = collectionView.bounds.height
        return CGSize(width: width, height: height)
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard let flow = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        let insets = flow.sectionInset.left + flow.sectionInset.right
        let pageWidth = collectionView.bounds.width - insets + flow.minimumLineSpacing

        let approximatePage = scrollView.contentOffset.x / max(pageWidth, 1)
        let targetPage: CGFloat
        if velocity.x > 0 {
            targetPage = ceil(approximatePage)
        } else if velocity.x < 0 {
            targetPage = floor(approximatePage)
        } else {
            targetPage = round(approximatePage)
        }

        targetContentOffset.pointee.x = targetPage * pageWidth
    }
}

