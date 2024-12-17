//
//  BusinessTabBarController.swift
//  AdventureThirst
//
//  Created by Evgeni Novik on 08.12.2024.
//

import UIKit

class BusinessTabBarController: UITabBarController {

    let company: AppCompany
    
    init(company: AppCompany) {
        self.company = company
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = .blue
        UITabBar.appearance().backgroundColor = UIColor.systemGray6
        viewControllers = [createBusinessActivitiesListNC(), createBusinessSettingsNC()]
        configureNavItems()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func configureNavItems() {
        navigationItem.hidesBackButton = true
    }
    
    private func createBusinessActivitiesListNC() -> UINavigationController {
        let businessActivitiesVC = BusinessActivitiesVC(company: company)
        businessActivitiesVC.title = "Ваши Активности"
        businessActivitiesVC.tabBarItem = UITabBarItem(title: "Ваши Активности", image: UIImage(systemName: "figure.surfing"), tag: 0)
        return UINavigationController(rootViewController: businessActivitiesVC)
    }
    
    
    private func createBusinessSettingsNC() -> UINavigationController {
        let createBusinessSettingsNC = BusinessSettigsVC(company: company)
        createBusinessSettingsNC.delegate = self
        createBusinessSettingsNC.title = "Настройки"
        createBusinessSettingsNC.tabBarItem = UITabBarItem(title: "Настройки", image: UIImage(systemName: "gear"), tag: 1)
        return UINavigationController(rootViewController: createBusinessSettingsNC)
    }

}

extension BusinessTabBarController: BusinessActivitiesDelegate {
    func popVC() {
        navigationController?.popToRootViewController(animated: true)
    }
}
