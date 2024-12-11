//
//  BusinessFormVC.swift
//  AdventureThirst
//
//  Created by Evgeni Novik on 06.12.2024.
//

import UIKit

class BusinessFormVC: UIViewController {
        
    private let orgNameTextField = ATTextField(placeholder: "Название организации", background: UIColor(hex: "#8abdedFF")!, border: UIColor(hex: "#1c88edFF")!)
    private let orgWorkingHoursTextField = ATTextField(placeholder: "Время работы", background: UIColor(hex: "#8abdedFF")!, border: UIColor(hex: "#1c88edFF")!)
    private let orgAdressTextField = ATTextField(placeholder: "Адрес", background: UIColor(hex: "#8abdedFF")!, border: UIColor(hex: "#1c88edFF")!)
    private let orgPhoneNumberPasswordTextField = ATTextField(placeholder: "Номер телефона", background: UIColor(hex: "#8abdedFF")!, border: UIColor(hex: "#1c88edFF")!)
    private let nextButton = UIButton()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configure()
        constraints()
    }
    
    private func configure() {
        view.addSubview(orgNameTextField)
        orgNameTextField.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(orgWorkingHoursTextField)
        orgWorkingHoursTextField.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(orgAdressTextField)
        orgAdressTextField.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(orgPhoneNumberPasswordTextField)
        orgPhoneNumberPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(nextButton)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        var signUpConfiguration = UIButton.Configuration.filled()
        signUpConfiguration.title = "Далее"
        signUpConfiguration.cornerStyle = .medium
        signUpConfiguration.baseBackgroundColor = .label
        signUpConfiguration.baseForegroundColor = .systemBackground
        signUpConfiguration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.systemFont(ofSize: 15, weight: .bold)
            return outgoing
        }
        nextButton.configuration = signUpConfiguration
        nextButton.isEnabled = false
        nextButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        
        orgNameTextField.delegate = self
        orgWorkingHoursTextField.delegate = self
        orgAdressTextField.delegate = self
        orgPhoneNumberPasswordTextField.delegate = self
    }
    
    private func constraints() {
        NSLayoutConstraint.activate([
            orgNameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            orgNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            orgNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            orgNameTextField.heightAnchor.constraint(equalToConstant: 50),
            
            orgWorkingHoursTextField.topAnchor.constraint(equalTo: orgNameTextField.bottomAnchor, constant: 20),
            orgWorkingHoursTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            orgWorkingHoursTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            orgWorkingHoursTextField.heightAnchor.constraint(equalToConstant: 50),
            
            orgAdressTextField.topAnchor.constraint(equalTo: orgWorkingHoursTextField.bottomAnchor, constant: 20),
            orgAdressTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            orgAdressTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            orgAdressTextField.heightAnchor.constraint(equalToConstant: 50),
        
            orgPhoneNumberPasswordTextField.topAnchor.constraint(equalTo: orgAdressTextField.bottomAnchor, constant: 20),
            orgPhoneNumberPasswordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            orgPhoneNumberPasswordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            orgPhoneNumberPasswordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nextButton.heightAnchor.constraint(equalToConstant: 52),
        ])
    }
    
    private func configureStateOfTheSubmitButton() {
        if (orgNameTextField.text == "" || orgWorkingHoursTextField.text == "" || orgAdressTextField.text == "" || orgPhoneNumberPasswordTextField.text == "") {
            nextButton.isEnabled = false
        } else {
            nextButton.isEnabled = true
        }
    }
    
    @objc func buttonPressed() {
        let path = BusinessFormWithPhotoVC(orgName: orgNameTextField.text ?? "", orgWorkingHours: orgWorkingHoursTextField.text ?? "", orgAdress: orgAdressTextField.text ?? "", orgPhoneNumber: orgPhoneNumberPasswordTextField.text ?? "")
        path.title = "Регистрация компании"
        navigationController?.pushViewController(path, animated: true)
    }
}

#Preview() {
    BusinessFormVC()
}



extension BusinessFormVC: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        configureStateOfTheSubmitButton()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
