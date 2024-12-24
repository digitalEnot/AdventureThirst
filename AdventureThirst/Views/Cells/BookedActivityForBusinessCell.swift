//
//  BookedActivityForBusinessCell.swift
//  AdventureThirst
//
//  Created by Evgeni Novik on 23.12.2024.
//

import UIKit

class BookedActivityForBusinessCell: UICollectionViewCell {
    
    let userPhoto = UIImageView()
    let userName = UILabel()
    let activityName = UILabel()
    let date = UILabel()
    let time = UILabel()
    
    
    static let reuseID = "BookedActivityForBusinessCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .gray.withAlphaComponent(0.2)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(activity: BookedActivityForBusiness, addBorder: Bool) {
        Task {
            let photoData = try await StorageManager.shared.fetchProfilePhotoWithUid(for: activity.userPhoto)
            userPhoto.image = UIImage(data: photoData)
            userName.text = activity.userName
            activityName.text = activity.activityName
            date.text = "Дата: " + activity.date
            time.text = "Время: " + activity.time
            date.setCustomFontSize(forSubstring: "Дата: ", toSize: 16, defaultSize: 14, toWeight: .bold, defaultWeight: .regular)
            time.setCustomFontSize(forSubstring: "Время: ", toSize: 16, defaultSize: 14, toWeight: .bold, defaultWeight: .regular)
            backgroundColor = .white
            
            if addBorder {
                addTopBorder(color: .gray, thickness: 1)
            }
        }
    }
    
    func addTopBorder(color: UIColor, thickness: CGFloat) {
        let topBorder = CALayer()
        topBorder.backgroundColor = color.cgColor
        topBorder.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: thickness)
        self.layer.addSublayer(topBorder)
    }
    
    private func configure() {
        addSubview(userPhoto)
        addSubview(userName)
        addSubview(activityName)
        addSubview(date)
        addSubview(time)
//        
        userPhoto.translatesAutoresizingMaskIntoConstraints = false
        userName.translatesAutoresizingMaskIntoConstraints = false
        activityName.translatesAutoresizingMaskIntoConstraints = false
        date.translatesAutoresizingMaskIntoConstraints = false
        time.translatesAutoresizingMaskIntoConstraints = false
        
        userPhoto.contentMode = .scaleAspectFill
        userPhoto.layer.cornerRadius = 40
        userPhoto.clipsToBounds = true
        
        userName.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        userName.numberOfLines = 1
        userName.textAlignment = .center
    
        activityName.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        activityName.numberOfLines = 1
        
        layer.cornerRadius = 10
        
        NSLayoutConstraint.activate([
            userPhoto.topAnchor.constraint(equalTo: topAnchor, constant: 17),
            userPhoto.centerXAnchor.constraint(equalTo: userName.centerXAnchor),
            userPhoto.heightAnchor.constraint(equalToConstant: 80),
            userPhoto.widthAnchor.constraint(equalToConstant: 80),
            
            userName.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -17),
            userName.leadingAnchor.constraint(equalTo: leadingAnchor),
            userName.widthAnchor.constraint(equalToConstant: 110),
            
            activityName.leadingAnchor.constraint(equalTo: userName.trailingAnchor, constant: 10),
            activityName.bottomAnchor.constraint(equalTo: date.topAnchor, constant: -10),
            activityName.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            
//            date.topAnchor.constraint(equalTo: activityName.bottomAnchor, constant: 10),
            date.centerYAnchor.constraint(equalTo: centerYAnchor),
            date.leadingAnchor.constraint(equalTo: userName.trailingAnchor, constant: 10),
            
            time.topAnchor.constraint(equalTo: date.bottomAnchor, constant: 10),
            time.leadingAnchor.constraint(equalTo: userName.trailingAnchor, constant: 10),
            
        ])
    }
    
}
