//
//  AllReviewsViewController.swift
//  Kitobz
//
//  Created by Boymurodova Marhabo on 16/12/25.
//

import UIKit
import SnapKit

final class AllReviewsViewController: UIViewController {

    private let bookTitle: String
    private let reviews: [ReviewItem]
    private let tableView = UITableView(frame: .zero, style: .plain)

    init(bookTitle: String, reviews: [ReviewItem]) {
        self.bookTitle = bookTitle
        self.reviews = reviews
        super.init(nibName: nil, bundle: nil)
        self.title = "Все отзывы"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupTableView()
        setupNavTitle()
    }

    private func setupNavTitle() {
        // Показываем название книги в подзаголовке
        let titleLabel = UILabel()
        titleLabel.text = "Все отзывы"
        titleLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        titleLabel.textAlignment = .center

        let subtitleLabel = UILabel()
        subtitleLabel.text = bookTitle
        subtitleLabel.font = .systemFont(ofSize: 12, weight: .regular)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.textAlignment = .center

        let stack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 0

        navigationItem.titleView = stack
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.register(FullReviewCell.self, forCellReuseIdentifier: FullReviewCell.id)
    }
}

extension AllReviewsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        reviews.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = reviews[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: FullReviewCell.id, for: indexPath) as! FullReviewCell
        cell.configure(with: item)
        return cell
    }
}

private final class FullReviewCell: UITableViewCell {
    static let id = "FullReviewCell"

    private let cardView: UIView = {
        let v = UIView()
        v.layer.cornerRadius = 16
        v.layer.masksToBounds = true
        v.backgroundColor = UIColor(named: "cardBg") ?? .secondarySystemBackground
        return v
    }()

    private let avatarView = InitialsAvatarView()
    private let nameLabel = UILabel()
    private let dateLabel = UILabel()
    private let starsStack = UIStackView()

    private let reviewLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none

        nameLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        nameLabel.textColor = .label

        dateLabel.font = .systemFont(ofSize: 12, weight: .regular)
        dateLabel.textColor = .secondaryLabel

        starsStack.axis = .horizontal
        starsStack.alignment = .center
        starsStack.spacing = 4
        for _ in 0..<5 {
            let iv = UIImageView(image: UIImage(systemName: "star.fill"))
            iv.tintColor = .systemYellow
            iv.contentMode = .scaleAspectFit
            iv.snp.makeConstraints { make in
                make.width.height.equalTo(14)
            }
            starsStack.addArrangedSubview(iv)
        }

        reviewLabel.font = .systemFont(ofSize: 15)
        reviewLabel.textColor = .label
        reviewLabel.numberOfLines = 0

        contentView.addSubview(cardView)
        cardView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(12)
        }

        let nameDateStack = UIStackView(arrangedSubviews: [nameLabel, dateLabel])
        nameDateStack.axis = .vertical
        nameDateStack.spacing = 2

        let headerLeft = UIStackView(arrangedSubviews: [avatarView, nameDateStack])
        headerLeft.axis = .horizontal
        headerLeft.alignment = .center
        headerLeft.spacing = 12

        let header = UIStackView(arrangedSubviews: [headerLeft, UIView(), starsStack])
        header.axis = .horizontal
        header.alignment = .center
        header.spacing = 8

        let container = UIStackView(arrangedSubviews: [header, reviewLabel])
        container.axis = .vertical
        container.spacing = 12

        cardView.addSubview(container)
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }

        avatarView.snp.makeConstraints { make in
            make.width.height.equalTo(36)
        }
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func configure(with item: ReviewItem) {
        nameLabel.text = item.userName
        dateLabel.text = item.date
        avatarView.setInitials(from: item.userName)
        reviewLabel.text = item.reviewText
        updateStars(rating: item.rating)
    }

    private func updateStars(rating: Int) {
        let clamped = max(0, min(5, rating))
        for (i, v) in starsStack.arrangedSubviews.enumerated() {
            guard let iv = v as? UIImageView else { continue }
            iv.image = UIImage(systemName: i < clamped ? "star.fill" : "star")
            iv.tintColor = .systemYellow
        }
    }
}

// Reuse same helper from ReviewCardCell
private final class InitialsAvatarView: UIView {
    private let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.systemGray4
        layer.cornerRadius = 18
        layer.masksToBounds = true

        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textAlignment = .center
        label.textColor = .white

        addSubview(label)
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(4)
        }
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func setInitials(from name: String) {
        let parts = name.split(separator: " ")
        let initials = parts.prefix(2).compactMap { $0.first }.map { String($0) }.joined()
        label.text = initials.isEmpty ? "?" : initials.uppercased()
        backgroundColor = color(for: name)
    }

    private func color(for string: String) -> UIColor {
        let hash = abs(string.hashValue)
        let hue = CGFloat(hash % 256) / 256.0
        return UIColor(hue: hue, saturation: 0.5, brightness: 0.75, alpha: 1)
    }
}

