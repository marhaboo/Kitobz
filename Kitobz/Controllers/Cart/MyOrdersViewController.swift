//
//  MyOrdersViewController.swift
//  Kitobz
//
//  Created by Ilmhona 11 on 12/15/25.
//

import UIKit
import SnapKit

class MyOrdersViewController: UIViewController {
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(OrderCell.self, forCellReuseIdentifier: OrderCell.id)
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
        label.text = "📦"
        label.font = .systemFont(ofSize: 60)
        label.textAlignment = .center
        return label
    }()
    
    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "У вас пока нет заказов\n\nОформите первый заказ и он появится здесь"
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private var orders: [Order] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "Background")
        title = "Мои заказы"
        
        setupLayout()
        setupEmptyStateView()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(ordersDidChange),
            name: .ordersDidChange,
            object: nil
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadOrders()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupLayout() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
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
    
    @objc private func ordersDidChange() {
        loadOrders()
    }

    private func loadOrders() {
        orders = OrdersManager.shared.orders.reversed() // Show newest first
        tableView.reloadData()
        updateEmptyState()
    }
    
    private func updateEmptyState() {
        let isEmpty = orders.isEmpty
        emptyStateView.isHidden = !isEmpty
        tableView.isHidden = isEmpty
    }
}

extension MyOrdersViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OrderCell.id, for: indexPath) as! OrderCell
        let order = orders[indexPath.row]
        cell.configure(with: order)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let order = orders[indexPath.row]
        let detailVC = OrderDetailViewController(order: order)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: - OrderCell

class OrderCell: UITableViewCell {
    static let id = "OrderCell"
    
    private let cardView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(named: "cardBg") ?? .secondarySystemBackground
        v.layer.cornerRadius = 16
        v.layer.masksToBounds = false
        v.layer.shadowColor = UIColor.black.cgColor
        v.layer.shadowOpacity = 0.05
        v.layer.shadowRadius = 8
        v.layer.shadowOffset = CGSize(width: 0, height: 2)
        return v
    }()
    
    private let orderNumberLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 17, weight: .semibold)
        l.textColor = .label
        return l
    }()
    
    private let dateLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 13, weight: .regular)
        l.textColor = .secondaryLabel
        return l
    }()
    
    private let statusBadge: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 12, weight: .semibold)
        l.textColor = .white
        l.textAlignment = .center
        l.backgroundColor = UIColor(named: "AccentColor") ?? .systemBlue
        l.layer.cornerRadius = 8
        l.layer.masksToBounds = true
        l.text = "В обработке"
        return l
    }()
    
    private let itemsLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 14, weight: .regular)
        l.textColor = .label
        l.numberOfLines = 2
        return l
    }()
    
    private let totalLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 16, weight: .bold)
        l.textColor = UIColor(named: "TextColor") ?? .label
        return l
    }()
    
    private let chevronImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "chevron.right"))
        iv.tintColor = .secondaryLabel
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        contentView.addSubview(cardView)
        
        cardView.addSubview(orderNumberLabel)
        cardView.addSubview(dateLabel)
        cardView.addSubview(statusBadge)
        cardView.addSubview(itemsLabel)
        cardView.addSubview(totalLabel)
        cardView.addSubview(chevronImageView)
        
        cardView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 6, left: 16, bottom: 6, right: 16))
        }
        
        orderNumberLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(16)
        }
        
        statusBadge.snp.makeConstraints { make in
            make.centerY.equalTo(orderNumberLabel)
            make.trailing.equalToSuperview().inset(16)
            make.height.equalTo(24)
            make.width.greaterThanOrEqualTo(80)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(orderNumberLabel.snp.bottom).offset(4)
            make.leading.equalTo(orderNumberLabel)
        }
        
        itemsLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(12)
            make.leading.equalTo(orderNumberLabel)
            make.trailing.equalToSuperview().inset(16)
        }
        
        totalLabel.snp.makeConstraints { make in
            make.top.equalTo(itemsLabel.snp.bottom).offset(12)
            make.leading.equalTo(orderNumberLabel)
            make.bottom.equalToSuperview().inset(16)
        }
        
        chevronImageView.snp.makeConstraints { make in
            make.centerY.equalTo(totalLabel)
            make.trailing.equalToSuperview().inset(16)
            make.width.height.equalTo(14)
        }
    }
    
    func configure(with order: Order) {
        // Order number (using date as ID)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        let orderID = dateFormatter.string(from: order.date).suffix(8)
        orderNumberLabel.text = "Заказ #\(orderID)"
        
        // Date
        dateFormatter.dateFormat = "dd.MM.yyyy в HH:mm"
        dateLabel.text = dateFormatter.string(from: order.date)
        
        // Items
        let itemsCount = order.items.count
        let itemsText = order.items.prefix(2).map { $0.title }.joined(separator: ", ")
        if itemsCount > 2 {
            itemsLabel.text = "\(itemsText) и ещё \(itemsCount - 2)..."
        } else {
            itemsLabel.text = itemsText
        }
        
        // Total
        totalLabel.text = "\(order.totalAmount) сомони"
    }
}

// MARK: - OrderDetailViewController

class OrderDetailViewController: UIViewController {
    
    private let order: Order
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let orderInfoCard: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(named: "cardBg") ?? .secondarySystemBackground
        v.layer.cornerRadius = 16
        return v
    }()
    
    private lazy var itemsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.isScrollEnabled = false
        cv.dataSource = self
        cv.delegate = self
        cv.register(BookListCell.self, forCellWithReuseIdentifier: BookListCell.id)
        return cv
    }()
    
    init(order: Order) {
        self.order = order
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "Background")
        title = "Детали заказа"
        setupLayout()
    }
    
    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        // Order info card
        contentView.addSubview(orderInfoCard)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        let orderID = dateFormatter.string(from: order.date).suffix(8)
        
        let orderNumberLabel = UILabel()
        orderNumberLabel.text = "Заказ #\(orderID)"
        orderNumberLabel.font = .systemFont(ofSize: 20, weight: .bold)
        
        dateFormatter.dateFormat = "dd MMMM yyyy 'в' HH:mm"
        dateFormatter.locale = Locale(identifier: "ru_RU")
        let dateLabel = UILabel()
        dateLabel.text = dateFormatter.string(from: order.date)
        dateLabel.font = .systemFont(ofSize: 14, weight: .regular)
        dateLabel.textColor = .secondaryLabel
        
        let statusBadge = UILabel()
        statusBadge.text = "В обработке"
        statusBadge.font = .systemFont(ofSize: 13, weight: .semibold)
        statusBadge.textColor = .white
        statusBadge.backgroundColor = UIColor(named: "AccentColor") ?? .systemBlue
        statusBadge.textAlignment = .center
        statusBadge.layer.cornerRadius = 8
        statusBadge.layer.masksToBounds = true
        
        let totalLabel = UILabel()
        totalLabel.text = "Итого: \(order.totalAmount) сомони"
        totalLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        
        orderInfoCard.addSubview(orderNumberLabel)
        orderInfoCard.addSubview(dateLabel)
        orderInfoCard.addSubview(statusBadge)
        orderInfoCard.addSubview(totalLabel)
        
        orderInfoCard.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        orderNumberLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(16)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(orderNumberLabel.snp.bottom).offset(4)
            make.leading.equalTo(orderNumberLabel)
        }
        
        statusBadge.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().inset(16)
            make.height.equalTo(28)
            make.width.greaterThanOrEqualTo(100)
        }
        
        totalLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(16)
            make.leading.equalTo(orderNumberLabel)
            make.bottom.equalToSuperview().inset(16)
        }
        
        // Items title
        let itemsTitleLabel = UILabel()
        itemsTitleLabel.text = "Товары"
        itemsTitleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        
        contentView.addSubview(itemsTitleLabel)
        contentView.addSubview(itemsCollectionView)
        
        itemsTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(orderInfoCard.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        let rows = order.items.count
        let rowHeight: CGFloat = 120
        let verticalSpacing: CGFloat = 16
        let sectionInsets: CGFloat = 12 + 12
        let estimatedHeight = CGFloat(rows) * rowHeight + CGFloat(max(rows - 1, 0)) * verticalSpacing + sectionInsets
        
        itemsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(itemsTitleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(estimatedHeight).priority(.high)
            make.bottom.equalToSuperview().inset(24)
        }
    }
}

extension OrderDetailViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return order.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookListCell.id, for: indexPath) as! BookListCell
        let book = order.items[indexPath.item]
        cell.configure(with: book)
        cell.onFavoriteToggle = { isFav in
            FavoritesManager.shared.setFavorite(bookID: book.id, isFavorite: isFav)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        let insets = layout?.sectionInset ?? .zero
        let width = collectionView.bounds.width - insets.left - insets.right
        return CGSize(width: width, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let book = order.items[indexPath.item]
        let reviewsForBook = ReviewsProvider.loadReviews(for: BooksProvider.baseBooks()).filter { $0.bookId == book.id }
        let detail = BookDetailViewController(book: book, reviews: reviewsForBook)
        navigationController?.pushViewController(detail, animated: true)
    }
}
