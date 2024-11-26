//
//  PersonalInfoVC.swift
//  AdventureThirst
//
//  Created by Evgeni Novik on 26.11.2024.
//

import UIKit

class PersonalInfoVC: UIViewController {
    
    private let titleText = UILabel()
    private let nameTextField = ATTextField(placeholder: "Имя")
    private let lastnameTextField = ATTextField(placeholder: "Фамилия")
    private let middlenamePasswordTextField = ATTextField(placeholder: "Отчестсво (Необязательно)")
    private let signUpButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configure()
        configureConstraints()
        
        nameTextField.setColor(background: UIColor(hex: "#8abdedFF")!, border: UIColor(hex: "#1c88edFF")!)
        lastnameTextField.setColor(background: UIColor(hex: "#8abdedFF")!, border: UIColor(hex: "#1c88edFF")!)
        middlenamePasswordTextField.setColor(background: UIColor(hex: "#8abdedFF")!, border: UIColor(hex: "#1c88edFF")!)
    }
    
    private func configure() {
        view.addSubview(titleText)
        titleText.translatesAutoresizingMaskIntoConstraints = false
        titleText.text = "Регистрация"
        titleText.font = UIFont.systemFont(ofSize: 38, weight: .bold)
        
        view.addSubview(nameTextField)
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(lastnameTextField)
        lastnameTextField.translatesAutoresizingMaskIntoConstraints = false
        lastnameTextField.isSecureTextEntry = true
        
        view.addSubview(middlenamePasswordTextField)
        middlenamePasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        middlenamePasswordTextField.isSecureTextEntry = true
        
        view.addSubview(signUpButton)
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        
        var signUpConfiguration = UIButton.Configuration.filled()
        signUpConfiguration.title = "Зарегистрироваться"
        signUpConfiguration.cornerStyle = .medium
        signUpConfiguration.baseBackgroundColor = .label
        signUpConfiguration.baseForegroundColor = .systemBackground
        signUpConfiguration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.systemFont(ofSize: 15, weight: .bold)
            return outgoing
        }
        
        signUpButton.configuration = signUpConfiguration
        signUpButton.isEnabled = false
        signUpButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        
        nameTextField.delegate = self
        lastnameTextField.delegate = self
        middlenamePasswordTextField.delegate = self
    }
    
    
    private func configureStateOfTheSubmitButton() {
        if (nameTextField.text == "" || lastnameTextField.text == "" || middlenamePasswordTextField.text == "") {
            signUpButton.isEnabled = false
        } else {
            signUpButton.isEnabled = true
        }
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            titleText.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            nameTextField.topAnchor.constraint(equalTo: titleText.bottomAnchor, constant: 40),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nameTextField.heightAnchor.constraint(equalToConstant: 50),
            
            lastnameTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20),
            lastnameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            lastnameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            lastnameTextField.heightAnchor.constraint(equalToConstant: 50),
            
            middlenamePasswordTextField.topAnchor.constraint(equalTo: lastnameTextField.bottomAnchor, constant: 20),
            middlenamePasswordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            middlenamePasswordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            middlenamePasswordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            signUpButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            signUpButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            signUpButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            signUpButton.heightAnchor.constraint(equalToConstant: 52),
        ])
    }
    
    @objc func buttonPressed() {
        guard lastnameTextField.text == middlenamePasswordTextField.text else {
            return
        }
        Task {
            do {
                // TODO:
                let _ = try await AuthenticationManager.shared.registerNewUserWithEmail(email: nameTextField.text!, password: lastnameTextField.text!)
            } catch {
                print(error)
            }
        }
        self.dismiss(animated: true)
    }
}


#Preview() {
    PersonalInfoVC()
}

extension PersonalInfoVC: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        configureStateOfTheSubmitButton()
    }
}

