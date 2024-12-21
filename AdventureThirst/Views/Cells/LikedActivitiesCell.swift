//
//  LikedActivitiesCell.swift
//  AdventureThirst
//
//  Created by Evgeni Novik on 21.12.2024.
//

import UIKit

protocol UnlikeDelegate: AnyObject {
    func didPressedUnLike(activity: AppActivity)
}

class LikedActivitiesCell: UICollectionViewCell {
    static let reuseID = "LikedActivitiesCell"
    
    let photo = UIImageView()
    let name = UILabel()
    let companyName = UILabel()
    let price = UILabel()
    let duration = UILabel()
    let rating = UILabel()
    let ratingIcon = UIImageView()
    let likeButton = UIButton()
    var isLiked = false
    let likeIconConfiguration = UIImage.SymbolConfiguration(pointSize: 26, weight: .medium)
    var activity: AppActivity?
    
    weak var delegate: UnlikeDelegate?
    
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
        self.activity = activity
    }
    
    func isLiked(_ isLiked: Bool) {
        self.isLiked = isLiked
        if isLiked {
            setIconToLiked()
        } else {
            setIconToDefault()
        }
    }
    
    
    private func configure() {
        addSubview(photo)
        addSubview(name)
        addSubview(companyName)
        addSubview(price)
        addSubview(duration)
        addSubview(rating)
        addSubview(ratingIcon)
        addSubview(likeButton)
        
        photo.translatesAutoresizingMaskIntoConstraints = false
        name.translatesAutoresizingMaskIntoConstraints = false
        companyName.translatesAutoresizingMaskIntoConstraints = false
        price.translatesAutoresizingMaskIntoConstraints = false
        duration.translatesAutoresizingMaskIntoConstraints = false
        rating.translatesAutoresizingMaskIntoConstraints = false
        ratingIcon.translatesAutoresizingMaskIntoConstraints = false
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        
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
        
        likeButton.addTarget(self, action: #selector(likePressed), for: .touchUpInside)
        likeButton.setImage(UIImage(systemName: "heart", withConfiguration: likeIconConfiguration), for: .normal)
        likeButton.imageView?.tintColor = .white
        
        
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
            
            likeButton.topAnchor.constraint(equalTo: photo.topAnchor, constant: 20),
            likeButton.trailingAnchor.constraint(equalTo: photo.trailingAnchor, constant: -20),
        ])
    }
    
    func setIconToDefault() {
        likeButton.setImage(UIImage(systemName: "heart", withConfiguration: likeIconConfiguration), for: .normal)
        likeButton.imageView?.tintColor = .white
    }
    
    func setIconToLiked() {
        likeButton.setImage(UIImage(systemName: "heart.fill", withConfiguration: likeIconConfiguration), for: .normal)
        likeButton.imageView?.tintColor = .red
    }
    
    @objc func likePressed() {
        delegate?.didPressedUnLike(activity: activity!)
    }
}

