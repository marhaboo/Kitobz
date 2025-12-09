import Foundation

final class FavoritesManager {

    static let shared = FavoritesManager()
    private let key = "favorites_books_v1"

    private init() {}

    
    func loadFavorites() -> [Book] {
        guard let data = UserDefaults.standard.data(forKey: key) else { return [] }
        let decoder = JSONDecoder()
        return (try? decoder.decode([Book].self, from: data)) ?? []
    }


    private func saveFavorites(_ books: [Book]) {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(books) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    func add(_ book: Book) {
        var current = loadFavorites()
        if !current.contains(where: { $0.id == book.id }) {
            current.append(book)
            saveFavorites(current)
        }
    }

    func remove(_ book: Book) {
        var current = loadFavorites()
        current.removeAll { $0.id == book.id }
        saveFavorites(current)
    }

    func isFavorite(_ book: Book) -> Bool {
        loadFavorites().contains { $0.id == book.id }
    }
}
