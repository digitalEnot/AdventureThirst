//
//  PersonalInfoVC.swift
//  AdventureThirst
//
//  Created by Evgeni Novik on 26.11.2024.
//

import UIKit

class PersonalInfoVC: UIViewController {
    
    let spinner = SpinnerViewController()
    let viewForSpinner = UIView()
    let appUser: AppUser
    
    private let photoView = UIImageView()
    private let imagePicker = ImagePicker()
    private let imagePickerButton = UIButton(type: .system)
    
    private let titleText = UILabel()
    private let nameTextField = ATTextField(placeholder: "Имя", background: UIColor(hex: "#8abdedFF")!, border: UIColor(hex: "#1c88edFF")!)
    private let lastnameTextField = ATTextField(placeholder: "Фамилия", background: UIColor(hex: "#8abdedFF")!, border: UIColor(hex: "#1c88edFF")!)
    private let middlenamePasswordTextField = ATTextField(placeholder: "Отчестсво (Необязательно)", background: UIColor(hex: "#8abdedFF")!, border: UIColor(hex: "#1c88edFF")!)
    
    private let signUpButton = UIButton()
    private let birthdayDatePicker = UIDatePicker()
    
    
    private let isModal: Bool
    
    init(appUser: AppUser, isModal: Bool) {
        self.isModal = isModal
        self.appUser = appUser
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
        addSpinner()
    }
    
    func addSpinner() {
        view.addSubview(viewForSpinner)
        addChild(spinner)
        viewForSpinner.addSubview(spinner.view)
        spinner.didMove(toParent: self)
        viewForSpinner.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            viewForSpinner.centerXAnchor.constraint(equalTo: photoView.centerXAnchor),
            viewForSpinner.centerYAnchor.constraint(equalTo: photoView.centerYAnchor),
        ])
    }
    
    private func configure() {
        view.addSubview(photoView)
        photoView.translatesAutoresizingMaskIntoConstraints = false
        photoView.layer.cornerRadius = 50
        photoView.layer.masksToBounds = true
        photoView.image = UIImage(named: "profile")
        
        view.addSubview(imagePickerButton)
        imagePickerButton.setTitle("Выберете фотографию", for: .normal)
        imagePickerButton.translatesAutoresizingMaskIntoConstraints = false
        imagePickerButton.addTarget(self, action: #selector(imageTapped), for: .touchUpInside)
        
        view.addSubview(titleText)
        titleText.translatesAutoresizingMaskIntoConstraints = false
        titleText.text = "Регистрация"
        titleText.font = UIFont.systemFont(ofSize: 38, weight: .bold)
        
        view.addSubview(nameTextField)
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(lastnameTextField)
        lastnameTextField.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(middlenamePasswordTextField)
        middlenamePasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        
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
    
    @objc func imageTapped() {
        imagePicker.showImagePicker(in: self) { [weak self] image in
            guard let self else { return }
            photoView.image = nil
            self.spinner.spinner.startAnimating()
            Task {
                if let photoData = image.jpegData(compressionQuality: 0.5) {
                    print(photoData)
                    do {
                        try await StorageManager.shared.uploadProfilePhoto(for: self.appUser, photoData: photoData)
                        self.photoView.image = image
                        self.spinner.spinner.stopAnimating()
                    } catch {
                        print("ERROR: \(error)")
                    }
                }
            }
        }
    }
    
    
    private func configureStateOfTheSubmitButton() {
        if (nameTextField.text == "" || lastnameTextField.text == "") {
            signUpButton.isEnabled = false
        } else {
            signUpButton.isEnabled = true
        }
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            
            titleText.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            photoView.topAnchor.constraint(equalTo: titleText.bottomAnchor, constant: 20),
            photoView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            photoView.heightAnchor.constraint(equalToConstant: 100),
            photoView.widthAnchor.constraint(equalToConstant: 100),
            
            imagePickerButton.topAnchor.constraint(equalTo: photoView.bottomAnchor, constant: 5),
            imagePickerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            nameTextField.topAnchor.constraint(equalTo: photoView.bottomAnchor, constant: 60),
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
        if isModal {
            self.dismiss(animated: true)
        } else {
            navigationController?.pushViewController(ATTabBarController(user: appUser), animated: true)
        }
    }
}


#Preview() {
    PersonalInfoVC(appUser: AppUser(uid: "1234", email: "123"), isModal: false)
}

extension PersonalInfoVC: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        configureStateOfTheSubmitButton()
    }
}

