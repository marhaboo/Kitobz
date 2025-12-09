import UIKit

protocol FavoriteCellDelegate: AnyObject {
    func favoriteCellDidTapCart(_ cell: FavoriteCell)
}

final class FavoriteCell: UITableViewCell {

    static let reuseId = "FavoriteCell"

    weak var delegate: FavoriteCellDelegate?

    private let coverImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 8
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 16, weight: .semibold)
        l.numberOfLines = 2
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let authorLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 13)
        l.textColor = .secondaryLabel
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let priceLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 15, weight: .medium)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private lazy var cartButton: UIButton = {
        let b = UIButton(type: .system)
        b.tintColor = .systemRed // красная корзина
        b.translatesAutoresizingMaskIntoConstraints = false
        b.addTarget(self, action: #selector(cartTapped), for: .touchUpInside)
        return b
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        selectionStyle = .none
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        contentView.addSubview(coverImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(authorLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(cartButton)

        NSLayoutConstraint.activate([
            coverImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            coverImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            coverImageView.widthAnchor.constraint(equalToConstant: 56),
            coverImageView.heightAnchor.constraint(equalToConstant: 80),

            cartButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cartButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            cartButton.widthAnchor.constraint(equalToConstant: 34),
            cartButton.heightAnchor.constraint(equalToConstant: 34),

            titleLabel.leadingAnchor.constraint(equalTo: coverImageView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: cartButton.leadingAnchor, constant: -12),
            titleLabel.topAnchor.constraint(equalTo: coverImageView.topAnchor),

            authorLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),

            priceLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            priceLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 8),
        ])
    }

    func configure(with book: Book) {
        titleLabel.text = book.title
        authorLabel.text = book.author
        priceLabel.text = "\(book.price) сомони"

        if let imageName = book.imageName {
            coverImageView.image = UIImage(named: imageName)
        } else {
            coverImageView.image = UIImage(systemName: "book")
        }

        let cartConfig = UIImage.SymbolConfiguration(pointSize: 16, weight: .regular)
        cartButton.setImage(UIImage(systemName: "cart", withConfiguration: cartConfig), for: .normal)
    }

    @objc private func cartTapped() {
        UIView.animate(withDuration: 0.1, animations: {
            self.cartButton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.cartButton.transform = .identity
            }
        }

        delegate?.favoriteCellDidTapCart(self)
    }
}
