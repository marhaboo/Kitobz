//
//  FavoritesViewController.swift
//  Kitobz
//
//  Created by Madina on 09/12/25.
//

import UIKit

final class FavoritesViewController: UIViewController {

    private var favorites: [Book] = []

    private let tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.separatorStyle = .none
        return tv
    }()

    // MARK: - Пустой лейбл
    private let emptyView: UILabel = {
        let label = UILabel()
        label.text = "У вас пока нет избранных\nДобавьте книги, нажав ❤️"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Избранные"

       

            setupTable()
                  UserDefaults.standard.removeObject(forKey: "favorites_books_v1")

        
        let book1 = Book(id: "1", title: "Гарри Поттер и философский камень", author: "Дж. К. Роулинг", price: 12 * 11, imageName: "HarryPotter1")
        let book2 = Book(id: "2", title: "Властелин колец: Братство кольца", author: "Дж. Р. Р. Толкин", price: 15 * 11, imageName: "LordOfTheRings1")
        let book3 = Book(id: "3", title: "Голодные игры", author: "Сьюзен Коллинз", price: 10 * 11, imageName: "HungerGames1")
        let book4 = Book(id: "4", title: "Сумерки", author: "Стефани Майер", price: 11 * 11, imageName: "Twilight1")
        let book5 = Book(id: "5", title: "Дневник слабака", author: "Джефф Кинни", price: 8 * 11, imageName: "DiaryOfAWimpyKid")

      let books = [book1, book2, book3, book4, book5]

      for book in books {
            FavoritesManager.shared.add(book)
        }

            loadFavorites()
       
      
    }

    // MARK: - Настройка таблицы
    private func setupTable() {
        view.addSubview(tableView)
        tableView.register(FavoriteCell.self, forCellReuseIdentifier: FavoriteCell.reuseId)
        tableView.dataSource = self
        tableView.delegate = self

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    // MARK: - Загрузка избранного
    private func loadFavorites() {
        favorites = FavoritesManager.shared.loadFavorites()
        updateUI()
    }

    // MARK: - Обновление UI
    private func updateUI() {
        tableView.reloadData()

        if favorites.isEmpty {
            // Создаем контейнер для центрирования лейбла
            let container = UIView(frame: tableView.bounds)
            container.addSubview(emptyView)

            NSLayoutConstraint.activate([
                emptyView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
                emptyView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
                emptyView.leadingAnchor.constraint(greaterThanOrEqualTo: container.leadingAnchor, constant: 20),
                emptyView.trailingAnchor.constraint(lessThanOrEqualTo: container.trailingAnchor, constant: -20)
            ])

            tableView.backgroundView = container
        } else {
            tableView.backgroundView = nil
        }
    }
}

// MARK: - UITableViewDataSource & Delegate
extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.reuseId, for: indexPath) as? FavoriteCell else {
            return UITableViewCell()
        }

        let book = favorites[indexPath.row]
        cell.configure(with: book, isFavorite: true)
        return cell
    }
}
