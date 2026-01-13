//
//  OrdersManager.swift
//  Kitobz
//
//  Created by Ilmhona 11 on 12/15/25.
//

import Foundation

extension Notification.Name {
    static let ordersDidChange = Notification.Name("ordersDidChange")
}

class OrdersManager {
    static let shared = OrdersManager()
    
    private(set) var orders: [Order] = []
    
    private init() {
        loadOrders()
    }
    
    func addOrder(_ order: Order) {
        orders.append(order)
        saveOrders()
        NotificationCenter.default.post(name: .ordersDidChange, object: nil)
    }
    
    func removeOrder(at index: Int) {
        guard index >= 0 && index < orders.count else { return }
        orders.remove(at: index)
        saveOrders()
        NotificationCenter.default.post(name: .ordersDidChange, object: nil)
    }
    
    private func saveOrders() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(orders.map { OrderData(from: $0) }) {
            UserDefaults.standard.set(encoded, forKey: "savedOrders")
        }
    }
    
    private func loadOrders() {
        if let data = UserDefaults.standard.data(forKey: "savedOrders"),
           let decoded = try? JSONDecoder().decode([OrderData].self, from: data) {
            orders = decoded.map { $0.toOrder() }
        }
    }
}

// MARK: - Codable Wrapper for Order

private struct OrderData: Codable {
    let items: [BookData]
    let totalAmount: Int
    let date: Date
    
    init(from order: Order) {
        self.items = order.items.map { BookData(from: $0) }
        self.totalAmount = order.totalAmount
        self.date = order.date
    }
    
    func toOrder() -> Order {
        return Order(
            items: items.map { $0.toBook() },
            totalAmount: totalAmount,
            date: date
        )
    }
}

private struct BookData: Codable {
    let coverImageName: String
    let title: String
    let author: String
    let price: String
    let oldPrice: String?
    let discountText: String?
    let id: String
    
    init(from book: Book) {
        self.coverImageName = book.coverImageName
        self.title = book.title
        self.author = book.author
        self.price = book.price
        self.oldPrice = book.oldPrice
        self.discountText = book.discountText
        self.id = book.id
    }
    
    func toBook() -> Book {
        return Book(
            coverImageName: coverImageName,
            title: title,
            author: author,
            price: price,
            oldPrice: oldPrice,
            discountText: discountText,
            id: id,
            bookDescription: "",
            rating: 0.0,
            ageRating: "",
            language: "",
            coverType: "",
            pageCount: 0,
            publishYear: 0,
            reviews: [],
            quotes: [],
            otherBooksByAuthor: [],
            isFavorite: false
        )
    }
}
