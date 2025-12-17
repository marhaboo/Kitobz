import UIKit
import SnapKit

final class LoginViewController: UIViewController {

    var onAuthSuccess: (() -> Void)?

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

    private let loginButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("Войти", for: .normal)
        b.titleLabel?.font = .boldSystemFont(ofSize: 17)
        b.backgroundColor = UIColor(named: "AccentColor") ?? .systemBlue
        b.tintColor = .white
        b.layer.cornerRadius = 10
        return b
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        title = "Вход"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(close))

        setupLayout()
        loginButton.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
    }

    private func setupLayout() {
        let stack = UIStackView(arrangedSubviews: [emailField, passwordField, loginButton])
        stack.axis = .vertical
        stack.spacing = 12

        view.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview().offset(-40)
        }

        loginButton.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
    }

    @objc private func didTapLogin() {
        let email = emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let password = passwordField.text ?? ""

        guard !email.isEmpty, !password.isEmpty else {
            showAlert("Введите email и пароль")
            return
        }

        // В реальном проекте: запрос на сервер. Здесь — мок.
        SessionManager.shared.login(email: email)

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
