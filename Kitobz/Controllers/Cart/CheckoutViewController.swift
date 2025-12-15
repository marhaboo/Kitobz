//
//  CheckoutViewController.swift
//  Kitobz
//
//  Created by Ilmhona 11 on 12/9/25.
//

import UIKit
import SnapKit

class CheckoutViewController: UIViewController {
    
    // MARK: - Выбранные книги
    var selectedItems: [CartItem] = []
    
    // MARK: - Итоговая сумма из корзины
    var totalAmount: Int = 0
    
    // MARK: - Адрес
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
    
    
    // MARK: - Метод оплаты
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
    
    
    // MARK: - Итоговая сумма
    private let totalCardView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray6
        view.layer.cornerRadius = 12
        return view
    }()
    
    private let totalLabel: UILabel = {
        let label = UILabel()
        label.text = "Итог: 0 сомони"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    
    // MARK: - Подтвердить заказ
    private let confirmButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Подтвердить заказ", for: .normal)
        button.backgroundColor = UIColor(named: "AccentColor")
        button.tintColor = .white
        button.layer.cornerRadius = 10
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.addTarget(self, action: #selector(didTapConfirm), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Оформление заказа"
 
        setupLayout()
        updateTotal()
        
        phoneTextField.delegate = self
    }
    
    
    // MARK: - Layout с SnapKit
    private func setupLayout() {
        
        // Адрес
        view.addSubview(addressCardView)
        addressCardView.addSubview(addressTitleLabel)
        addressCardView.addSubview(nameTextField)
        addressCardView.addSubview(nameErrorLabel)
        addressCardView.addSubview(addressTextField)
        addressCardView.addSubview(addressErrorLabel)
        addressCardView.addSubview(phoneTextField)
        addressCardView.addSubview(phoneErrorLabel)
        
        addressCardView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
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
        
        
        // Метод оплаты
        view.addSubview(paymentCardView)
        paymentCardView.addSubview(paymentLabel)
        paymentCardView.addSubview(paymentSegmentedControl)
        
        paymentCardView.snp.makeConstraints { make in
            make.top.equalTo(addressCardView.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
        }
        
        paymentLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(16)
        }
        
        paymentSegmentedControl.snp.makeConstraints { make in
            make.top.equalTo(paymentLabel.snp.bottom).offset(12)
            make.left.right.bottom.equalToSuperview().inset(16)
            make.height.equalTo(32)
        }
        
        
        // Итоговая сумма
        view.addSubview(totalCardView)
        totalCardView.addSubview(totalLabel)
        
        totalCardView.snp.makeConstraints { make in
            make.top.equalTo(paymentCardView.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
        }
        
        totalLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
        
        
        // Подтвердить заказ
        view.addSubview(confirmButton)
        confirmButton.snp.makeConstraints { make in
            make.top.equalTo(totalCardView.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(50)
        }
    }
    
    
    // MARK: - Валидация полей (показ ошибок под полями)
    private func validateInline() -> Bool {
        let name = nameTextField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        let address = addressTextField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        let phone = phoneTextField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        
        var isValid = true
        
        // Имя
        if name.isEmpty {
            nameErrorLabel.isHidden = false
            isValid = false
        } else {
            nameErrorLabel.isHidden = true
        }
        
        // Адрес
        if address.isEmpty {
            addressErrorLabel.isHidden = false
            isValid = false
        } else {
            addressErrorLabel.isHidden = true
        }
        
        // Телефон
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
    
    
    // MARK: - Подтвердить заказ
    @objc private func didTapConfirm() {
        
        guard validateInline() else { return }
        
        let alert = UIAlertController(
            title: "Успешно",
            message: "Ваш заказ оформлен!",
            preferredStyle: .alert
        )
        
        alert.addAction(
            UIAlertAction(title: "OK", style: .default) { [weak self] _ in
                guard let self = self else { return }
                
                // Переход на Home Tab
                if let tabBarController = self.view.window?.rootViewController as? TabBarController {
                    tabBarController.selectedIndex = 0 
                }
                
                // Закрываем Checkout
                self.navigationController?.popToRootViewController(animated: false)
            }
        )

        present(alert, animated: true)
    }
    
    
    // MARK: - Подсчёт итоговой суммы
    private func updateTotal() {
        totalLabel.text = "Итог: \(totalAmount) сомони"
    }
}

extension CheckoutViewController: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard textField == phoneTextField else { return }
        
        // Если поле пустое, вставляем "+992 "
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
        
        // Нельзя удалить "+992 "
        if currentText.hasPrefix("+992 ") && range.location < 5 {
            return false
        }
        
        // Только цифры
        if !string.isEmpty &&
            !CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string)) {
            return false
        }
        
        // Максимальная длина: "+992 " + 9 цифр = 14 символов
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        if newText.count > 14 {
            return false
        }
        
        return true
    }
}
