//
//  ViewController.swift
//  AdventureThirst
//
//  Created by Evgeni Novik on 08.11.2024.
//

import UIKit

final class SignUpOrLogInVC: UIViewController {
    private let titleText = UILabel()
    private let logInButton = UIButton()
    private let signUpButton = UIButton()
    private let logo = UIImageView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configure()
        configureNavItems()
    }
    
    private func configureNavItems() {
        navigationItem.backButtonTitle = "Назад"
        navigationItem.hidesBackButton = true
    }
    
    private func configure() {
        view.addSubview(titleText)
        view.addSubview(logo)
        logo.image = UIImage(named: "ATLogo")
        logo.translatesAutoresizingMaskIntoConstraints = false
        titleText.translatesAutoresizingMaskIntoConstraints = false
        logInButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        titleText.text = "Adventure \nThirst"
        titleText.font = UIFont.systemFont(ofSize: 44, weight: .bold)
        titleText.numberOfLines = 2
        
        view.addSubview(logInButton)
        view.addSubview(signUpButton)
        var logInConfiguration = UIButton.Configuration.filled()
        logInConfiguration.title = "Вход"
        logInConfiguration.cornerStyle = .medium
        logInConfiguration.baseBackgroundColor = .systemBlue
        logInConfiguration.baseForegroundColor = .systemBackground
        logInConfiguration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.systemFont(ofSize: 15, weight: .bold)
            return outgoing
        }
        
        var signUpConfiguration = UIButton.Configuration.filled()
        signUpConfiguration.title = "Регистрация"
        signUpConfiguration.cornerStyle = .medium
        signUpConfiguration.baseBackgroundColor = .label
        signUpConfiguration.baseForegroundColor = .systemBackground
        signUpConfiguration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.systemFont(ofSize: 15, weight: .bold)
            return outgoing
        }
        
        
        logInButton.configuration = logInConfiguration
        signUpButton.configuration = signUpConfiguration
        logInButton.addTarget(self, action: #selector(logInButtonTapped), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(SignUpButtonTapped), for: .touchUpInside)

        
        
        NSLayoutConstraint.activate([
            logo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150),
            logo.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            
            titleText.leadingAnchor.constraint(equalTo: logo.trailingAnchor, constant: 24),
            titleText.centerYAnchor.constraint(equalTo: logo.centerYAnchor),
            
            signUpButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            signUpButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            signUpButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            signUpButton.heightAnchor.constraint(equalToConstant: 52),
            
            logInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            logInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            logInButton.bottomAnchor.constraint(equalTo: signUpButton.topAnchor, constant: -8),
            logInButton.heightAnchor.constraint(equalToConstant: 52)
        ])
    }

    @objc func logInButtonTapped() {
        navigationController?.pushViewController(LogInVC(), animated: true)
    }
    
    @objc func SignUpButtonTapped() {
        navigationController?.pushViewController(SignUpVC(), animated: true)
    }

}

