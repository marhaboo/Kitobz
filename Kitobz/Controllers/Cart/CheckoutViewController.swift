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
    
    private let addressTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Адрес доставки"
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    private let phoneTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Номер телефона"
        tf.borderStyle = .roundedRect
        tf.keyboardType = .phonePad
        return tf
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
    }
    
    // MARK: - Layout с SnapKit
    private func setupLayout() {
        // Адрес
        view.addSubview(addressCardView)
        addressCardView.addSubview(addressTitleLabel)
        addressCardView.addSubview(nameTextField)
        addressCardView.addSubview(addressTextField)
        addressCardView.addSubview(phoneTextField)
        
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
        
        addressTextField.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(44)
        }
        
        phoneTextField.snp.makeConstraints { make in
            make.top.equalTo(addressTextField.snp.bottom).offset(12)
            make.left.right.bottom.equalToSuperview().inset(16)
            make.height.equalTo(44)
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
    
    // MARK: - Подсчёт итоговой суммы
    private func updateTotal() {
        let total = selectedItems.reduce(0) { $0 + $1.price }
        totalLabel.text = String(format: "Итог: %.2f сомони", total)
    }
    
    // MARK: - Подтвердить заказ
    @objc private func didTapConfirm() {
        let name = nameTextField.text ?? ""
        let address = addressTextField.text ?? ""
        let phone = phoneTextField.text ?? ""
        let paymentMethod = paymentSegmentedControl.selectedSegmentIndex == 0 ? "Картой" : "Наличными"
        
        print("Заказ оформлен:")
        print("Имя: \(name)")
        print("Адрес: \(address)")
        print("Телефон: \(phone)")
        print("Метод оплаты: \(paymentMethod)")
        print(totalLabel.text ?? "")
    }
}
