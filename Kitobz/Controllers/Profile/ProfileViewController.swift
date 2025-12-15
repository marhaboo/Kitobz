//
//  ProfileViewController.swift
//  Kitobz
//
//  Created by Boynurodova Marhabo on 01/12/25.
//

import UIKit
import SnapKit

class ProfileViewController: UIViewController {
    
    // MARK: - UI Components
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "person.circle.fill")
        iv.tintColor = .systemGray3
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 50
        iv.clipsToBounds = true
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        // *** ИЗМЕНЕНИЕ: Убираем фамилию и используем плейсхолдер ***
        label.text = "Имя Пользователя"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "user@kitobz.com" // Мок-данные для примера
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .systemGray
        return label
    }()
    
    private let tableView: UITableView = {
        // Используем style: .insetGrouped для современного вида iOS
        let tv = UITableView(frame: .zero, style: .insetGrouped)
        tv.backgroundColor = .clear // чтобы фон совпадал с background view
        return tv
    }()
    
    // MARK: - Data
    
    private let menuItems: [ProfileMenuItem] = [
        ProfileMenuItem(title: "Мои заказы", iconName: "list.bullet.clipboard", isDestructive: false),
        ProfileMenuItem(title: "Адреса доставки", iconName: "mappin.and.ellipse", isDestructive: false),
        ProfileMenuItem(title: "Настройки", iconName: "gearshape", isDestructive: false),
        ProfileMenuItem(title: "Помощь и FAQ", iconName: "questionmark.circle", isDestructive: false),
        ProfileMenuItem(title: "Выйти", iconName: "arrow.right.square", isDestructive: true)
    ]
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Используем кастомный цвет фона вашего приложения
        view.backgroundColor = UIColor(named: "Background") ?? .systemBackground
        navigationItem.title = "Профиль"
        
        setupTableView()
        setupHeaderView()
        setupConstraints()
    }
    
    // MARK: - Setup
    
    private func setupHeaderView() {
        // Создаем контейнер для хедера
        let headerContainer = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 220))
        
        headerContainer.addSubview(profileImageView)
        headerContainer.addSubview(nameLabel)
        headerContainer.addSubview(emailLabel)
        
        // Настраиваем Auto Layout для элементов хедера
        profileImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(30)
            make.width.height.equalTo(100)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(profileImageView.snp.bottom).offset(15)
        }
        
        emailLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
        }
        
        // Устанавливаем хедер для таблицы
        tableView.tableHeaderView = headerContainer
        tableView.tableHeaderView?.frame.size.height = headerContainer.frame.height
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ProfileCell.self, forCellReuseIdentifier: ProfileCell.id)
    }
    
    private func setupConstraints() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileCell.id, for: indexPath) as? ProfileCell else {
            return UITableViewCell()
        }
        
        let item = menuItems[indexPath.row]
        cell.configure(with: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = menuItems[indexPath.row]
        
        if item.isDestructive {
            // Логика выхода
            handleLogout()
        } else if item.title == "Мои заказы" {
            let ordersVC = MyOrdersViewController()
            navigationController?.pushViewController(ordersVC, animated: true) 
        } else {
            print("Нажата опция: \(item.title)")
            // Логика перехода на другой экран
        }
    }
    
    private func handleLogout() {
        // Здесь должна быть логика очистки токенов и переход на экран авторизации
        print("Пользователь вышел из системы")
    }
}

