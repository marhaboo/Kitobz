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

    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

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
                // Если это первый адрес — делаем его адресом по умолчанию
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
        let it = items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var conf = cell.defaultContentConfiguration()
        conf.text = it.receiver + (it.isDefault ? "  • По умолчанию" : "")
        conf.secondaryText = "\(it.addressLine)\n\(it.phone)"
        conf.secondaryTextProperties.numberOfLines = 2
        cell.contentConfiguration = conf
        cell.accessoryType = .detailButton
        return cell
    }

    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let it = items[indexPath.row]
        presentAddressEditor(item: it, index: indexPath.row)
    }

    // Выбор адреса по умолчанию по тапу
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for i in 0..<items.count { items[i].isDefault = (i == indexPath.row) }
        AddressesStore.shared.save(items)
        tableView.reloadData()
    }

    // Удаление свайпом
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Удалить") { [weak self] _, _, finish in
            guard let self = self else { return }
            self.items.remove(at: indexPath.row)
            // Если не осталось адреса по умолчанию — назначим первый как default
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
