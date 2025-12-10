//
//  TabBarController.swift
//  Kitobz
//
//  Created by Boynurodova Marhabo on 01/12/25.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTabBarItem()
        setupTabs()
    }
    
    private func configureTabBarItem() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        
        appearance.backgroundColor = UIColor.systemBackground
        appearance.shadowColor = UIColor.lightGray.withAlphaComponent(0.3)
   
        
        let accent = UIColor(named: "AccentColor") ?? .systemRed
        
        let stacked = appearance.stackedLayoutAppearance
        stacked.normal.iconColor = .gray
        stacked.normal.titleTextAttributes = [.foregroundColor: UIColor.gray, .font: UIFont.systemFont(ofSize: 10)]
        stacked.selected.iconColor = accent
        stacked.selected.titleTextAttributes = [.foregroundColor: accent, .font: UIFont.systemFont(ofSize: 10)]
        
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        
        tabBar.tintColor = accent
    }
    
    private func setupTabs() {
        let homeVC = createNavigationController(
            with: "Главное",
            and: UIImage(systemName: "book.fill"),
            vc: HomeViewController()
        )
        
        let searchVC = createNavigationController(
            with: "Поиск",
            and: UIImage(systemName: "magnifyingglass"),
            vc: SearchViewController()
        )
        
        let cartVC = createNavigationController(
            with: "Корзина",
            and: UIImage(systemName: "cart.fill"),
            vc: CartViewController()
        )
        let favVC = createNavigationController(
            with: "Избранные",
            and: UIImage(systemName: "bookmark.fill"),
<<<<<<< HEAD
            vc: FavoritesViewController()
=======
            vc: CartViewController()
>>>>>>> madina-favorites
        )
        
        let profileVC = createNavigationController(
            with: "Профиль",
            and: UIImage(systemName: "person.fill"),
            vc: ProfileViewController()
        )
        
        viewControllers = [homeVC, searchVC, cartVC, favVC, profileVC]
    }
    
    private func createNavigationController(
        with title: String,
        and image: UIImage?,
        vc: UIViewController
    ) -> UINavigationController {
        let nc = UINavigationController(rootViewController: vc)
        nc.tabBarItem.title = title
        nc.tabBarItem.image = image?.withConfiguration(
            UIImage.SymbolConfiguration(pointSize: 16, weight: .regular)
        )
        return nc
    }

}
