//
//  CartViewController.swift
//  Kitobz
//
//  Created by Boynurodova Marhabo on 01/12/25.
//
//===

import UIKit
import SnapKit

struct CartItem {
    let title: String
    let author: String
    let price: Int
    var isSelected: Bool = false
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
        button.backgroundColor = UIColor(named: "AccentColor")
        button.layer.cornerRadius = 12
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        navigationItem.title = "Корзина"
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont.boldSystemFont(ofSize: 24)
        ]
        
        tableView.dataSource = self
        tableView.delegate = self
        
        setupLayout()
        updateTotal()
        
        checkoutButton.addTarget(self, action: #selector(didTapCheckout), for: .touchUpInside)
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
        let sum = cartItems.reduce(0) { $0 + ($1.isSelected ? $1.price : 0) }
        totalLabel.text = "Итого: \(sum) сомони"
    }
    
    @objc private func didTapCheckout() {
        // Отбираем только выбранные книги
        let checkoutVC = CheckoutViewController()
        checkoutVC.selectedItems = cartItems.filter { $0.isSelected }
        
        // Переходим на экран Checkout
        navigationController?.pushViewController(checkoutVC, animated: true)
    }
}

extension CartViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartCell
        
        let item = cartItems[indexPath.row]
        cell.configure(
            bookName: item.title,
            author: item.author,
            price: item.price,
            isSelected: item.isSelected
        )
        
        // ВАЖНО: правильный callback (без indexPath из прошлого)
        cell.onCheckTap = { [weak self, weak cell] in
            guard let self = self else { return }
            guard let cell = cell else { return }
            
            // Получаем актуальный indexPath ячейки
            guard let tappedIndexPath = tableView.indexPath(for: cell) else { return }
            
            // Переключаем выбор
            self.cartItems[tappedIndexPath.row].isSelected.toggle()
            
            // Обновляем сумму
            self.updateTotal()
            
            // Обновляем UI ячейки
            self.tableView.reloadRows(at: [tappedIndexPath], with: .none)
        }
        
        return cell
    }

    
    // ✅ Свайп для удаления
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { _, _, finish in
            self.cartItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            self.updateTotal()
            finish(true)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

