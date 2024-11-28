//
//  ATTabBarController.swift
//  AdventureThirst
//
//  Created by Evgeni Novik on 08.11.2024.
//

import UIKit

class ATTabBarController: UITabBarController {
    
    var user: AppUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = .blue
        UITabBar.appearance().backgroundColor = UIColor.systemGray6
        viewControllers = [createActivitiesListNC(), createSettingsNC()]
        configureNavItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    init(user: AppUser) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configureNavItems() {
        navigationItem.hidesBackButton = true
    }
    
    private func createActivitiesListNC() -> UINavigationController {
        let cocktailsListVC = MainVC(user: user)
        cocktailsListVC.title = "Активности"
        cocktailsListVC.tabBarItem = UITabBarItem(title: "Активности", image: UIImage(systemName: "figure.surfing"), tag: 0)
        return UINavigationController(rootViewController: cocktailsListVC)
    }
    
    
    private func createSettingsNC() -> UINavigationController {
        let favoritesCocktailsVC = SettingsVC()
        favoritesCocktailsVC.title = "Настройки"
        favoritesCocktailsVC.tabBarItem = UITabBarItem(title: "Настройки", image: UIImage(systemName: "gear"), tag: 1)
        return UINavigationController(rootViewController: favoritesCocktailsVC)
    }
    
}
