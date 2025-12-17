

import UIKit
import SnapKit

// MARK: - FAQItem Model
struct FAQItem {
    let question: String
    let answer: String
    var isExpanded: Bool = false
}

// MARK: - HelpViewController
final class HelpViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .insetGrouped)
        tv.backgroundColor = .clear
        return tv
    }()
    
    private var faqItems: [FAQItem] = [
        FAQItem(
            question: "Как сделать заказ?",
            answer: "Выберите книгу, нажмите 'Добавить в корзину', перейдите в корзину и оформите заказ. Введите адрес доставки и выберите способ оплаты."
        ),
        FAQItem(
            question: "Какие способы оплаты доступны?",
            answer: "Мы принимаем оплату картой онлайн, наличными при получении и электронными кошельками (Click, Payme)."
        ),
        FAQItem(
            question: "Сколько времени занимает доставка?",
            answer: "Доставка по Душанбе занимает 1-2 рабочих дня. По регионам Таджикистана — 3-5 рабочих дней."
        ),
        FAQItem(
            question: "Можно ли вернуть книгу?",
            answer: "Да, вы можете вернуть книгу в течение 14 дней с момента получения, если она в идеальном состоянии и не была прочитана."
        ),
        FAQItem(
            question: "Как отследить мой заказ?",
            answer: "Перейдите в раздел 'Мои заказы' в профиле. Там вы увидите статус каждого заказа и трек-номер для отслеживания."
        ),
        FAQItem(
            question: "Есть ли программа лояльности?",
            answer: "Да! За каждый заказ вы получаете баллы, которые можно обменять на скидки при следующих покупках."
        ),
        FAQItem(
            question: "Как связаться со службой поддержки?",
            answer: "Вы можете написать нам на email: support@kitobz.tj, позвонить по телефону +992 123 456 789 или в Telegram: @kitobz_support"
        )
    ]
    
    private let contactSection: [(title: String, value: String, icon: String)] = [
        ("Email", "support@kitobz.tj", "envelope.fill"),
        ("Телефон", "+992 123 456 789", "phone.fill"),
        ("Telegram", "@kitobz_support", "paperplane.fill"),
        ("Время работы", "Пн-Пт: 9:00-18:00", "clock.fill")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Помощь и FAQ"
        view.backgroundColor = UIColor(named: "Background") ?? .systemBackground
        
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FAQCell.self, forCellReuseIdentifier: "FAQCell")
        tableView.register(ContactCell.self, forCellReuseIdentifier: "ContactCell")
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - UITableViewDelegate & DataSource
extension HelpViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2 // FAQ + Контакты
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return faqItems.count
        } else {
            return contactSection.count
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Частые вопросы" : "Контакты"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FAQCell", for: indexPath) as! FAQCell
            let item = faqItems[indexPath.row]
            cell.configure(with: item)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as! ContactCell
            let contact = contactSection[indexPath.row]
            cell.configure(title: contact.title, value: contact.value, icon: contact.icon)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            faqItems[indexPath.row].isExpanded.toggle()
            tableView.reloadRows(at: [indexPath], with: .automatic)
        } else {
            let contact = contactSection[indexPath.row]
            handleContactTap(title: contact.title, value: contact.value)
        }
    }
    
    private func handleContactTap(title: String, value: String) {
        let alert = UIAlertController(title: title, message: value, preferredStyle: .actionSheet)
        
        if title == "Email" {
            alert.addAction(UIAlertAction(title: "Скопировать", style: .default) { _ in
                UIPasteboard.general.string = value
            })
        } else if title == "Телефон" {
            alert.addAction(UIAlertAction(title: "Позвонить", style: .default) { _ in
                if let url = URL(string: "tel://\(value.replacingOccurrences(of: " ", with: ""))") {
                    UIApplication.shared.open(url)
                }
            })
            alert.addAction(UIAlertAction(title: "Скопировать", style: .default) { _ in
                UIPasteboard.general.string = value
            })
        } else if title == "Telegram" {
            alert.addAction(UIAlertAction(title: "Открыть Telegram", style: .default) { _ in
                if let url = URL(string: "https://t.me/\(value.dropFirst())") {
                    UIApplication.shared.open(url)
                }
            })
        }
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        present(alert, animated: true)
    }
}

// MARK: - FAQCell
class FAQCell: UITableViewCell {
    
    private let questionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    private let answerLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.alpha = 0
        return label
    }()
    
    private let chevronImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "chevron.down")
        iv.tintColor = .systemGray
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(questionLabel)
        contentView.addSubview(answerLabel)
        contentView.addSubview(chevronImageView)
        
        questionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalTo(chevronImageView.snp.leading).offset(-8)
        }
        
        chevronImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalTo(questionLabel)
            make.width.height.equalTo(16)
        }
        
        answerLabel.snp.makeConstraints { make in
            make.top.equalTo(questionLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(12)
        }
    }
    
    func configure(with item: FAQItem) {
        questionLabel.text = item.question
        answerLabel.text = item.answer
        
        if item.isExpanded {
            answerLabel.alpha = 1
            chevronImageView.transform = CGAffineTransform(rotationAngle: .pi)
        } else {
            answerLabel.alpha = 0
            chevronImageView.transform = .identity
        }
    }
}

// MARK: - ContactCell
class ContactCell: UITableViewCell {
    
    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .systemBlue
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
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
            make.top.equalToSuperview().offset(12)
            make.width.height.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(16)
            make.top.equalTo(iconImageView)
        }
        
        valueLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.trailing.equalToSuperview().inset(16)
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.bottom.equalToSuperview().inset(12)
        }
    }
    
    func configure(title: String, value: String, icon: String) {
        titleLabel.text = title
        valueLabel.text = value
        iconImageView.image = UIImage(systemName: icon)
    }
}
