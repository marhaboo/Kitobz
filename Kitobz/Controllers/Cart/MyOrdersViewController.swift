//
//  MyOrdersViewController.swift
//  Kitobz
//
//  Created by Ilmhona 11 on 12/15/25.
//

import UIKit

class MyOrdersViewController: UIViewController {
    
    private let tableView = UITableView()
    private var orders: [Order] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Мои заказы"
        setupTableView()
        loadOrders()
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "OrderCell")
    }

    private func loadOrders() {
        orders = OrdersManager.shared.orders
        tableView.reloadData()
    }
}

extension MyOrdersViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath)
        let order = orders[indexPath.row]
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        
        let itemsTitles = order.items.map { $0.title }.joined(separator: ", ")
        cell.textLabel?.text = "\(itemsTitles) — \(order.totalAmount) сомони (\(dateFormatter.string(from: order.date)))"
        cell.textLabel?.numberOfLines = 0
        return cell
    }
}
