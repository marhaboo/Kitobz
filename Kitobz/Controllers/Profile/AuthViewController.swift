import UIKit
import SnapKit

final class AuthViewController: UIViewController {

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.text = "Добро пожаловать в Kitobz"
        l.font = .systemFont(ofSize: 22, weight: .bold)
        l.textAlignment = .center
        l.numberOfLines = 0
        return l
    }()

    private let subtitleLabel: UILabel = {
        let l = UILabel()
        l.text = "Войдите в аккаунт или зарегистрируйтесь"
        l.font = .systemFont(ofSize: 15, weight: .regular)
        l.textAlignment = .center
        l.textColor = .secondaryLabel
        l.numberOfLines = 0
        return l
    }()

    private let loginButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("Войти", for: .normal)
        b.titleLabel?.font = .boldSystemFont(ofSize: 18)
        b.backgroundColor = UIColor(named: "AccentColor") ?? .systemBlue
        b.tintColor = .white
        b.layer.cornerRadius = 12
        return b
    }()

    private let registerButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("Зарегистрироваться", for: .normal)
        b.titleLabel?.font = .boldSystemFont(ofSize: 18)
        b.backgroundColor = .systemGray5
        b.tintColor = .label
        b.layer.cornerRadius = 12
        return b
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "Background") ?? .systemBackground
        setupLayout()
        loginButton.addTarget(self, action: #selector(openLogin), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(openRegister), for: .touchUpInside)
    }

    private func setupLayout() {
        let container = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel, UIView(), loginButton, registerButton])
        container.axis = .vertical
        container.alignment = .fill
        container.spacing = 16

        view.addSubview(container)
        container.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.centerY.equalToSuperview()
        }

        loginButton.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        registerButton.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
    }

    @objc private func openLogin() {
        let vc = LoginViewController()
        vc.onAuthSuccess = { [weak self] in
            self?.dismiss(animated: true)
        }
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .formSheet
        present(nav, animated: true)
    }

    @objc private func openRegister() {
        let vc = RegisterViewController()
        vc.onAuthSuccess = { [weak self] in
            self?.dismiss(animated: true)
        }
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .formSheet
        present(nav, animated: true)
    }
}
