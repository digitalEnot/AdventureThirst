//
//  DefVCViewController.swift
//  AdventureThirst
//
//  Created by Evgeni Novik on 08.11.2024.
//

import UIKit

class LogInVC: UIViewController {
    
    private let titleText = UILabel()
    private let emailTextField = ATTextField(placeholder: "Email")
    private let passwordTextField = ATTextField(placeholder: "Пароль")
    private let signUpButton = UIButton()
    
    private let isModal: Bool
    
    weak var delegate: SettingsInfoDelegate?
    
    init(isModal: Bool) {
        self.isModal = isModal
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configure()
        configureConstraints()
        passwordTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
    }
    
    
    private func configure() {
        view.addSubview(titleText)
        titleText.translatesAutoresizingMaskIntoConstraints = false
        titleText.text = "Вход"
        titleText.font = UIFont.systemFont(ofSize: 38, weight: .bold)
        
        view.addSubview(emailTextField)
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(passwordTextField)
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.isSecureTextEntry = true
        
        view.addSubview(signUpButton)
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        
        var signUpConfiguration = UIButton.Configuration.filled()
        signUpConfiguration.title = "Войти"
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
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    private func configureStateOfTheSubmitButton() {
        if (emailTextField.text == "" || passwordTextField.text == "") {
            signUpButton.isEnabled = false
        } else {
            signUpButton.isEnabled = true
        }
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            titleText.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            emailTextField.topAnchor.constraint(equalTo: titleText.bottomAnchor, constant: 40),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            signUpButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            signUpButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            signUpButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            signUpButton.heightAnchor.constraint(equalToConstant: 52),
        ])
    }
    
//    @objc func buttonPressed() {
//        Task {
//            do {
//                let user = try await AuthenticationManager.shared.signInWithEmail(email: emailTextField.text!, password: passwordTextField.text!)
//                let userPhoto = try await StorageManager.shared.fetchProfilePhoto(for: user)
//                let userPersonalInfo = try await DatabaseManager.shared.fetchToDoItems(for: user.uid)
//                let userData =  UserData(uid: userPersonalInfo[0].userUid, email: user.email ?? "", name: userPersonalInfo[0].name, lastName: userPersonalInfo[0].lastName, middleName: userPersonalInfo[0].middleName, photoData: userPhoto)
////                getCompanies(for: user, userData: userData)
//                let companies = try await DatabaseManager.shared.fetchCompany(for: user.uid)
//                if isModal {
//                    async delegate?.didLogInToTheSystem(userData: userData, companies: getCompanies(companies: companies))
//                    self.dismiss(animated: true)
//                } else {
//                    await navigationController?.pushViewController(ATTabBarController(userData: userData, appCompanies: getCompanies(companies: companies)), animated: true)
//                }
//            } catch {
//                print(error)
//            }
//        }
//    }
    
    @objc func buttonPressed() {
        Task {
            do {
                let user = try await AuthenticationManager.shared.signInWithEmail(email: emailTextField.text!, password: passwordTextField.text!)
                let userPhoto = try await StorageManager.shared.fetchProfilePhoto(for: user)
                let userPersonalInfo = try await DatabaseManager.shared.fetchToDoItems(for: user.uid)
                let userData = UserData(
                    uid: userPersonalInfo[0].userUid,
                    email: user.email ?? "",
                    name: userPersonalInfo[0].name,
                    lastName: userPersonalInfo[0].lastName,
                    middleName: userPersonalInfo[0].middleName,
                    photoData: userPhoto,
                    likedActivities: userPersonalInfo[0].likedActivities,
                    bookedActivities: userPersonalInfo[0].bookedActivities
                )
                
                let companies = try await DatabaseManager.shared.fetchCompany(for: user.uid)
                let appCompanies = await getCompanies(companies: companies) // Await here
                
                if isModal {
                    // Ensure all data is fetched before calling delegate
                    delegate?.didLogInToTheSystem(userData: userData, companies: appCompanies)
                    self.dismiss(animated: true)
                } else {
                    navigationController?.pushViewController(ATTabBarController(userData: userData, appCompanies: appCompanies), animated: true)
                }
            } catch {
                print("Error: \(error)")
            }
        }
    }

    
    func getCompanies(companies: [Company]) async -> [AppCompany] {
        var appCompanies: [AppCompany] = []
        
        for company in companies {
            do {
                let photoData = try await StorageManager.shared.fetchCompanyPhoto(for: company.phoneNumber)
                let appCompany = AppCompany(
                    name: company.name,
                    description: company.description,
                    photo: photoData,
                    address: company.address,
                    activities: company.activities,
                    phoneNumber: company.phoneNumber,
                    openHours: company.openHours,
                    userUid: company.userUid,
                    bookedActivities: company.bookedActivities
                )
                appCompanies.append(appCompany)
            } catch {
                print("Failed to fetch photo for company: \(company.name), error: \(error)")
            }
        }
        return appCompanies
    }
    
//    func getCompanies(companies: [Company]) -> [AppCompany] {
//        var appCompanies: [AppCompany] = []
//        companies.forEach { company in
//            Task {
//                do {
//                    let photoData = try await StorageManager.shared.fetchCompanyPhoto(for: company.phoneNumber)
//                    print("photoData: \(photoData)")
//                    let appCompany = AppCompany(name: company.name, description: company.description, photo: photoData, address: company.address, activities: company.activities, phoneNumber: company.phoneNumber, openHours: company.openHours, userUid: company.userUid)
//                    appCompanies.append(appCompany)
//                } catch {
//                    
//                }
//            }
//        }
//        return appCompanies
//    }
}

extension LogInVC: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        configureStateOfTheSubmitButton()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

#Preview() {
    LogInVC(isModal: false)
}


