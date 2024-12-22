//
//  BookingVC.swift
//  AdventureThirst
//
//  Created by Evgeni Novik on 22.12.2024.
//

import UIKit

class BookingVC: UIViewController {
    
    // Добавить в компанию которая находится в активности 
    let activity: AppActivity
    let userData: UserData
    let company: Company
    var bookedForCompany: [String]? = []
    var bookedForUser: [String]? = []
    let uid = UUID().uuidString
    let uidForBusiness = UUID().uuidString
    
    private let dateLabel = UILabel()
    private let timeLabel = UILabel()
    let dateField = ATTextField(placeholder: "Введите дату посещения")
    let timeField = ATTextField(placeholder: "Введите время посещения")
    private let button = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configure()
        fetch()
    }
    
    
    init(activity: AppActivity, userData: UserData, company: Company) {
        self.activity = activity
        self.userData = userData
        self.company = company
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func fetch() {
        Task {
            let company = try await DatabaseManager.shared.fetchCompanyWithName(for: company.name)
            let userData = try await DatabaseManager.shared.fetchToDoItems(for: userData.uid)
            bookedForCompany = company[0].bookedActivities
            bookedForUser = userData[0].bookedActivities
        }
    }
    
    
    private func configure() {
        view.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.text = "Выберите дату"
        dateLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        
        view.addSubview(timeLabel)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.text = "Выберите время. Время работы: (\(company.openHours)) "
        timeLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        timeLabel.numberOfLines = 0
        
        view.addSubview(dateField)
        dateField.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(timeField)
        timeField.translatesAutoresizingMaskIntoConstraints = false
        
        dateField.delegate = self
        timeField.delegate = self
        
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
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
        button.configuration = signUpConfiguration
        button.isEnabled = false
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            dateField.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10),
            dateField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            dateField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            dateField.heightAnchor.constraint(equalToConstant: 50),
            
            timeLabel.topAnchor.constraint(equalTo: dateField.bottomAnchor, constant: 25),
            timeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            timeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        
            timeField.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 10),
            timeField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            timeField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            timeField.heightAnchor.constraint(equalToConstant: 50),
            
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            button.heightAnchor.constraint(equalToConstant: 52),
        ])
    }
    
    private func configureStateOfTheSubmitButton() {
        if (dateField.text == "" || timeField.text == "") {
            button.isEnabled = false
        } else {
            button.isEnabled = true
        }
    }
    
    @objc func buttonPressed() {
        guard var bookedForCompany, var bookedForUser else { return }
        let bookedActivityForBusiness = BookedActivityForBusinessPayLoad(uid: uidForBusiness, userPhoto: userData.uid, userName: userData.name, activityName: activity.name, date: dateField.text!, time: timeField.text!)
        let bookedActivity = BookedActivityPayLoad(uid: uid, activityPhoto: activity.uid, activityName: activity.name, activityPrice: activity.price, activityLocation: activity.location, date: dateField.text!, time: timeField.text!)
        
        navigationController?.popToRootViewController(animated: true)
        Task {
            _ = try await DatabaseManager.shared.createBookedActivity(item: bookedActivity)
            _ = try await DatabaseManager.shared.createBookedActivityForBusiness(item: bookedActivityForBusiness)
            bookedForCompany.append(bookedActivityForBusiness.uid)
            bookedForUser.append(bookedActivity.uid)
            
            _ = try await DatabaseManager.shared.updateBookedActivities(bookedActivities: bookedForUser, for: userData.uid)
            _ = try await DatabaseManager.shared.updateBookedActivityForBusiness(bookedActivityForBusiness: bookedForCompany, for: company.name)
        }
        
    }
}


extension BookingVC: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        configureStateOfTheSubmitButton()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
