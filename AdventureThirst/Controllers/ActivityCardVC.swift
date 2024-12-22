//
//  ActivityInfoVC.swift
//  AdventureThirst
//
//  Created by Evgeni Novik on 19.12.2024.
//

import UIKit

class ActivityCardVC: UIViewController {
    
    let sdd = UIScreen.main.bounds.size.height
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let price = UILabel()
    let duration = UILabel()
    let acitvityName = UILabel()
    let activityDescription = UILabel()
    let rating = UILabel()
    let ratingIcon = UIImageView()
    let location = UILabel()
    let button = UIButton()
    
    let activityPhoto = UIImageView()
    let companyPhoto = UIImageView()
    let companyName = UILabel()

    let activity: AppActivity
    var companyInfo: Company?

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCompany()
        configureScrollView()
        configure()
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.backgroundColor = .clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    init(activity: AppActivity) {
        self.activity = activity
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.pinToEdges(of: view)
        contentView.pinToEdges(of: scrollView)
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: sdd - 30)
        ])
    }
    
    private func fetchCompany() {
        Task {
            let company = try await DatabaseManager.shared.fetchCompanyWithName(for: activity.companyName)
            let companyPhotoData = try await StorageManager.shared.fetchCompanyPhoto(for: company[0].phoneNumber)
            
            companyName.text = company[0].name
            companyPhoto.image = UIImage(data: companyPhotoData)
            price.text = String(activity.price) + " ₽"
            duration.text = "за " + String(activity.duration) + " минут"
            acitvityName.text = activity.name
            activityDescription.text = activity.description
            location.text = "Адрес: " + activity.location
            location.setCustomFontSize(forSubstring: "Адрес:", toSize: 18, defaultSize: 18, toWeight: .semibold, defaultWeight: .regular)
        }
    }
    
    private func configure() {
        view.backgroundColor = .systemBackground
        
        contentView.addSubview(price)
        price.font = UIFont.systemFont(ofSize: 36, weight: .bold)
        price.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(duration)
        duration.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        duration.translatesAutoresizingMaskIntoConstraints = false
        duration.textColor = .gray
        
        contentView.addSubview(acitvityName)
        acitvityName.translatesAutoresizingMaskIntoConstraints = false
        acitvityName.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        acitvityName.numberOfLines = 0
        
        contentView.addSubview(activityDescription)
        activityDescription.translatesAutoresizingMaskIntoConstraints = false
        activityDescription.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        activityDescription.textColor = .gray
        activityDescription.numberOfLines = 0
        
        contentView.addSubview(activityPhoto)
        activityPhoto.image = activity.photo
        activityPhoto.translatesAutoresizingMaskIntoConstraints = false
        activityPhoto.contentMode = .scaleAspectFill
        activityPhoto.clipsToBounds = true
        
        contentView.addSubview(companyPhoto)
        companyPhoto.layer.cornerRadius = 5
        companyPhoto.clipsToBounds = true
        companyPhoto.translatesAutoresizingMaskIntoConstraints = false
        companyPhoto.contentMode = .scaleAspectFill
        
        contentView.addSubview(companyName)
        companyName.translatesAutoresizingMaskIntoConstraints = false
        companyName.font = UIFont.systemFont(ofSize: 18)
        
        contentView.addSubview(location)
        location.translatesAutoresizingMaskIntoConstraints = false
        location.numberOfLines = 0
        
        contentView.addSubview(button)
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
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
                                
            activityPhoto.topAnchor.constraint(equalTo: contentView.topAnchor),
            activityPhoto.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            activityPhoto.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            activityPhoto.heightAnchor.constraint(equalToConstant: 350),
            
            price.topAnchor.constraint(equalTo: activityPhoto.bottomAnchor, constant: 20),
            price.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            duration.bottomAnchor.constraint(equalTo: price.bottomAnchor),
            duration.leadingAnchor.constraint(equalTo: price.trailingAnchor, constant: 5),
            
            acitvityName.topAnchor.constraint(equalTo: price.bottomAnchor, constant: 10),
            acitvityName.leadingAnchor.constraint(equalTo: price.leadingAnchor),
            acitvityName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            companyPhoto.topAnchor.constraint(equalTo: acitvityName.bottomAnchor, constant: 15),
            companyPhoto.leadingAnchor.constraint(equalTo: price.leadingAnchor),
            companyPhoto.heightAnchor.constraint(equalToConstant: 50),
            companyPhoto.widthAnchor.constraint(equalToConstant: 50),
            
            companyName.centerYAnchor.constraint(equalTo: companyPhoto.centerYAnchor),
            companyName.leadingAnchor.constraint(equalTo: companyPhoto.trailingAnchor, constant: 5),
            
            activityDescription.topAnchor.constraint(equalTo: companyPhoto.bottomAnchor, constant: 15),
            activityDescription.leadingAnchor.constraint(equalTo: price.leadingAnchor),
            activityDescription.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            location.topAnchor.constraint(equalTo: activityDescription.bottomAnchor, constant: 15),
            location.leadingAnchor.constraint(equalTo: price.leadingAnchor),
            location.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            button.heightAnchor.constraint(equalToConstant: 52),
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            button.topAnchor.constraint(greaterThanOrEqualTo: location.bottomAnchor, constant: 20),
        ])
    }
    
    @objc func buttonPressed() {
        
    }
    
    @objc func kek() {
        navigationController?.popViewController(animated: true)
    }
}
