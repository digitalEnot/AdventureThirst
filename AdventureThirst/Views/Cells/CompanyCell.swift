//
//  CompanyCell.swift
//  AdventureThirst
//
//  Created by Evgeni Novik on 08.12.2024.
//

import UIKit

class CompanyCell: UITableViewCell {

    let companyName = UILabel()
    let address = UILabel()
    let workingHours = UILabel()
    let phoneNuber = UILabel()
    let photo = UIImageView()
    let button = UIButton()
    let cellView = UIView()
    
    static let reuseID = "CompanyCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(companyName: String, address: String, workingHours: String, phoneNumber: String, photo: UIImage) {
        self.companyName.text = companyName
        self.address.text = address
        self.workingHours.text = "Открыто: " + workingHours
        self.phoneNuber.text = "Тел: " + phoneNumber
        self.photo.image = photo
    }
    
    private func configure() {
        addSubview(cellView)
        cellView.translatesAutoresizingMaskIntoConstraints = false
        cellView.layer.cornerRadius = 10
        
        cellView.addSubview(photo)
        photo.translatesAutoresizingMaskIntoConstraints = false
        photo.image = UIImage(named: "housePhoto")
        photo.contentMode = .scaleToFill
        photo.layer.cornerRadius = 10
        photo.clipsToBounds = true
        
        cellView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Выбрать", for: .normal)
        button.layer.cornerRadius = 10
        button.titleLabel?.textColor = .black
        button.backgroundColor = .blue
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        
        cellView.addSubview(companyName)
        companyName.text = "Woodbury Commons"
        companyName.translatesAutoresizingMaskIntoConstraints = false
        companyName.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        
        cellView.addSubview(address)
        address.text = "Saint-Petersgburg, Korablestroiteley street 49"
        address.numberOfLines = 0
        address.translatesAutoresizingMaskIntoConstraints = false
        address.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        
        cellView.addSubview(phoneNuber)
        phoneNuber.text = "Тел: 89818133539"
        phoneNuber.numberOfLines = 1
        phoneNuber.translatesAutoresizingMaskIntoConstraints = false
        phoneNuber.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        
        cellView.addSubview(workingHours)
        workingHours.text = "Открыто: 8:00-21:00"
        workingHours.numberOfLines = 1
        workingHours.translatesAutoresizingMaskIntoConstraints = false
        workingHours.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        
        
        let photoPadding: CGFloat = 13
        let buttonPadding: CGFloat = 26
        let spacing: CGFloat = 7
        NSLayoutConstraint.activate([
//            cellView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
//            cellView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
//            cellView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
//            cellView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            
            cellView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            cellView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            cellView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            cellView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            
            
            photo.centerYAnchor.constraint(equalTo: cellView.centerYAnchor),
            photo.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 15),
            photo.heightAnchor.constraint(equalToConstant: 75),
            photo.widthAnchor.constraint(equalToConstant: 75),
            
            button.centerYAnchor.constraint(equalTo: cellView.centerYAnchor),
            button.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -15),
            button.heightAnchor.constraint(equalToConstant: 25),
            button.widthAnchor.constraint(equalToConstant: 75),
            
            companyName.topAnchor.constraint(equalTo: cellView.topAnchor, constant: spacing),
            companyName.leadingAnchor.constraint(equalTo: photo.trailingAnchor, constant: photoPadding),
            companyName.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -10),
            
            address.topAnchor.constraint(equalTo: companyName.bottomAnchor, constant: spacing),
            address.leadingAnchor.constraint(equalTo: photo.trailingAnchor, constant: photoPadding),
            address.trailingAnchor.constraint(equalTo: button.leadingAnchor, constant: -buttonPadding),
            
            phoneNuber.topAnchor.constraint(equalTo: address.bottomAnchor, constant: spacing),
            phoneNuber.leadingAnchor.constraint(equalTo: photo.trailingAnchor, constant: photoPadding),
            phoneNuber.trailingAnchor.constraint(equalTo: button.leadingAnchor, constant: -buttonPadding),
            
            workingHours.topAnchor.constraint(equalTo: phoneNuber.bottomAnchor, constant: spacing),
            workingHours.leadingAnchor.constraint(equalTo: photo.trailingAnchor, constant: photoPadding),
            workingHours.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: -spacing),
            workingHours.trailingAnchor.constraint(equalTo: button.leadingAnchor, constant: -buttonPadding),
        ])
    }
}


