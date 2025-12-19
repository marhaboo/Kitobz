//
//  CartViewController.swift
//  Kitobz
//
//  Created by Boymurodova Marhabo on 01/12/25.
//

import UIKit
import SnapKit

class CartViewController: UIViewController {

    private let tableView: UITableView = {
        let table = UITableView()
        table.register(CartCell.self, forCellReuseIdentifier: "CartCell")
        table.separatorStyle = .none
        table.backgroundColor = .clear
        table.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        return table
    }()
    
    private let emptyStateView: UIView = {
        let view = UIView()
        view.isHidden = true
        return view
    }()
    
    private let emptyStateIcon: UILabel = {
        let label = UILabel()
        label.text = "🛒"
        label.font = .systemFont(ofSize: 60)
        label.textAlignment = .center
        return label
    }()
    
    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "Ваша корзина пуста\n\nДобавьте книги в корзину, чтобы оформить заказ"
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
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
    
    private var items: [Book] { CartManager.shared.items }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "Background")
        
        navigationItem.title = "Корзина"
        
        tableView.dataSource = self
        tableView.delegate = self
        
        setupLayout()
        setupEmptyStateView()
        updateTotal()
        updateEmptyState()
        
        checkoutButton.addTarget(self, action: #selector(didTapCheckout), for: .touchUpInside)

        NotificationCenter.default.addObserver(self, selector: #selector(onCartChanged), name: .cartDidChange, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func onCartChanged() {
        tableView.reloadData()
        updateTotal()
        updateEmptyState()
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
    
    private func setupEmptyStateView() {
        view.addSubview(emptyStateView)
        emptyStateView.addSubview(emptyStateIcon)
        emptyStateView.addSubview(emptyStateLabel)
        
        emptyStateView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.left.right.equalToSuperview().inset(40)
        }
        
        emptyStateIcon.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        emptyStateLabel.snp.makeConstraints { make in
            make.top.equalTo(emptyStateIcon.snp.bottom).offset(16)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func updateEmptyState() {
        let isEmpty = items.isEmpty
        emptyStateView.isHidden = !isEmpty
        tableView.isHidden = isEmpty
        bottomView.isHidden = isEmpty
    }
    
    private func updateTotal() {
        let sum = CartManager.shared.totalAmount()
        totalLabel.text = "Итого: \(sum) сомони"
    }
    
    @objc private func didTapCheckout() {
        let selected = CartManager.shared.selectedItems()
        guard !selected.isEmpty else {
            let alert = UIAlertController(
                title: "Корзина пуста",
                message: "Выберите хотя бы одну книгу",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        
        let total = CartManager.shared.totalAmount()
        let checkoutVC = CheckoutViewController()
        checkoutVC.selectedItems = selected
        checkoutVC.totalAmount = total
        
        navigationController?.pushViewController(checkoutVC, animated: true)
    }
}

extension CartViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartCell
        let book = items[indexPath.row]

        let isSelected = CartManager.shared.isSelected(bookID: book.id)
        cell.configure(with: book, isSelected: isSelected)
        
        cell.onCheckTap = { [weak tableView] in
            CartManager.shared.toggleSelected(bookID: book.id)
            if let ip = tableView?.indexPath(for: cell) {
                tableView?.reloadRows(at: [ip], with: .none)
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { _, _, finish in
            let book = self.items[indexPath.row]
            CartManager.shared.remove(bookID: book.id)
            finish(true)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
