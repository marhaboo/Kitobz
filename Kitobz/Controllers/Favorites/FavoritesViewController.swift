import UIKit

final class FavoritesViewController: UIViewController {

    private var favorites: [Book] = []

    private let tableView = UITableView()

    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "У вас пока нет избранных\nДобавьте книги"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Избранное"
        view.backgroundColor = .systemBackground

        setupTableView()
        
        
       
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

    private func setupTableView() {
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(FavoriteCell.self, forCellReuseIdentifier: FavoriteCell.reuseId)
        tableView.rowHeight = 110
        view.addSubview(tableView)
    }

    private func loadFavorites() {
        favorites = FavoritesManager.shared.loadFavorites()
        updateUI()
    }

    private func updateUI() {
        tableView.reloadData()
        tableView.backgroundView = favorites.isEmpty ? emptyLabel : nil
    }
}

// MARK: - UITableViewDataSource
extension FavoritesViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.reuseId, for: indexPath) as? FavoriteCell else {
            return UITableViewCell()
        }

        let book = favorites[indexPath.row]
        cell.configure(with: book)
        cell.delegate = self

        return cell
    }
}

// MARK: - UITableViewDelegate
extension FavoritesViewController: UITableViewDelegate {

    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { action, view, completion in
            let book = self.favorites[indexPath.row]
            FavoritesManager.shared.remove(book)
            self.favorites.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            self.updateUI()
            completion(true)
        }

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

// MARK: - FavoriteCellDelegate
extension FavoritesViewController: FavoriteCellDelegate {

    func favoriteCellDidTapCart(_ cell: FavoriteCell) {
        
        if let tabBar = self.tabBarController {
            tabBar.selectedIndex = 2 
        }
    }
}
