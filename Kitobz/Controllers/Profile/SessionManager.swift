import Foundation

extension Notification.Name {
    static let sessionDidLogin = Notification.Name("sessionDidLogin")
    static let sessionDidLogout = Notification.Name("sessionDidLogout")
}

struct UserProfile: Codable {
    var name: String
    var email: String
}

final class SessionManager {
    static let shared = SessionManager()

    private let keyIsLoggedIn = "session.isLoggedIn"
    private let keyUserProfile = "session.userProfile"

    private init() {}

    var isLoggedIn: Bool {
        get { UserDefaults.standard.bool(forKey: keyIsLoggedIn) }
        set { UserDefaults.standard.set(newValue, forKey: keyIsLoggedIn) }
    }

    var currentUser: UserProfile? {
        get {
            guard let data = UserDefaults.standard.data(forKey: keyUserProfile) else { return nil }
            return try? JSONDecoder().decode(UserProfile.self, from: data)
        }
        set {
            if let value = newValue, let data = try? JSONEncoder().encode(value) {
                UserDefaults.standard.set(data, forKey: keyUserProfile)
            } else {
                UserDefaults.standard.removeObject(forKey: keyUserProfile)
            }
        }
    }

    func login(email: String, name: String? = nil) {
        let profile = UserProfile(name: name ?? "Пользователь", email: email)
        currentUser = profile
        isLoggedIn = true
        NotificationCenter.default.post(name: .sessionDidLogin, object: nil)
    }

    func register(name: String, email: String) {
        let profile = UserProfile(name: name, email: email)
        currentUser = profile
        isLoggedIn = true
        NotificationCenter.default.post(name: .sessionDidLogin, object: nil)
    }

    func logout() {
        isLoggedIn = false
        currentUser = nil
        NotificationCenter.default.post(name: .sessionDidLogout, object: nil)
    }
}
