    //
    //  SettingItem.swift
    //  Kitobz
    //
    //  Created by Ilmhona 12 on 17/12/25.
    //


    import UIKit
    import SnapKit

    // MARK: - SettingItem Model
    struct SettingItem {
        let title: String
        let icon: String
        let type: ItemType
        
        enum ItemType {
            case toggle(key: String, defaultValue: Bool)
            case disclosure
            case info(value: String)
        }
    }

    // MARK: - SettingsViewController
    final class SettingsViewController: UIViewController {
        
        private let tableView: UITableView = {
            let tv = UITableView(frame: .zero, style: .insetGrouped)
            tv.backgroundColor = .clear
            return tv
        }()
        
        private enum SettingSection: Int, CaseIterable {
            case appearance
            case notifications
            case account
            case about
            
            var title: String {
                switch self {
                case .appearance: return "Внешний вид"
                case .notifications: return "Уведомления"
                case .account: return "Аккаунт"
                case .about: return "О приложении"
                }
            }
        }
        
        private let settings: [SettingSection: [SettingItem]] = [
            .appearance: [
                SettingItem(title: "Темная тема", icon: "moon.fill", type: .toggle(key: "darkMode", defaultValue: false)),
                SettingItem(title: "Размер шрифта", icon: "textformat.size", type: .disclosure)
            ],
            .notifications: [
                SettingItem(title: "Push-уведомления", icon: "bell.fill", type: .toggle(key: "pushNotifications", defaultValue: true)),
                SettingItem(title: "Уведомления о заказах", icon: "box.fill", type: .toggle(key: "orderNotifications", defaultValue: true)),
                SettingItem(title: "Акции и скидки", icon: "tag.fill", type: .toggle(key: "promoNotifications", defaultValue: false))
            ],
            .account: [
                SettingItem(title: "Изменить пароль", icon: "lock.fill", type: .disclosure),
                SettingItem(title: "Конфиденциальность", icon: "hand.raised.fill", type: .disclosure),
                SettingItem(title: "Удалить аккаунт", icon: "trash.fill", type: .disclosure)
            ],
            .about: [
                SettingItem(title: "Версия", icon: "info.circle.fill", type: .info(value: "1.0.0")),
                SettingItem(title: "Условия использования", icon: "doc.text.fill", type: .disclosure),
                SettingItem(title: "Политика конфиденциальности", icon: "shield.fill", type: .disclosure)
            ]
        ]
        
        override func viewDidLoad() {
            super.viewDidLoad()
            title = "Настройки"
            view.backgroundColor = UIColor(named: "Background") ?? .systemBackground
            
            setupTableView()
            loadUserSettings()
        }
        
        private func setupTableView() {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(SettingCell.self, forCellReuseIdentifier: "SettingCell")
            
            view.addSubview(tableView)
            tableView.snp.makeConstraints { make in
                make.edges.equalTo(view.safeAreaLayoutGuide)
            }
        }
        
        private func loadUserSettings() {
            if UserDefaults.standard.bool(forKey: "darkMode") {
                view.window?.overrideUserInterfaceStyle = .dark
            }
        }
        
        private func handleToggle(key: String, isOn: Bool) {
            UserDefaults.standard.set(isOn, forKey: key)
            
            switch key {
            case "darkMode":
                UIView.animate(withDuration: 0.3) {
                    self.view.window?.overrideUserInterfaceStyle = isOn ? .dark : .light
                }
            case "pushNotifications":
                print("Push-уведомления: \(isOn ? "включены" : "выключены")")
            case "orderNotifications":
                print("Уведомления о заказах: \(isOn ? "включены" : "выключены")")
            case "promoNotifications":
                print("Уведомления о акциях: \(isOn ? "включены" : "выключены")")
            default:
                break
            }
        }
        
        private func handleDisclosure(title: String) {
            let alert = UIAlertController(title: title, message: "Эта функция будет доступна в следующей версии", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }

    // MARK: - UITableViewDelegate & DataSource
    extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
        
        func numberOfSections(in tableView: UITableView) -> Int {
            return SettingSection.allCases.count
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            guard let settingSection = SettingSection(rawValue: section) else { return 0 }
            return settings[settingSection]?.count ?? 0
        }
        
        func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            return SettingSection(rawValue: section)?.title
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath) as! SettingCell
            
            guard let section = SettingSection(rawValue: indexPath.section),
                  let item = settings[section]?[indexPath.row] else {
                return cell
            }
            
            cell.configure(with: item) { [weak self] newValue in
                if case .toggle(let key, _) = item.type {
                    self?.handleToggle(key: key, isOn: newValue)
                }
            }
            
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            
            guard let section = SettingSection(rawValue: indexPath.section),
                  let item = settings[section]?[indexPath.row] else {
                return
            }
            
            if case .disclosure = item.type {
                handleDisclosure(title: item.title)
            }
        }
    }

    // MARK: - SettingCell
    class SettingCell: UITableViewCell {
        
        private let iconImageView: UIImageView = {
            let iv = UIImageView()
            iv.contentMode = .scaleAspectFit
            iv.tintColor = .label
            return iv
        }()
        
        private let titleLabel: UILabel = {
            let label = UILabel()
            label.font = .systemFont(ofSize: 16, weight: .regular)
            label.textColor = .label
            return label
        }()
        
        private let valueLabel: UILabel = {
            let label = UILabel()
            label.font = .systemFont(ofSize: 15, weight: .regular)
            label.textColor = .secondaryLabel
            label.textAlignment = .right
            return label
        }()
        
        private let toggle: UISwitch = {
            let sw = UISwitch()
            return sw
        }()
        
        private var toggleAction: ((Bool) -> Void)?
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            setupUI()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func setupUI() {
            contentView.addSubview(iconImageView)
            contentView.addSubview(titleLabel)
            contentView.addSubview(valueLabel)
            
            iconImageView.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(16)
                make.centerY.equalToSuperview()
                make.width.height.equalTo(24)
            }
            
            titleLabel.snp.makeConstraints { make in
                make.leading.equalTo(iconImageView.snp.trailing).offset(12)
                make.centerY.equalToSuperview()
            }
            
            valueLabel.snp.makeConstraints { make in
                make.trailing.equalToSuperview().inset(16)
                make.centerY.equalToSuperview()
                make.leading.greaterThanOrEqualTo(titleLabel.snp.trailing).offset(8)
            }
            
            toggle.addTarget(self, action: #selector(toggleChanged), for: .valueChanged)
        }
        
        func configure(with item: SettingItem, toggleAction: ((Bool) -> Void)? = nil) {
            iconImageView.image = UIImage(systemName: item.icon)
            titleLabel.text = item.title
            self.toggleAction = toggleAction
            
            accessoryView = nil
            accessoryType = .none
            valueLabel.text = nil
            
            switch item.type {
            case .toggle(let key, let defaultValue):
                let currentValue = UserDefaults.standard.object(forKey: key) as? Bool ?? defaultValue
                toggle.isOn = currentValue
                accessoryView = toggle
                
            case .disclosure:
                accessoryType = .disclosureIndicator
                
            case .info(let value):
                valueLabel.text = value
            }
        }
        
        @objc private func toggleChanged() {
            toggleAction?(toggle.isOn)
        }
    }
