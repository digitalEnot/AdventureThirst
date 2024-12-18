//
//  ActivityCell.swift
//  AdventureThirst
//
//  Created by Evgeni Novik on 17.12.2024.
//

import UIKit

class ActivityCell: UICollectionViewCell {
    static let reuseID = "ActivityCell"
    
    let photo = UIImageView()
    let name = UILabel()
    let companyName = UILabel()
    let price = UILabel()
    let duration = UILabel()
    let rating = UILabel()
    let ratingIcon = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func set(activity: AppActivity) {
        photo.image = activity.photo
        name.text = activity.name
        companyName.text = activity.companyName
        price.text = String(activity.price) + " ₽"
        duration.text = String(activity.duration) + " минут"
        rating.text = String(activity.rating)
    }
    
    
    private func configure() {
        addSubview(photo)
        addSubview(name)
        addSubview(companyName)
        addSubview(price)
        addSubview(duration)
        addSubview(rating)
        addSubview(ratingIcon)
        
        photo.translatesAutoresizingMaskIntoConstraints = false
        name.translatesAutoresizingMaskIntoConstraints = false
        companyName.translatesAutoresizingMaskIntoConstraints = false
        price.translatesAutoresizingMaskIntoConstraints = false
        duration.translatesAutoresizingMaskIntoConstraints = false
        rating.translatesAutoresizingMaskIntoConstraints = false
        ratingIcon.translatesAutoresizingMaskIntoConstraints = false
        
        photo.contentMode = .scaleAspectFill
        photo.layer.cornerRadius = 10
        photo.clipsToBounds = true
        
        name.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        
        companyName.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        companyName.textColor = .gray
        
        price.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        
        duration.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        
        rating.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        
        let configuration = UIImage.SymbolConfiguration(pointSize: 13, weight: .medium)
        ratingIcon.image = UIImage(systemName: "star.fill", withConfiguration: configuration)
        ratingIcon.tintColor = .black
        
        NSLayoutConstraint.activate([
            photo.topAnchor.constraint(equalTo: topAnchor),
            photo.leadingAnchor.constraint(equalTo: leadingAnchor),
            photo.trailingAnchor.constraint(equalTo: trailingAnchor),
            photo.heightAnchor.constraint(equalToConstant: 400),
            
            name.topAnchor.constraint(equalTo: photo.bottomAnchor, constant: 10),
            name.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            companyName.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 5),
            companyName.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            price.topAnchor.constraint(equalTo: companyName.bottomAnchor, constant: 5),
            price.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            duration.topAnchor.constraint(equalTo: companyName.bottomAnchor, constant: 5),
            duration.leadingAnchor.constraint(equalTo: price.trailingAnchor, constant: 10),
            
            ratingIcon.topAnchor.constraint(equalTo: photo.bottomAnchor, constant: 10),
            ratingIcon.trailingAnchor.constraint(equalTo: rating.leadingAnchor, constant: -5),
            
            rating.centerYAnchor.constraint(equalTo: ratingIcon.centerYAnchor),
            rating.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
}
