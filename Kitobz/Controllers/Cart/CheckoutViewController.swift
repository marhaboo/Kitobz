//
//  CheckoutViewController.swift
//  Kitobz
//
//  Created by Ilmhona 11 on 12/9/25.
//

import UIKit
import SnapKit

class CheckoutViewController: UIViewController {
    
    var selectedItems: [Book] = []
    var totalAmount: Int = 0
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let addressCardView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray6
        view.layer.cornerRadius = 12
        return view
    }()
    
    private let addressTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Адрес"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    private let nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Имя получателя"
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    private let nameErrorLabel: UILabel = {
        let label = UILabel()
        label.text = "Введите имя"
        label.textColor = .red
        label.font = .systemFont(ofSize: 12)
        label.isHidden = true
        return label
    }()
    
    private let addressTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Адрес доставки"
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    private let addressErrorLabel: UILabel = {
        let label = UILabel()
        label.text = "Введите адрес"
        label.textColor = .red
        label.font = .systemFont(ofSize: 12)
        label.isHidden = true
        return label
    }()
    
    private let phoneTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Номер телефона"
        tf.borderStyle = .roundedRect
        tf.keyboardType = .phonePad
        return tf
    }()
    
    private let phoneErrorLabel: UILabel = {
        let label = UILabel()
        label.text = "Введите номер телефона"
        label.textColor = .red
        label.font = .systemFont(ofSize: 12)
        label.isHidden = true
        return label
    }()
    
    private let selectedTitleLabel: UILabel = {
        let l = UILabel()
        l.text = "Вы выбрали"
        l.font = .boldSystemFont(ofSize: 16)
        return l
    }()
    
    private lazy var selectedCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.isScrollEnabled = false
        cv.dataSource = self
        cv.delegate = self
        cv.register(BookListCell.self, forCellWithReuseIdentifier: BookListCell.id)
        return cv
    }()
    
    private let paymentCardView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray6
        view.layer.cornerRadius = 12
        return view
    }()
    
    private let paymentLabel: UILabel = {
        let label = UILabel()
        label.text = "Метод оплаты"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    private let paymentSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Картой", "Наличными"])
        sc.selectedSegmentIndex = 0
        return sc
    }()
    
    private let confirmButtonContainer: UIView = {
        let v = UIView()
        v.backgroundColor = .clear
        v.layer.shadowColor = UIColor.black.cgColor
        v.layer.shadowOpacity = 0.1
        v.layer.shadowOffset = CGSize(width: 0, height: -2)
        v.layer.shadowRadius = 8
        return v
    }()
    
    private let confirmButton: UIButton = {
        let b = UIButton(type: .system)
        b.backgroundColor = UIColor(named: "AccentColor") ?? .systemBlue
        b.layer.cornerRadius = 16
        b.titleLabel?.numberOfLines = 0
        b.titleLabel?.textAlignment = .center
        b.addTarget(self, action: #selector(didTapConfirm), for: .touchUpInside)
        return b
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "Background")
        title = "Оформление заказа"
 
        setupLayout()
        updateConfirmButton()
        
        phoneTextField.delegate = self
    }
    
    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 90, right: 0)
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        contentView.addSubview(addressCardView)
        addressCardView.addSubview(addressTitleLabel)
        addressCardView.addSubview(nameTextField)
        addressCardView.addSubview(nameErrorLabel)
        addressCardView.addSubview(addressTextField)
        addressCardView.addSubview(addressErrorLabel)
        addressCardView.addSubview(phoneTextField)
        addressCardView.addSubview(phoneErrorLabel)
        
        addressCardView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.right.equalToSuperview().inset(16)
        }
        
        addressTitleLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(16)
        }
        
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(addressTitleLabel.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(44)
        }
        
        nameErrorLabel.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(4)
            make.left.right.equalToSuperview().inset(16)
        }
        
        addressTextField.snp.makeConstraints { make in
            make.top.equalTo(nameErrorLabel.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(44)
        }
        
        addressErrorLabel.snp.makeConstraints { make in
            make.top.equalTo(addressTextField.snp.bottom).offset(4)
            make.left.right.equalToSuperview().inset(16)
        }
        
        phoneTextField.snp.makeConstraints { make in
            make.top.equalTo(addressErrorLabel.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(44)
        }
        
        phoneErrorLabel.snp.makeConstraints { make in
            make.top.equalTo(phoneTextField.snp.bottom).offset(4)
            make.left.right.bottom.equalToSuperview().inset(16)
        }
        
        contentView.addSubview(selectedTitleLabel)
        contentView.addSubview(selectedCollectionView)
        
        selectedTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(addressCardView.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
        }
        
        let rows = selectedItems.count
        let rowHeight: CGFloat = 120
        let verticalSpacing: CGFloat = 20
        let sectionInsets: CGFloat = 12 + 12
        let estimatedHeight = CGFloat(rows) * rowHeight + CGFloat(max(rows - 1, 0)) * verticalSpacing + sectionInsets
        
        selectedCollectionView.snp.makeConstraints { make in
            make.top.equalTo(selectedTitleLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview()
            make.height.equalTo(estimatedHeight).priority(.high)
        }
        
        contentView.addSubview(paymentCardView)
        paymentCardView.addSubview(paymentLabel)
        paymentCardView.addSubview(paymentSegmentedControl)
        
        paymentCardView.snp.makeConstraints { make in
            make.top.equalTo(selectedCollectionView.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(24)
        }
        
        paymentLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(16)
        }
        
        paymentSegmentedControl.snp.makeConstraints { make in
            make.top.equalTo(paymentLabel.snp.bottom).offset(12)
            make.left.right.bottom.equalToSuperview().inset(16)
            make.height.equalTo(32)
        }
        
        view.addSubview(confirmButtonContainer)
        confirmButtonContainer.addSubview(confirmButton)
        
        confirmButtonContainer.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(12)
            make.height.equalTo(64)
        }
    }
    
    private func validateInline() -> Bool {
        let name = nameTextField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        let address = addressTextField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        let phone = phoneTextField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        
        var isValid = true
        
        if name.isEmpty {
            nameErrorLabel.isHidden = false
            isValid = false
        } else {
            nameErrorLabel.isHidden = true
        }
        
        if address.isEmpty {
            addressErrorLabel.isHidden = false
            isValid = false
        } else {
            addressErrorLabel.isHidden = true
        }
        
        if phone.isEmpty || phone == "+992 " {
            phoneErrorLabel.text = "Введите номер телефона"
            phoneErrorLabel.isHidden = false
            isValid = false
        } else if phone.count < 14 {
            phoneErrorLabel.text = "Введите номер полностью"
            phoneErrorLabel.isHidden = false
            isValid = false
        } else {
            phoneErrorLabel.isHidden = true
        }
        
        return isValid
    }
    
    @objc private func didTapConfirm() {
        guard validateInline() else { return }
        
        UIView.animate(withDuration: 0.1, animations: {
            self.confirmButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.confirmButton.transform = .identity
            }
        }
        
        let order = Order(items: selectedItems, totalAmount: totalAmount, date: Date())
        OrdersManager.shared.addOrder(order)
        
        let alert = UIAlertController(
            title: "Успешно",
            message: "Ваш заказ оформлен!",
            preferredStyle: .alert
        )
        
        alert.addAction(
            UIAlertAction(title: "OK", style: .default) { [weak self] _ in
                guard let self = self else { return }
                
                if let tabBarController = self.view.window?.rootViewController as? TabBarController {
                    tabBarController.selectedIndex = 0
                }
                
                self.navigationController?.popToRootViewController(animated: false)
            }
        )

        present(alert, animated: true)
    }
    
    private func updateConfirmButton() {
        let buttonTitle = "Подтвердить заказ\nИтог: \(totalAmount) сомони"
        let attributedString = NSMutableAttributedString(string: buttonTitle)
        let fullRange = NSRange(location: 0, length: attributedString.length)
        
        let titleRange = (buttonTitle as NSString).range(of: "Подтвердить заказ")
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 17, weight: .semibold), range: titleRange)
        attributedString.addAttribute(.foregroundColor, value: UIColor.white, range: titleRange)
        
        let totalRange = (buttonTitle as NSString).range(of: "Итог: \(totalAmount) сомони")
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 16, weight: .regular), range: totalRange)
        attributedString.addAttribute(.foregroundColor, value: UIColor.white.withAlphaComponent(0.9), range: totalRange)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineSpacing = 2
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: fullRange)
        
        confirmButton.setAttributedTitle(attributedString, for: .normal)
    }
}

extension CheckoutViewController: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard textField == phoneTextField else { return }
        
        if textField.text?.isEmpty == true {
            textField.text = "+992 "
        }
    }

    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        
        guard textField == phoneTextField else { return true }
        let currentText = textField.text ?? ""
        
        if currentText.hasPrefix("+992 ") && range.location < 5 {
            return false
        }
        
        if !string.isEmpty &&
            !CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string)) {
            return false
        }
        
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        if newText.count > 14 {
            return false
        }
        
        return true
    }
}

extension CheckoutViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        selectedItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookListCell.id, for: indexPath) as! BookListCell
        cell.configure(with: selectedItems[indexPath.item])
        cell.onFavoriteToggle = { isFav in
            let book = self.selectedItems[indexPath.item]
            FavoritesManager.shared.setFavorite(bookID: book.id, isFavorite: isFav)
        }
        return cell
    }
    
    private func rowSize(for width: CGFloat) -> CGSize {
        let layout = selectedCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
        let insets = layout?.sectionInset ?? .zero
        let cellWidth = width - insets.left - insets.right
        let height: CGFloat = 120
        return CGSize(width: cellWidth, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        rowSize(for: collectionView.bounds.width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selected = selectedItems[indexPath.item]
        let reviewsForBook = ReviewsProvider.loadReviews(for: BooksProvider.baseBooks()).filter { $0.bookId == selected.id }
        let detail = BookDetailViewController(book: selected, reviews: reviewsForBook)
        navigationController?.pushViewController(detail, animated: true)
    }
}
