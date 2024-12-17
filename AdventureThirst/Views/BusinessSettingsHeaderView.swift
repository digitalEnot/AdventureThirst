//
//  BusinessSettingsHeaderView.swift
//  AdventureThirst
//
//  Created by Evgeni Novik on 12.12.2024.
//

import UIKit

class BusinessSettingsHeaderView: UIView {
    private let companyPhotoView = UIImageView()
    private let companyName = UILabel()
    
//    let company: AppCompany
    
    init(frame: CGRect, company: AppCompany) {
        companyName.text = company.name
        companyPhotoView.image = UIImage(data: company.photo)
        super.init(frame: frame)
        configure()
        constraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubview(companyPhotoView)
//        photoView.image = UIImage(named: "profile")
        companyPhotoView.translatesAutoresizingMaskIntoConstraints = false
        companyPhotoView.layer.cornerRadius = 10
        companyPhotoView.layer.masksToBounds = true
        
        addSubview(companyName)
//        userName.text = "Евгений"
        companyName.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        companyName.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func constraints() {
        NSLayoutConstraint.activate([
            companyPhotoView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            companyPhotoView.centerXAnchor.constraint(equalTo: centerXAnchor),
            companyPhotoView.heightAnchor.constraint(equalToConstant: 100),
            companyPhotoView.widthAnchor.constraint(equalToConstant: 100),
            
            companyName.topAnchor.constraint(equalTo: companyPhotoView.bottomAnchor, constant: 15),
            companyName.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }
}
