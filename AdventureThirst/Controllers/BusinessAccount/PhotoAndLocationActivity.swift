//
//  PhotoAndLocationActivity.swift
//  AdventureThirst
//
//  Created by Evgeni Novik on 16.12.2024.
//

import UIKit

protocol ActivityDelegate: AnyObject {
    func activityUploaded(activity: AppActivity)
}

class PhotoAndLocationActivity: UIViewController {

    private let spinner = SpinnerViewController()
    private let viewForSpinner = UIView()
    private let photoView = UIImageView()
    private let imagePicker = ImagePicker()
    private let imagePickerButton = UIButton(type: .system)
    private let button = UIButton()
    private let activityLocationTextField = ATTextField(placeholder: "Введите адрес", background: UIColor(hex: "#8abdedFF")!, border: UIColor(hex: "#1c88edFF")!)
   
    
    let activityName: String
    let activityPrice: String
    let activityDuration: String
    let activityDescription: String
    let company: AppCompany
    let selectedCategory: String
    let uniqueID = UUID().uuidString.lowercased()
    
    weak var delegate: ActivityDelegate?
    
    init(activityName: String, activityPrice: String, activityDuration: String, activityDescription: String, company: AppCompany,  selectedCategory: String) {
        self.activityName = activityName
        self.activityPrice = activityPrice
        self.activityDuration = activityDuration
        self.activityDescription = activityDescription
        self.company = company
        self.selectedCategory = selectedCategory
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
        photoView.layer.cornerRadius = 10
        photoView.contentMode = .scaleAspectFill
        photoView.layer.masksToBounds = true
        photoView.image = UIImage(named: "profile")
        
        view.addSubview(imagePickerButton)
        imagePickerButton.setTitle("Выберете фотографию", for: .normal)
        imagePickerButton.translatesAutoresizingMaskIntoConstraints = false
        imagePickerButton.addTarget(self, action: #selector(imageTapped), for: .touchUpInside)
        
        view.addSubview(activityLocationTextField)
        activityLocationTextField.translatesAutoresizingMaskIntoConstraints = false
        activityLocationTextField.delegate = self
        
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        var signUpConfiguration = UIButton.Configuration.filled()
        signUpConfiguration.title = "Добавить активность"
        signUpConfiguration.cornerStyle = .medium
        signUpConfiguration.baseBackgroundColor = .label
        signUpConfiguration.baseForegroundColor = .systemBackground
        signUpConfiguration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.systemFont(ofSize: 15, weight: .bold)
            return outgoing
        }
        button.configuration = signUpConfiguration
        button.isEnabled = false
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            photoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            photoView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            photoView.heightAnchor.constraint(equalToConstant: 300),
            photoView.widthAnchor.constraint(equalToConstant: 300),
            
            imagePickerButton.topAnchor.constraint(equalTo: photoView.bottomAnchor, constant: 5),
            imagePickerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            activityLocationTextField.topAnchor.constraint(equalTo: imagePickerButton.bottomAnchor, constant: 40),
            activityLocationTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            activityLocationTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            activityLocationTextField.heightAnchor.constraint(equalToConstant: 50),
            
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            button.heightAnchor.constraint(equalToConstant: 52),
            
            
        ])
    }
    
    private func configureStateOfTheSubmitButton() {
        if (activityLocationTextField.text == "") {
            button.isEnabled = false
        } else {
            button.isEnabled = true
        }
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
                if let photoData = image.jpegData(compressionQuality: 0.1) {
                    do {
                        try await StorageManager.shared.uploadActivityPhoto(for: self.uniqueID, photoData: photoData)
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
                let activity = ActivityPayLoad(name: activityName, location: activityLocationTextField.text!, description: activityDescription, price: activityPrice, duration: activityDuration, activityCategory: selectedCategory, companyName: company.name, uid: uniqueID)
                let photo = photoView.image
                let appActivity = AppActivity(name: activityName, location: activityLocationTextField.text!, description: activityDescription, price: activityPrice, duration: activityDuration, activityCategory: selectedCategory, photo: photo ?? UIImage(named: "profile")!, companyName: company.name, uid: uniqueID)
                var activities = company.activities
                activities.append(activity.name)
                let companyPayLoad = CompanyPayLoad(name: company.name, description: company.description, address: company.address, activities: activities, phoneNumber: company.phoneNumber, openHours: company.openHours, userUid: company.userUid)
                try await DatabaseManager.shared.createActivity(item: activity, company: companyPayLoad)
                delegate?.activityUploaded(activity: appActivity)
                dismiss(animated: true)
            } catch {
                print("Error: \(error)")
            }
        }
    }
}


extension PhotoAndLocationActivity: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        configureStateOfTheSubmitButton()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}



#Preview() {
    PhotoAndLocationActivity(activityName: "", activityPrice: "", activityDuration: "", activityDescription: "", company: AppCompany(name: "", description: "", photo: Data(), address: "", activities: [], phoneNumber: "", openHours: "", userUid: ""), selectedCategory: "")
}
