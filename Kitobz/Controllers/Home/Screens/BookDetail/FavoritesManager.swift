//
//  FavoritesManager.swift
//  Kitobz
//
//  Created by Boymurodova Marhabo on 10/12/25.
//

import Foundation

final class FavoritesManager {
    static let shared = FavoritesManager()
    private let key = "kitobz_favorite_book_ids_v1"
    private var storage: Set<String>

    private init() {
        if let saved = UserDefaults.standard.array(forKey: key) as? [String] {
            storage = Set(saved)
        } else {
            storage = []
        }
    }

    func isFavorite(bookID: String) -> Bool {
        return storage.contains(bookID)
    }

    func setFavorite(bookID: String, isFavorite: Bool) {
        if isFavorite {
            storage.insert(bookID)
        } else {
            storage.remove(bookID)
        }
        UserDefaults.standard.set(Array(storage), forKey: key)
    }

    func allFavoriteIDs() -> [String] {
        return Array(storage)
    }
}
