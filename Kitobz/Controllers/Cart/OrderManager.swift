//
//  OrderManager.swift
//  Kitobz
//
//  Created by Ilmhona 11 on 12/15/25.
//

class OrdersManager {
    static let shared = OrdersManager()
    private init() {}
    
    private(set) var orders: [Order] = []
    
    func addOrder(_ order: Order) {
        orders.append(order)
    }
}

