//
//  SettingsHeaderView.swift
//  AdventureThirst
//
//  Created by Evgeni Novik on 29.11.2024.
//

import UIKit

protocol AddBusinessDelegate: AnyObject {
    func showAddBusinessVC()
}

class SettingsHeaderView: UIView {
    
    private let photoView = UIImageView()
    private let imagePicker = ImagePicker()
    private let imagePickerButton = UIButton(type: .system)
    private let userName = UILabel()
    private let businessView = AddBusinessView()
    
    let companies: [AppCompany]
    
    
    init(frame: CGRect, companies: [AppCompany]) {
        self.companies = companies
        super.init(frame: frame)
        configure()
        constraints()
    }
    
    func updateCompanies(with count: Int) {
        if count > 0 {
            businessView.removeFromSuperview()
        }
    }
    
    weak var delegate: AddBusinessDelegate?
    
    func setData(userData: UserData?) {
        guard let userData else { return }
        photoView.image = UIImage(data: userData.photoData)
        userName.text = userData.name
    }
    
    private func configure() {
        addSubview(photoView)
//        photoView.image = UIImage(named: "profile")
        photoView.translatesAutoresizingMaskIntoConstraints = false
        photoView.layer.cornerRadius = 50
        photoView.layer.masksToBounds = true
        
        addSubview(userName)
//        userName.text = "Евгений"
        userName.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        userName.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(businessView)
        businessView.translatesAutoresizingMaskIntoConstraints = false
        businessView.layer.cornerRadius = 10
        
        
        businessView.layer.shadowColor = UIColor.gray.cgColor
        businessView.layer.shadowOpacity = 0.5
        businessView.layer.shadowOffset = CGSize(width: 0, height: 5)
        businessView.layer.shadowRadius = 10
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(addBusiness))
        businessView.addGestureRecognizer(gesture)
    }
    
    @objc func addBusiness() {
        delegate?.showAddBusinessVC()
        print("pressed")
    }
    
    private func setCompanies() {
        
    }
    
    private func constraints() {
        NSLayoutConstraint.activate([
            photoView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            photoView.centerXAnchor.constraint(equalTo: centerXAnchor),
            photoView.heightAnchor.constraint(equalToConstant: 100),
            photoView.widthAnchor.constraint(equalToConstant: 100),
            
            userName.topAnchor.constraint(equalTo: photoView.bottomAnchor, constant: 15),
            userName.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            businessView.topAnchor.constraint(equalTo: userName.bottomAnchor, constant: 25),
            businessView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            businessView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            businessView.heightAnchor.constraint(equalToConstant: 96)
        ])
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


#Preview() {
    SettingsVC(userData: UserData(uid: "", email: "", name: "", lastName: "", middleName: "", photoData: Data(), likedActivities: []), companies: [])
}
