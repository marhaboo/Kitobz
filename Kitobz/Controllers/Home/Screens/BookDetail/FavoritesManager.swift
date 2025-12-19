//
//  FavoritesManager.swift
//  Kitobz
//
//  Created by Boymurodova Marhabo on 10/12/25.
//

import Foundation

extension Notification.Name {
    static let favoritesDidChange = Notification.Name("FavoritesDidChangeNotification")
}

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
        storage.contains(bookID)
    }

    func setFavorite(bookID: String, isFavorite: Bool) {
        applyFavorite(bookID: bookID, isFavorite: isFavorite, shouldNotify: true)
    }

    func setFavoriteSilently(bookID: String, isFavorite: Bool) {
        applyFavorite(bookID: bookID, isFavorite: isFavorite, shouldNotify: false)
    }

    private func applyFavorite(bookID: String, isFavorite: Bool, shouldNotify: Bool) {
        if isFavorite {
            storage.insert(bookID)
        } else {
            storage.remove(bookID)
        }
        UserDefaults.standard.set(Array(storage), forKey: key)

        if shouldNotify {
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .favoritesDidChange, object: nil)
            }
        }
    }

    func allFavoriteIDs() -> [String] {
        Array(storage)
    }
}
