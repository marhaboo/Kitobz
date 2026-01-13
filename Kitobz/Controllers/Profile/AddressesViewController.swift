import UIKit
import SnapKit

struct AddressItem: Codable, Equatable {
    let id: UUID
    var receiver: String
    var addressLine: String
    var phone: String
    var isDefault: Bool

    init(id: UUID = UUID(), receiver: String, addressLine: String, phone: String, isDefault: Bool = false) {
        self.id = id
        self.receiver = receiver
        self.addressLine = addressLine
        self.phone = phone
        self.isDefault = isDefault
    }
}

final class AddressesStore {
    static let shared = AddressesStore()
    private let key = "addresses_store_key"

    private init() { }

    func load() -> [AddressItem] {
        guard let data = UserDefaults.standard.data(forKey: key) else { return [] }
        return (try? JSONDecoder().decode([AddressItem].self, from: data)) ?? []
    }

    func save(_ items: [AddressItem]) {
        let data = try? JSONEncoder().encode(items)
        UserDefaults.standard.set(data, forKey: key)
    }
}

final class AddressesViewController: UIViewController {

    private var items: [AddressItem] = []

    private let tableView = UITableView(frame: .zero, style: .plain)
    private let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Адреса доставки"
        view.backgroundColor = UIColor(named: "Background") ?? .systemBackground

        items = AddressesStore.shared.load()

        navigationItem.rightBarButtonItem = addButton
        addButton.target = self
        addButton.action = #selector(addAddress)

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(AddressCell.self, forCellReuseIdentifier: "cell")

        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.sectionHeaderTopPadding = 0
        tableView.tableHeaderView = UIView(frame: .zero)
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0

        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

    @objc private func addAddress() {
        presentAddressEditor()
    }

    private func presentAddressEditor(item: AddressItem? = nil, index: Int? = nil) {
        let alert = UIAlertController(title: item == nil ? "Новый адрес" : "Редактировать адрес", message: nil, preferredStyle: .alert)
        alert.addTextField { $0.placeholder = "Имя получателя"; $0.text = item?.receiver }
        alert.addTextField { $0.placeholder = "Адрес"; $0.text = item?.addressLine }
        alert.addTextField { $0.placeholder = "Телефон"; $0.keyboardType = .phonePad; $0.text = item?.phone }

        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        alert.addAction(UIAlertAction(title: "Сохранить", style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            let receiver = alert.textFields?[0].text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let addressLine = alert.textFields?[1].text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let phone = alert.textFields?[2].text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

            guard !receiver.isEmpty, !addressLine.isEmpty, !phone.isEmpty else { return }

            if let idx = index, let existing = item {
                var updated = existing
                updated.receiver = receiver
                updated.addressLine = addressLine
                updated.phone = phone
                self.items[idx] = updated
            } else {
                let makeDefault = self.items.isEmpty
                self.items.append(AddressItem(receiver: receiver, addressLine: addressLine, phone: phone, isDefault: makeDefault))
            }
            AddressesStore.shared.save(self.items)
            self.tableView.reloadData()
        }))

        present(alert, animated: true)
    }
}

extension AddressesViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int { 1 }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { items.count }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AddressCell
        cell.configure(with: item)
        cell.accessoryType = .detailButton
        return cell
    }

    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let it = items[indexPath.row]
        presentAddressEditor(item: it, index: indexPath.row)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        for i in 0..<items.count { items[i].isDefault = (i == indexPath.row) }
        AddressesStore.shared.save(items)
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Удалить") { [weak self] _, _, finish in
            guard let self = self else { return }
            self.items.remove(at: indexPath.row)
            if !self.items.contains(where: { $0.isDefault }), let first = self.items.indices.first {
                self.items[first].isDefault = true
            }
            AddressesStore.shared.save(self.items)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            finish(true)
        }
        return UISwipeActionsConfiguration(actions: [delete])
    }
}

// MARK: - AddressCell
class AddressCell: UITableViewCell {
    
    private let receiverLabel = UILabel()
    private let addressLabel = UILabel()
    private let phoneLabel = UILabel()
    private let defaultBadge = UILabel()
    private let separatorView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none
        
        receiverLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        receiverLabel.textColor = .label
        receiverLabel.numberOfLines = 1
        
        addressLabel.font = .systemFont(ofSize: 14, weight: .regular)
        addressLabel.textColor = .secondaryLabel
        addressLabel.numberOfLines = 1
        
        phoneLabel.font = .systemFont(ofSize: 14, weight: .regular)
        phoneLabel.textColor = .secondaryLabel
        phoneLabel.numberOfLines = 1
        
        defaultBadge.font = .systemFont(ofSize: 12, weight: .medium)
        defaultBadge.textColor = .systemGray
        defaultBadge.text = "• По умолчанию"
        defaultBadge.isHidden = true
        
        separatorView.backgroundColor = .systemGray5
        
        contentView.addSubview(receiverLabel)
        contentView.addSubview(defaultBadge)
        contentView.addSubview(addressLabel)
        contentView.addSubview(phoneLabel)
        contentView.addSubview(separatorView)
        
        receiverLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalToSuperview().offset(16)
            make.trailing.lessThanOrEqualToSuperview().inset(16)
        }
        
        defaultBadge.snp.makeConstraints { make in
            make.centerY.equalTo(receiverLabel)
            make.leading.equalTo(receiverLabel.snp.trailing).offset(8)
            make.trailing.lessThanOrEqualToSuperview().inset(16)
        }
        
        addressLabel.snp.makeConstraints { make in
            make.top.equalTo(receiverLabel.snp.bottom).offset(4)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().inset(16)
        }
        
        phoneLabel.snp.makeConstraints { make in
            make.top.equalTo(addressLabel.snp.bottom).offset(4)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(separatorView.snp.top).offset(-12)
        }
        
        separatorView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    func configure(with item: AddressItem) {
        receiverLabel.text = item.receiver
        addressLabel.text = item.addressLine
        phoneLabel.text = item.phone
        defaultBadge.isHidden = !item.isDefault
    }
}
