//
//  CartViewController.swift
//  Kitobz
//
//  Created by Boynurodova Marhabo on 01/12/25.
//

import UIKit
import SnapKit

struct CartItem {
    let title: String
    let author: String
    let price: Int
}

class CartViewController: UIViewController {

    private var cartItems: [CartItem] = [
        CartItem(title: "Book 1", author: "Author 1", price: 100),
        CartItem(title: "Book 2", author: "Author 2", price: 200),
        CartItem(title: "Book 3", author: "Author 3", price: 150)
    ]

    private let tableView: UITableView = {
        let table = UITableView()
        table.register(CartCell.self, forCellReuseIdentifier: "CartCell")
        table.separatorStyle = .none
        return table
    }()
    
    private let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.97, alpha: 1)
        view.layer.cornerRadius = 20
        return view
    }()
    
    private let totalLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    private let checkoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Оформить заказ", for: .normal)
        button.tintColor = .white
        button.backgroundColor = .red
        button.layer.cornerRadius = 12
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        tableView.dataSource = self
        
        setupLayout()
        updateTotal()
    }
    
    private func setupLayout() {
        view.addSubview(tableView)
        view.addSubview(bottomView)
        
        bottomView.addSubview(totalLabel)
        bottomView.addSubview(checkoutButton)
        
        bottomView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.height.equalTo(130)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(bottomView.snp.top)
        }
        
        totalLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(20)
        }
        
        checkoutButton.snp.makeConstraints { make in
            make.top.equalTo(totalLabel.snp.bottom).offset(15)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
    }
    
    private func updateTotal() {
        let sum = cartItems.reduce(0) { $0 + $1.price }
        totalLabel.text = "Итого: \(sum) сомони"
    }
}

extension CartViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartCell
        
        let item = cartItems[indexPath.row]
        cell.configure(bookName: item.title, author: item.author, price: item.price)
        
        return cell
    }
}

