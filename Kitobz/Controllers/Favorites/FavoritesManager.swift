//
//  FavoritesManager.swift
//  Kitobz
//
//  Created by Madina on 09/12/25.
//

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

    func saveFavorites(_ books: [Book]) {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(books) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    func add(_ book: Book) {
        var current = loadFavorites()
        if !current.contains(book) {
            current.append(book)
            saveFavorites(current)
        }
    }

    func remove(_ book: Book) {
        var current = loadFavorites()
        current.removeAll { $0 == book }
        saveFavorites(current)
    }

    func isFavorite(_ book: Book) -> Bool {
        loadFavorites().contains(book)
    }
}
