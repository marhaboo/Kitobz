import UIKit
import SnapKit

final class RegisterViewController: UIViewController {

    var onAuthSuccess: (() -> Void)?

    private let nameField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Имя"
        tf.borderStyle = .roundedRect
        tf.autocapitalizationType = .words
        return tf
    }()

    private let emailField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.borderStyle = .roundedRect
        tf.keyboardType = .emailAddress
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        return tf
    }()

    private let passwordField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Пароль"
        tf.borderStyle = .roundedRect
        tf.isSecureTextEntry = true
        tf.textContentType = .newPassword
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

    private let activity: UIActivityIndicatorView = {
        let a = UIActivityIndicatorView(style: .medium)
        a.hidesWhenStopped = true
        return a
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
        let buttonContainer = UIView()
        buttonContainer.addSubview(registerButton)
        buttonContainer.addSubview(activity)

        registerButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(48)
        }
        activity.snp.makeConstraints { make in
            make.center.equalTo(registerButton)
        }

        let stack = UIStackView(arrangedSubviews: [nameField, emailField, passwordField, buttonContainer])
        stack.axis = .vertical
        stack.spacing = 12

        view.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview().offset(-40)
        }
    }

    @objc private func didTapRegister() {
        let name = (nameField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let email = (emailField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordField.text ?? ""

        // Валидация
        guard !name.isEmpty else { return showAlert("Введите имя") }
        guard isValidEmail(email) else { return showAlert("Введите корректный email") }
        guard password.count >= 6 else { return showAlert("Пароль должен быть не короче 6 символов") }

        setLoading(true)

        // Мок “запроса” на сервер. Замените на реальный вызов API.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
            guard let self = self else { return }

            // Успех: сохраняем сессию
            SessionManager.shared.register(name: name, email: email)

            self.setLoading(false)

            // Переключаемся на вкладку Профиль (обычно последний индекс)
            if let tab = self.presentingOrRootTabBarController() {
                // Найдём индекс вкладки с ProfileViewController
                if let index = tab.viewControllers?.firstIndex(where: { nav in
                    if let nav = nav as? UINavigationController {
                        return nav.viewControllers.first is ProfileViewController
                    }
                    return false
                }) {
                    tab.selectedIndex = index
                }
            }

            // Закрываем все модальные контроллеры, связанные с авторизацией
            self.dismissToRootMostPresented {
                // Дополнительно вызовем onAuthSuccess, если кто-то подписан
                self.onAuthSuccess?()
            }
        }
    }

    // MARK: - Helpers

    // Ищем ближайший TabBarController (или корневой)
    private func presentingOrRootTabBarController() -> UITabBarController? {
        // 1) Если текущий презентер — UINavigationController внутри модалки, берём его presenter цепочку
        var root = self.view.window?.rootViewController

        // Если window пока не доступен, попробуем от текущего
        if root == nil {
            root = UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .first { $0.isKeyWindow }?.rootViewController
        }

        // Разворачиваем контейнеры
        while let presented = root?.presentedViewController {
            root = presented
        }

        // Поднимемся к корню
        var candidate = self.presentingViewController ?? self.parent ?? self
        while let parent = candidate.parent {
            candidate = parent
        }

        // Проверяем разные варианты
        if let tab = candidate as? UITabBarController {
            return tab
        }
        if let tab = (candidate as? UINavigationController)?.viewControllers.first as? UITabBarController {
            return tab
        }

        // Попробуем от корневого окна
        if let tab = (self.view.window?.rootViewController as? UITabBarController) {
            return tab
        }
        if let nav = self.view.window?.rootViewController as? UINavigationController,
           let tab = nav.viewControllers.first as? UITabBarController {
            return tab
        }

        return nil
    }

    // Закрываем всю модальную цепочку до корня
    private func dismissToRootMostPresented(completion: (() -> Void)? = nil) {
        // Если нас показали внутри UINavigationController, dismiss надо вызывать у верхнего презентующего
        // Находим самого верхнего презентера и закрываем всё
        guard let root = view.window?.rootViewController else {
            // fallback: обычный dismiss
            dismiss(animated: true, completion: completion)
            return
        }
        var top = root
        while let presented = top.presentedViewController {
            top = presented
        }
        top.dismiss(animated: true, completion: completion)
    }

    private func setLoading(_ loading: Bool) {
        registerButton.isEnabled = !loading
        registerButton.alpha = loading ? 0.6 : 1.0
        if loading {
            activity.startAnimating()
        } else {
            activity.stopAnimating()
        }
    }

    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    private func isValidEmail(_ email: String) -> Bool {
        let pattern = #"^\S+@\S+\.\S+$"#
        return email.range(of: pattern, options: .regularExpression) != nil
    }

    @objc private func close() {
        dismiss(animated: true)
    }
}
