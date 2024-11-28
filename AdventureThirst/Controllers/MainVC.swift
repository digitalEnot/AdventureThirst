//
//  MainVC.swift
//  AdventureThirst
//
//  Created by Evgeni Novik on 08.11.2024.
//

import UIKit

class MainVC: UIViewController {
    
    var user: AppUser
    
    init(user: AppUser) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func getUser() {
        Task {
            let authUser = try await AuthenticationManager.shared.getCurrentSession()
            user = authUser
            print(user.uid)
        }
    }
    

    private func configure() {
        view.backgroundColor = .systemBackground
        print(user.email)
    }
}
