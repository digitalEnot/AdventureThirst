//
//  ActivityInfoVC.swift
//  AdventureThirst
//
//  Created by Evgeni Novik on 16.12.2024.
//

import UIKit

class ActivityInfoVC: UIViewController {
    
    let selectedCategory: ATCategory
    let company: AppCompany
    
    private let activityNameTextField = ATTextField(placeholder: "Название активности", background: UIColor(hex: "#8abdedFF")!, border: UIColor(hex: "#1c88edFF")!)
    private let activityPriceTextField = ATTextField(placeholder: "Цена ₽", background: UIColor(hex: "#8abdedFF")!, border: UIColor(hex: "#1c88edFF")!)
    private let activityDurationTextField = ATTextField(placeholder: "Продолжительность в минутах", background: UIColor(hex: "#8abdedFF")!, border: UIColor(hex: "#1c88edFF")!)
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
        label.text = "Введите описание активности..."
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let button = UIButton()
    
    weak var delegate: ActivityDelegate?
    
    init(selectedCategory: ATCategory, company: AppCompany) {
        self.selectedCategory = selectedCategory
        self.company = company
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configure()
    }
    

    private func configure() {
        view.addSubview(activityNameTextField)
        activityNameTextField.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(activityPriceTextField)
        activityPriceTextField.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(activityDurationTextField)
        activityDurationTextField.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(descriptionTextField)
        descriptionTextField.delegate = self
        descriptionTextField.addSubview(placeholderLabel)
        
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        var buttonConfiguration = UIButton.Configuration.filled()
        buttonConfiguration.title = "Далее"
        buttonConfiguration.cornerStyle = .medium
        buttonConfiguration.baseBackgroundColor = .label
        buttonConfiguration.baseForegroundColor = .systemBackground
        buttonConfiguration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.systemFont(ofSize: 15, weight: .bold)
            return outgoing
        }
        button.isEnabled = false
        button.configuration = buttonConfiguration
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        
        activityNameTextField.delegate = self
        activityPriceTextField.delegate = self
        activityDurationTextField.delegate = self
        descriptionTextField.delegate = self
        
        
        NSLayoutConstraint.activate([
            activityNameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            activityNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            activityNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            activityNameTextField.heightAnchor.constraint(equalToConstant: 50),
            
            activityPriceTextField.topAnchor.constraint(equalTo: activityNameTextField.bottomAnchor, constant: 20),
            activityPriceTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            activityPriceTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            activityPriceTextField.heightAnchor.constraint(equalToConstant: 50),
            
            activityDurationTextField.topAnchor.constraint(equalTo: activityPriceTextField.bottomAnchor, constant: 20),
            activityDurationTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            activityDurationTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            activityDurationTextField.heightAnchor.constraint(equalToConstant: 50),
            
            descriptionTextField.topAnchor.constraint(equalTo: activityDurationTextField.bottomAnchor, constant: 20),
            descriptionTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            descriptionTextField.heightAnchor.constraint(equalToConstant: 300),
            
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            button.heightAnchor.constraint(equalToConstant: 52),
            
            placeholderLabel.leadingAnchor.constraint(equalTo: descriptionTextField.leadingAnchor, constant: 5),
            placeholderLabel.trailingAnchor.constraint(equalTo: descriptionTextField.trailingAnchor, constant: -5),
            placeholderLabel.topAnchor.constraint(equalTo: descriptionTextField.topAnchor, constant: 8)
        ])
    }
    
    private func configureStateOfTheSubmitButton() {
        if (activityNameTextField.text == "" || activityPriceTextField.text == "" || activityDurationTextField.text == "") {
            button.isEnabled = false
        } else {
            button.isEnabled = true
        }
    }
    
    @objc func buttonPressed() {
        let path = PhotoAndLocationActivity(activityName: activityNameTextField.text!, activityPrice: activityPriceTextField.text!, activityDuration: activityDurationTextField.text!, activityDescription: descriptionTextField.text, company: company, selectedCategory: selectedCategory.name!.rawValue)
        path.delegate = delegate
        path.title = "Добавление активности"
        navigationController?.pushViewController(path, animated: true)
        
    }

}


extension ActivityInfoVC: UITextViewDelegate, UITextFieldDelegate {
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
    
    
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        configureStateOfTheSubmitButton()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
