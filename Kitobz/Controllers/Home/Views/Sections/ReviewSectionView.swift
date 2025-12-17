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
    var onTapShowAllReviews: (() -> Void)?

    var showLeaveReviewButton: Bool = false {
        didSet { updateLeaveReviewVisibility() }
    }

    var bookTitle: String = ""

    // MARK: - UI

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 18, weight: .semibold)
        l.textColor = .label
        l.text = "Отзывы"
        return l
    }()

    private let mainStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        return stack
    }()

    private let allLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 14, weight: .bold)
        l.textColor = UIColor(named: "AccentColor2")
        l.text = "Все"
        l.isUserInteractionEnabled = true
        return l
    }()

    private let leaveReviewButton: UIButton = {
        let b = UIButton(type: .system)
        let accent = UIColor(named: "AccentColor") ?? .systemBlue

        b.backgroundColor = accent.withAlphaComponent(0.12)
        b.layer.cornerRadius = 28
        b.layer.masksToBounds = true

        let icon = UIImage(systemName: "plus")?.withConfiguration(
            UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)
        )

        b.setImage(icon, for: .normal)
        b.setTitle(" Оставить отзыв", for: .normal)
        b.setTitleColor(accent, for: .normal)
        b.tintColor = accent
        b.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)

        b.contentEdgeInsets = UIEdgeInsets(top: 18, left: 24, bottom: 18, right: 24)
        b.imageEdgeInsets = UIEdgeInsets(top: 0, left: -6, bottom: 0, right: 6)

        return b
    }()

    private let headerStack = UIStackView()
    private let collectionView: UICollectionView

    var items: [ReviewItem] = [] {
        didSet { collectionView.reloadData() }
    }

    // MARK: - Init

    override init(frame: CGRect) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 1
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.decelerationRate = .fast

        super.init(frame: frame)

        setupStacks()
        setupCollectionView()
        setupLayout()
        setupActions()

        updateLeaveReviewVisibility()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupStacks() {
        // Header row: title | spacer | "Все"
        headerStack.axis = .horizontal
        headerStack.alignment = .center
        headerStack.spacing = 8
        headerStack.addArrangedSubview(titleLabel)
        headerStack.addArrangedSubview(UIView())
        headerStack.addArrangedSubview(allLabel)

        addSubview(mainStack)

        // Arrange content vertically
        mainStack.addArrangedSubview(headerStack)
        mainStack.addArrangedSubview(collectionView)

        // Add button with its own container to have horizontal insets
        let buttonContainer = UIView()
        buttonContainer.addSubview(leaveReviewButton)
        leaveReviewButton.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(64)
        }
        mainStack.addArrangedSubview(buttonContainer)

        // Spacing after collection view
        mainStack.setCustomSpacing(16, after: headerStack)
        mainStack.setCustomSpacing(32, after: collectionView)
    }

    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ReviewCardCell.self, forCellWithReuseIdentifier: ReviewCardCell.id)
    }

    private func setupLayout() {
        // Pin stack to edges with outer insets
        mainStack.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16)
        }

        // Fixed height for the horizontal cards row
        collectionView.snp.makeConstraints {
            $0.height.equalTo(210)
        }
    }

    private func setupActions() {
        leaveReviewButton.addTarget(self, action: #selector(didTapLeaveReview), for: .touchUpInside)
        leaveReviewButton.addTarget(self, action: #selector(buttonDown), for: .touchDown)
        leaveReviewButton.addTarget(self, action: #selector(buttonUp), for: [.touchUpInside, .touchUpOutside])

        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapAllReviews))
        allLabel.addGestureRecognizer(tap)
    }

    // MARK: - Actions

    private func updateLeaveReviewVisibility() {
        leaveReviewButton.isHidden = !showLeaveReviewButton
        // Let the stack recalculate layout
        setNeedsLayout()
        layoutIfNeeded()
    }

    @objc private func didTapLeaveReview() {
        let vc = LeaveReviewViewController()
        vc.bookTitle = bookTitle.isEmpty ? "Книга" : bookTitle
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve

        presentingViewController?.present(vc, animated: true)
    }

    @objc private func didTapAllReviews() {
        onTapShowAllReviews?()
    }

    @objc private func buttonDown() {
        UIView.animate(withDuration: 0.15) {
            self.leaveReviewButton.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
        }
    }

    @objc private func buttonUp() {
        UIView.animate(withDuration: 0.15) {
            self.leaveReviewButton.transform = .identity
        }
    }
}

// MARK: - CollectionView

extension ReviewSectionView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ReviewCardCell.id,
            for: indexPath
        ) as! ReviewCardCell

        cell.configure(with: items[indexPath.item])
        cell.onMoreTapped = { [weak self] in
            self?.onTapShowAllReviews?()
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width * 0.85
        return CGSize(width: width, height: collectionView.bounds.height)
    }
}
