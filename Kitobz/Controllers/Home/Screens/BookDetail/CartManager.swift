//
//  CartManager.swift
//  Kitobz
//
//  Created by Assistant on 19/12/25.
//

import Foundation

extension Notification.Name {
    static let cartDidChange = Notification.Name("CartDidChangeNotification")
}

final class CartManager {
    static let shared = CartManager()

    private(set) var items: [Book] = []

    private init() {}

    func contains(_ book: Book) -> Bool {
        items.contains(where: { $0.id == book.id })
    }

    func add(_ book: Book) {
        guard !contains(book) else {
            notify()
            return
        }
        items.append(book)
        notify()
    }

    func remove(bookID: String) {
        items.removeAll { $0.id == bookID }
        notify()
    }

    func clear() {
        items.removeAll()
        notify()
    }

    private var selectedIDs: Set<String> = []

    func isSelected(bookID: String) -> Bool {
        selectedIDs.contains(bookID)
    }

    func toggleSelected(bookID: String) {
        if selectedIDs.contains(bookID) {
            selectedIDs.remove(bookID)
        } else {
            selectedIDs.insert(bookID)
        }
        notify()
    }

    func selectedItems() -> [Book] {
        items.filter { selectedIDs.contains($0.id) }
    }

    func totalAmount() -> Int {
        selectedItems().reduce(0) { partial, book in
            partial + parsePrice(book.price)
        }
    }

    private func parsePrice(_ text: String) -> Int {
        let digits = text.compactMap { $0.isNumber ? Int(String($0)) : nil }
        guard !digits.isEmpty else { return 0 }
        var value = 0
        for d in digits { value = value * 10 + d }
        return value
    }

    private func notify() {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .cartDidChange, object: nil)
        }
    }
}

