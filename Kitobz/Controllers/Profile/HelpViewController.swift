
import UIKit
import SnapKit

struct FAQItem {
    let question: String
    let answer: String
    var isExpanded: Bool = false
}

final class HelpViewController: UIViewController {
    
    private let tableView = UITableView(frame: .zero, style: .plain)
    
    private var faqItems: [FAQItem] = [
        FAQItem(question: "Как сделать заказ?", answer: "Выберите книгу, нажмите 'Добавить в корзину', перейдите в корзину и оформите заказ. Введите адрес доставки и выберите способ оплаты."),
        FAQItem(question: "Какие способы оплаты доступны?", answer: "Мы принимаем оплату картой онлайн, наличными при получении и электронными кошельками (Click, Payme)."),
        FAQItem(question: "Сколько времени занимает доставка?", answer: "Доставка по Душанбе занимает 1-2 рабочих дня. По регионам Таджикистана — 3-5 рабочих дней."),
        FAQItem(question: "Можно ли вернуть книгу?", answer: "Да, вы можете вернуть книгу в течение 14 дней с момента получения, если она в идеальном состоянии и не была прочитана."),
        FAQItem(question: "Как отследить мой заказ?", answer: "Перейдите в раздел 'Мои заказы' в профиле. Там вы увидите статус каждого заказа и трек-номер для отслеживания."),
        FAQItem(question: "Есть ли программа лояльности?", answer: "Да! За каждый заказ вы получаете баллы, которые можно обменять на скидки при следующих покупках."),
        FAQItem(question: "Как связаться со службой поддержки?", answer: "Вы можете написать нам на email: support@kitobz.tj, позвонить по телефону +992 123 456 789 или в Telegram: @kitobz_support")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Помощь и FAQ"
        view.backgroundColor = .systemBackground
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FAQCell.self, forCellReuseIdentifier: "FAQCell")
        tableView.backgroundColor = .systemBackground
        tableView.separatorStyle = .none
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension HelpViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return faqItems.count
        } else {
            return 4
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Частые вопросы" : "Контакты"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FAQCell", for: indexPath) as! FAQCell
            cell.configure(with: faqItems[indexPath.row])
            return cell
        } else {
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "ContactCell")
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            
            let contacts = [
                ("Email", "support@kitobz.tj", "envelope.fill"),
                ("Телефон", "+992 123 456 789", "phone.fill"),
                ("Telegram", "@kitobz_support", "paperplane.fill"),
                ("Время работы", "Пн-Пт: 9:00-18:00", "clock.fill")
            ]
            
            let contact = contacts[indexPath.row]
            cell.imageView?.image = UIImage(systemName: contact.2)
            cell.imageView?.tintColor = .systemBlue
            cell.textLabel?.text = contact.0
            cell.detailTextLabel?.text = contact.1
            cell.textLabel?.font = .systemFont(ofSize: 15, weight: .medium)
            cell.detailTextLabel?.font = .systemFont(ofSize: 14, weight: .regular)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            faqItems[indexPath.row].isExpanded.toggle()
            tableView.beginUpdates()
            tableView.reloadRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

class FAQCell: UITableViewCell {
    
    private let containerView = UIView()
    private let questionLabel = UILabel()
    private let answerLabel = UILabel()
    private let chevron = UIImageView()
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
        
        questionLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        questionLabel.textColor = .label
        questionLabel.numberOfLines = 0
        
        answerLabel.font = .systemFont(ofSize: 14, weight: .regular)
        answerLabel.textColor = .secondaryLabel
        answerLabel.numberOfLines = 0
        
        chevron.image = UIImage(systemName: "chevron.right")
        chevron.tintColor = .systemGray
        chevron.contentMode = .scaleAspectFit
        
        separatorView.backgroundColor = .systemGray5
        
        contentView.addSubview(questionLabel)
        contentView.addSubview(chevron)
        contentView.addSubview(answerLabel)
        contentView.addSubview(separatorView)
        
        questionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalTo(chevron.snp.leading).offset(-12)
        }
        
        chevron.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalTo(questionLabel)
            make.width.height.equalTo(20)
        }
        
        answerLabel.snp.makeConstraints { make in
            make.top.equalTo(questionLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        separatorView.snp.makeConstraints { make in
            make.top.equalTo(answerLabel.snp.bottom).offset(12)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    func configure(with item: FAQItem) {
        questionLabel.text = item.question
        
        if item.isExpanded {
            answerLabel.text = item.answer
            answerLabel.isHidden = false
            chevron.transform = CGAffineTransform(rotationAngle: .pi / 2)
        } else {
            answerLabel.text = ""
            answerLabel.isHidden = true
            chevron.transform = .identity
        }
    }
}
