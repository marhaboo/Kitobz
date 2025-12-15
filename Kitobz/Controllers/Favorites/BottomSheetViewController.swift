//
//  BottomSheetViewController.swift
//  Favorites
//
//  Created by Madina on 01/12/25.
//

import UIKit

final class BottomSheetViewController: UIViewController {
    private let book: Book

    init(book: Book) {
        self.book = book
        super.init(nibName: nil, bundle: nil)
        if #available(iOS 15.0, *) {
            modalPresentationStyle = .pageSheet
        } else {
            modalPresentationStyle = .formSheet
        }
    }

    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupLayout()
    }

    private func setupLayout() {
        // top row with small cover, title and close button
        let cover = UIImageView(image: UIImage(named: book.coverImageName))
        cover.translatesAutoresizingMaskIntoConstraints = false
        cover.widthAnchor.constraint(equalToConstant: 64).isActive = true
        cover.heightAnchor.constraint(equalToConstant: 64).isActive = true
        cover.layer.cornerRadius = 8
        cover.clipsToBounds = true

        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = book.title
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        titleLabel.numberOfLines = 2

        let authorLabel = UILabel()
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        authorLabel.text = book.author
        authorLabel.font = UIFont.systemFont(ofSize: 15)
        authorLabel.textColor = .systemGray

        let textStack = UIStackView(arrangedSubviews: [titleLabel, authorLabel])
        textStack.axis = .vertical
        textStack.spacing = 6
        textStack.translatesAutoresizingMaskIntoConstraints = false

        let closeButton = UIButton(type: .system)
        closeButton.setTitle("✕", for: .normal)
        closeButton.titleLabel?.font = UIFont.systemFont(ofSize: 26)
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false

        let topRow = UIStackView(arrangedSubviews: [cover, textStack, closeButton])
        topRow.translatesAutoresizingMaskIntoConstraints = false
        topRow.axis = .horizontal
        topRow.alignment = .center
        topRow.spacing = 12

        view.addSubview(topRow)

        // Actions
        let actions = [
            makeActionRow(title: "Поделиться", symbol: "square.and.arrow.up"),
            makeActionRow(title: "Добавить в список", symbol: "text.badge.plus"),
            makeActionRow(title: FavoritesManager.shared.isFavorite(bookID: book.id) ? "Убрать из избранного" : "В избранное", symbol: "heart"),
            makeActionRow(title: "Отметить как прочитанное", symbol: "flag")
        ]

        let actionsStack = UIStackView(arrangedSubviews: actions)
        actionsStack.translatesAutoresizingMaskIntoConstraints = false
        actionsStack.axis = .vertical
        actionsStack.spacing = 16
        actionsStack.alignment = .leading

        view.addSubview(actionsStack)

        NSLayoutConstraint.activate([
            topRow.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            topRow.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            topRow.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            actionsStack.topAnchor.constraint(equalTo: topRow.bottomAnchor, constant: 24),
            actionsStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            actionsStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            actionsStack.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -20)
        ])
    }

    private func makeActionRow(title: String, symbol: String) -> UIView {
        let icon = UIImageView(image: UIImage(systemName: symbol))
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.widthAnchor.constraint(equalToConstant: 28).isActive = true
        icon.heightAnchor.constraint(equalToConstant: 28).isActive = true
        icon.tintColor = .label

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = title
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)

        let h = UIStackView(arrangedSubviews: [icon, label])
        h.axis = .horizontal
        h.alignment = .center
        h.spacing = 12
        h.isUserInteractionEnabled = true

        let tap = UITapGestureRecognizer(target: self, action: #selector(actionTapped(_:)))
        h.addGestureRecognizer(tap)
        h.accessibilityLabel = title
        return h
    }

    @objc private func actionTapped(_ g: UITapGestureRecognizer) {
        guard let title = g.view?.accessibilityLabel else { return }

        if title == "Поделиться" {
            let items: [Any] = ["Рекомендую: \(book.title) — \(book.author)"]
            let vc = UIActivityViewController(activityItems: items, applicationActivities: nil)
            present(vc, animated: true)
        } else if title == "В избранное" || title == "Убрать из избранного" {
            let newValue = title == "В избранное"
            FavoritesManager.shared.setFavorite(bookID: book.id, isFavorite: newValue)
            dismiss(animated: true)
        } else {
            dismiss(animated: true)
        }
    }

    @objc private func closeTapped() {
        dismiss(animated: true)
    }
}
