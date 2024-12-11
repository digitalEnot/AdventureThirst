//
//  BusinessFormWithPhotoVC.swift
//  AdventureThirst
//
//  Created by Evgeni Novik on 08.12.2024.
//

protocol CompanyRegistrationDelegate: AnyObject {
    func didRegisterCompany(company: AppCompany)
}

import UIKit

class BusinessFormWithPhotoVC: UIViewController {
    
    private let spinner = SpinnerViewController()
    private let viewForSpinner = UIView()
    private let photoView = UIImageView()
    private let imagePicker = ImagePicker()
    private let imagePickerButton = UIButton(type: .system)
    private let signUpButton = UIButton()
    private var descriptionTextField: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.layer.borderColor = UIColor.lightGray.cgColor
        tv.layer.cornerRadius = 8.0
        tv.layer.borderColor = UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? UIColor.white : UIColor.black
        }.cgColor
        tv.layer.borderWidth = 2
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.returnKeyType = .done
        return tv
    }()
    private var placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Введите описание вашей компании..."
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let orgName: String
    let orgWorkingHours: String
    let orgAdress: String
    let orgPhoneNumber: String
    
    weak var delegate: CompanyRegistrationDelegate?
    
    init(orgName: String, orgWorkingHours: String, orgAdress: String, orgPhoneNumber: String) {
        self.orgName = orgName
        self.orgWorkingHours = orgWorkingHours
        self.orgAdress = orgAdress
        self.orgPhoneNumber = orgPhoneNumber
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configure()
        addSpinner()
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
        
        view.addSubview(descriptionTextField)
        descriptionTextField.delegate = self
        descriptionTextField.addSubview(placeholderLabel)
        
        view.addSubview(signUpButton)
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        var signUpConfiguration = UIButton.Configuration.filled()
        signUpConfiguration.title = "Зарегистрировать компанию"
        signUpConfiguration.cornerStyle = .medium
        signUpConfiguration.baseBackgroundColor = .label
        signUpConfiguration.baseForegroundColor = .systemBackground
        signUpConfiguration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.systemFont(ofSize: 15, weight: .bold)
            return outgoing
        }
        signUpButton.configuration = signUpConfiguration
        signUpButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            photoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            photoView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            photoView.heightAnchor.constraint(equalToConstant: 100),
            photoView.widthAnchor.constraint(equalToConstant: 100),
            
            imagePickerButton.topAnchor.constraint(equalTo: photoView.bottomAnchor, constant: 5),
            imagePickerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            descriptionTextField.topAnchor.constraint(equalTo: imagePickerButton.bottomAnchor, constant: 40),
            descriptionTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            descriptionTextField.heightAnchor.constraint(equalToConstant: 300),
            
            signUpButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            signUpButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            signUpButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            signUpButton.heightAnchor.constraint(equalToConstant: 52),
            
            placeholderLabel.leadingAnchor.constraint(equalTo: descriptionTextField.leadingAnchor, constant: 5),
            placeholderLabel.trailingAnchor.constraint(equalTo: descriptionTextField.trailingAnchor, constant: -5),
            placeholderLabel.topAnchor.constraint(equalTo: descriptionTextField.topAnchor, constant: 8)
        ])
    }
    
    private func addSpinner() {
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
    
    
    @objc func imageTapped() {
        imagePicker.showImagePicker(in: self) { [weak self] image in
            guard let self else { return }
            photoView.image = nil
            self.spinner.spinner.startAnimating()
            Task {
                if let photoData = image.jpegData(compressionQuality: 0.5) {
                    print(photoData)
                    do {
                        try await StorageManager.shared.uploadCompanyPhoto(for: self.orgName, photoData: photoData)
                        self.photoView.image = image
                        self.spinner.spinner.stopAnimating()
                    } catch {
                        print("ERROR: \(error)")
                    }
                }
            }
        }
    }
    
    
    @objc func buttonPressed() {
        Task {
            do {
                let sesseion = try await AuthenticationManager.shared.getCurrentSession()
                try await DatabaseManager.shared.createCompany(item: CompanyPayLoad(name: orgName, description: descriptionTextField.text, address: orgAdress, activities: [], phoneNumber: orgPhoneNumber, openHours: orgWorkingHours, userUid: sesseion.uid))
                
                let photo = photoView.image
                guard let photoData = photo?.jpegData(compressionQuality: 0.5) else { return }
                let company = AppCompany(name: orgName, description: descriptionTextField.text, photo: photoData, address: orgAdress, activities: [], phoneNumber: orgPhoneNumber, openHours: orgWorkingHours, userUid: sesseion.uid)
                
                delegate?.didRegisterCompany(company: company)
                navigationController?.pushViewController(BusinessTabBarController(company: company), animated: true)
            } catch {
                print("Error: \(error)")
            }
        }
    }
}


extension BusinessFormWithPhotoVC: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeholderLabel.isHidden = true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
}


#Preview() {
    BusinessFormWithPhotoVC(orgName: "", orgWorkingHours: "", orgAdress: "", orgPhoneNumber: "")
}
