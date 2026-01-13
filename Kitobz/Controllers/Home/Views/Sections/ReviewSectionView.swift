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
    var onReviewAdded: ((ReviewItem) -> Void)?

    var bookId: String = ""
    var bookTitle: String = ""

    var showLeaveReviewButton: Bool = false {
        didSet { updateLeaveReviewVisibility() }
    }

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
        b.layer.cornerRadius = 16
        b.layer.masksToBounds = true

        let icon = UIImage(systemName: "plus")?.withConfiguration(
            UIImage.SymbolConfiguration(pointSize: 12, weight: .bold)
        )

        b.setImage(icon, for: .normal)
        b.setTitle(" Оставить отзыв", for: .normal)
        b.setTitleColor(accent, for: .normal)
        b.tintColor = accent
        b.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)

        b.contentEdgeInsets = UIEdgeInsets(top: 10, left: 14, bottom: 10, right: 14)
        b.imageEdgeInsets = UIEdgeInsets(top: 0, left: -6, bottom: 0, right: 6)

        return b
    }()

    private let headerStack = UIStackView()
    private let collectionView: UICollectionView

    var items: [ReviewItem] = [] {
        didSet { collectionView.reloadData() }
    }

    override init(frame: CGRect) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 1
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)

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

    private func setupStacks() {
        headerStack.axis = .horizontal
        headerStack.alignment = .center
        headerStack.spacing = 8
        headerStack.addArrangedSubview(titleLabel)
        headerStack.addArrangedSubview(UIView())
        headerStack.addArrangedSubview(allLabel)

        addSubview(mainStack)

        mainStack.addArrangedSubview(headerStack)
        mainStack.addArrangedSubview(collectionView)

        let buttonContainer = UIView()
        buttonContainer.addSubview(leaveReviewButton)
        leaveReviewButton.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(8)
            $0.height.equalTo(50)
        }
        mainStack.addArrangedSubview(buttonContainer)

        mainStack.setCustomSpacing(8, after: headerStack)
        mainStack.setCustomSpacing(8, after: collectionView)
    }

    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ReviewCardCell.self, forCellWithReuseIdentifier: ReviewCardCell.id)
    }

    private func setupLayout() {
        mainStack.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(12)
        }

        collectionView.snp.makeConstraints {
            $0.height.equalTo(170)
        }
    }

    private func setupActions() {
        leaveReviewButton.addTarget(self, action: #selector(didTapLeaveReview), for: .touchUpInside)
        leaveReviewButton.addTarget(self, action: #selector(buttonDown), for: .touchDown)
        leaveReviewButton.addTarget(self, action: #selector(buttonUp), for: [.touchUpInside, .touchUpOutside])

        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapAllReviews))
        allLabel.addGestureRecognizer(tap)
    }

    private func updateLeaveReviewVisibility() {
        leaveReviewButton.isHidden = !showLeaveReviewButton
        setNeedsLayout()
        layoutIfNeeded()
    }

    @objc private func didTapLeaveReview() {
        guard let presentingVC = presentingViewController else { return }
        
        let vc = LeaveReviewViewController()
        vc.bookTitle = bookTitle.isEmpty ? "Книга" : bookTitle
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        
        // Handle the review submission
        vc.onReviewSubmitted = { [weak self] rating, reviewText in
            guard let self = self else { return }
            
            // Create new review with current date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy"
            let dateString = dateFormatter.string(from: Date())
            
            let newReview = ReviewItem(
                bookId: self.bookId,
                userName: "Вы", // Or get from user session
                date: dateString,
                bookCoverImageName: "", // Optional
                bookTitle: self.bookTitle,
                rating: rating,
                reviewText: reviewText
            )
            
            // Add to beginning of items array
            self.items.insert(newReview, at: 0)
            
            // Scroll to show the new review
            if !self.items.isEmpty {
                self.collectionView.scrollToItem(
                    at: IndexPath(item: 0, section: 0),
                    at: .left,
                    animated: true
                )
            }
            
            // Notify parent view controller
            self.onReviewAdded?(newReview)
            
            // Show success message
            self.showSuccessMessage()
        }
        
        vc.view.alpha = 0
        
        presentingVC.present(vc, animated: false) {
            UIView.animate(
                withDuration: 0.4,
                delay: 0,
                usingSpringWithDamping: 0.9,
                initialSpringVelocity: 0.5,
                options: [.curveEaseOut, .allowUserInteraction],
                animations: {
                    vc.view.alpha = 1
                }
            )
        }
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
    
    private func showSuccessMessage() {
        guard let presentingVC = presentingViewController else { return }
        
        let alert = UIAlertController(
            title: "Спасибо!",
            message: "Ваш отзыв успешно добавлен",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        presentingVC.present(alert, animated: true)
    }
}

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
