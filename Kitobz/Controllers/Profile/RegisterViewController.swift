import UIKit
import SnapKit

final class RegisterViewController: UIViewController {

    var onAuthSuccess: (() -> Void)?

    private let nameField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Имя"
        tf.borderStyle = .roundedRect
        return tf
    }()

    private let emailField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.borderStyle = .roundedRect
        tf.keyboardType = .emailAddress
        tf.autocapitalizationType = .none
        return tf
    }()

    private let passwordField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Пароль"
        tf.borderStyle = .roundedRect
        tf.isSecureTextEntry = true
        return tf
    }()

    private let registerButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("Зарегистрироваться", for: .normal)
        b.titleLabel?.font = .boldSystemFont(ofSize: 17)
        b.backgroundColor = UIColor(named: "AccentColor") ?? .systemBlue
        b.tintColor = .white
        b.layer.cornerRadius = 10
        return b
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        title = "Регистрация"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(close))

        setupLayout()
        registerButton.addTarget(self, action: #selector(didTapRegister), for: .touchUpInside)
    }

    private func setupLayout() {
        let stack = UIStackView(arrangedSubviews: [nameField, emailField, passwordField, registerButton])
        stack.axis = .vertical
        stack.spacing = 12

        view.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview().offset(-40)
        }

        registerButton.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
    }

    @objc private func didTapRegister() {
        let name = nameField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let email = emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let password = passwordField.text ?? ""

        guard !name.isEmpty, !email.isEmpty, !password.isEmpty else {
            showAlert("Заполните все поля")
            return
        }

        // В реальном проекте: запрос на сервер. Здесь — мок.
        SessionManager.shared.register(name: name, email: email)

        onAuthSuccess?()
    }

    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    @objc private func close() {
        dismiss(animated: true)
    }
}
