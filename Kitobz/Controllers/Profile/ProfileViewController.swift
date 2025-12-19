//
//  ProfileViewController.swift
//  Kitobz
//
//  Created by Boynuroдова Marhabo on 01/12/25.
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
        label.text = "Имя Пользователя"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "user@kitobz.com"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .systemGray
        return label
    }()
    
    private let tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .insetGrouped)
        tv.backgroundColor = .clear
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
        view.backgroundColor = UIColor(named: "Background")
        navigationItem.title = "Профиль"
        
        setupTableView()
        setupHeaderView()
        setupConstraints()
        
        // Подписка на события сессии
        NotificationCenter.default.addObserver(self, selector: #selector(handleSessionDidLogin), name: .sessionDidLogin, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleSessionDidLogout), name: .sessionDidLogout, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshHeader()
    }
    
    // MARK: - Setup
    
    private func setupHeaderView() {
        let headerContainer = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 220))
        headerContainer.addSubview(profileImageView)
        headerContainer.addSubview(nameLabel)
        headerContainer.addSubview(emailLabel)
        
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
    
    // MARK: - Header content update
    
    private func refreshHeader() {
        if let user = SessionManager.shared.currentUser, SessionManager.shared.isLoggedIn {
            nameLabel.text = user.name
            emailLabel.text = user.email
        } else {
            nameLabel.text = "Имя Пользователя"
            emailLabel.text = "user@kitobz.com"
        }
        if let header = tableView.tableHeaderView {
            header.setNeedsLayout()
            header.layoutIfNeeded()
            let size = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            var frame = header.frame
            frame.size.height = max(220, size.height)
            header.frame = frame
            tableView.tableHeaderView = header
        }
    }
    
    // MARK: - Auth presentation helpers
    
    private func presentAuthController() {
        let auth = AuthViewController()
        auth.modalPresentationStyle = .formSheet
        present(auth, animated: true)
    }
    
    private func presentLogin() {
        let vc = LoginViewController()
        vc.onAuthSuccess = { [weak self] in
            self?.dismiss(animated: true) // уведомление обновит шапку
        }
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .formSheet
        present(nav, animated: true)
    }
    
    private func presentRegister() {
        let vc = RegisterViewController()
        vc.onAuthSuccess = { [weak self] in
            self?.dismiss(animated: true) // уведомление обновит шапку
        }
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .formSheet
        present(nav, animated: true)
    }
    
    // MARK: - Session notifications
    
    @objc private func handleSessionDidLogin() {
        // Вызывается после SessionManager.login/register
        refreshHeader()
    }
    
    @objc private func handleSessionDidLogout() {
        refreshHeader()
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
            handleLogout()
            return
        }
        
        // Если не залогинен — сразу показываем AuthViewController (без алерта)
        guard SessionManager.shared.isLoggedIn else {
            presentAuthController()
            return
        }

        switch item.title {
        case "Мои заказы":
            let vc = MyOrdersViewController()
            navigationController?.pushViewController(vc, animated: true)
        case "Адреса доставки":
            let vc = AddressesViewController()
            navigationController?.pushViewController(vc, animated: true)
        case "Настройки":
            let vc = SettingsViewController()
            navigationController?.pushViewController(vc, animated: true)
        case "Помощь и FAQ":
            let vc = HelpViewController()
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
    
    private func handleLogout() {
        let alert = UIAlertController(title: "Выход", message: "Вы действительно хотите выйти из аккаунта?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Выйти", style: .destructive, handler: { [weak self] _ in
            SessionManager.shared.logout()
            // После выхода сразу показываем экран авторизации
            self?.presentAuthController()
        }))
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        present(alert, animated: true)
    }
}
