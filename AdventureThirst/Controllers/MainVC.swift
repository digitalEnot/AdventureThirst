//
//  MainVC.swift
//  AdventureThirst
//
//  Created by Evgeni Novik on 08.11.2024.
//

import UIKit

class MainVC: UIViewController {
    
    var user: AppUser?

    override func viewDidLoad() {
        super.viewDidLoad()
        getUser()
        configure()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        getUser()
//    }
    
    
    private func getUser() {
        Task {
            let authUser = try? await AuthenticationManager.shared.getCurrentSession()
            guard let authUser else {
                let destVC = SignUpOrLogInVC()
                let navController = UINavigationController(rootViewController: destVC)
                navController.modalPresentationStyle = .popover
                navController.isModalInPresentation = true
                present(navController, animated: true)
                return
            }
            user = authUser
            print(user?.uid ?? "ничего не пришло")
        }
    }
    

    private func configure() {
        view.backgroundColor = .systemBackground
        print(user?.email ?? "error")
    }
}
