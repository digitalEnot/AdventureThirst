//
//  BookedActivityCell.swift
//  AdventureThirst
//
//  Created by Evgeni Novik on 23.12.2024.
//

import UIKit

class BookedActivityCell: UICollectionViewCell {
    static let reuseID = "BookedActivityCell"
    
    let activityPhoto = UIImageView()
    let activityName = UILabel()
    let activityPrice = UILabel()
    let activityAdress = UILabel()
    let date = UILabel()
    let time = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
//        backgroundColor = .gray.withAlphaComponent(0.2)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(activity: BookedActivity) {
        Task {
            let photoData = try await StorageManager.shared.fetchActivityPhoto(for: activity.activityPhoto)
            activityPhoto.image = UIImage(data: photoData)
            activityName.text = activity.activityName
            activityPrice.text = "Цена: " + String(activity.activityPrice) + "₽"
            activityAdress.text = "Адрес: " + activity.activityLocation
            activityAdress.setCustomFontSize(forSubstring: "Адрес: ", toSize: 16, defaultSize: 14, toWeight: .bold, defaultWeight: .regular)
            date.text = "Дата: " + activity.date
            time.text = "Время: " + activity.time
            
            activityPrice.setCustomFontSize(forSubstring: "Цена: ", toSize: 16, defaultSize: 14, toWeight: .bold, defaultWeight: .regular)
            date.setCustomFontSize(forSubstring: "Дата: ", toSize: 16, defaultSize: 14, toWeight: .bold, defaultWeight: .regular)
            time.setCustomFontSize(forSubstring: "Время: ", toSize: 16, defaultSize: 14, toWeight: .bold, defaultWeight: .regular)
            
        }
    }
    
    func addTopBorder(color: UIColor, thickness: CGFloat) {
        let topBorder = CALayer()
        topBorder.backgroundColor = color.cgColor
        topBorder.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: thickness)
        self.layer.addSublayer(topBorder)
    }
    
    private func configure() {
        addSubview(activityPhoto)
        addSubview(activityName)
        addSubview(activityPrice)
        addSubview(activityAdress)
        addSubview(date)
        addSubview(time)
        
        activityPhoto.translatesAutoresizingMaskIntoConstraints = false
        activityName.translatesAutoresizingMaskIntoConstraints = false
        activityPrice.translatesAutoresizingMaskIntoConstraints = false
        activityAdress.translatesAutoresizingMaskIntoConstraints = false
        date.translatesAutoresizingMaskIntoConstraints = false
        time.translatesAutoresizingMaskIntoConstraints = false
        
        activityPhoto.contentMode = .scaleAspectFill
        activityPhoto.layer.cornerRadius = 5
        activityPhoto.clipsToBounds = true
        
        activityName.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        activityName.numberOfLines = 1
    
        activityAdress.numberOfLines = 2
        
        layer.cornerRadius = 10
        
//        layer.shadowColor = UIColor.gray.cgColor
//        layer.shadowOpacity = 0.7
//        layer.shadowOffset = CGSize(width: 0, height: 5)
//        layer.shadowRadius = 10
        
        NSLayoutConstraint.activate([
//            activityPhoto.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            activityPhoto.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 5),
            activityPhoto.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            activityPhoto.heightAnchor.constraint(equalToConstant: 120),
            activityPhoto.widthAnchor.constraint(equalToConstant: 120),
            
            activityName.topAnchor.constraint(equalTo: activityPhoto.topAnchor),
            activityName.leadingAnchor.constraint(equalTo: activityPhoto.trailingAnchor, constant: 15),
            activityName.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            
            activityPrice.topAnchor.constraint(equalTo: activityName.bottomAnchor),
            activityPrice.leadingAnchor.constraint(equalTo: activityName.leadingAnchor),
            activityPrice.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            
            activityAdress.topAnchor.constraint(equalTo: activityPrice.bottomAnchor),
            activityAdress.leadingAnchor.constraint(equalTo: activityName.leadingAnchor),
            activityAdress.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            
            date.topAnchor.constraint(equalTo: activityAdress.bottomAnchor),
            date.leadingAnchor.constraint(equalTo: activityName.leadingAnchor),
            
            time.topAnchor.constraint(equalTo: date.bottomAnchor),
            time.leadingAnchor.constraint(equalTo: activityName.leadingAnchor),
//            time.bottomAnchor.constraint(equalTo: activityPhoto.bottomAnchor)
        ])
    }
}
