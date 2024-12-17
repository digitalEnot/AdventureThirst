//
//  RegistrationActivityCategoryCell.swift
//  AdventureThirst
//
//  Created by Evgeni Novik on 16.12.2024.
//

import UIKit

class RegistrationActivityCategoryCell: UICollectionViewCell {
    static let reuseID = "RegistrationActivityCategoryCell"
    
    let textLabel = UILabel()
    let image = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(icon: UIImage?, name: String?) {
        image.image = icon
        image.tintColor = .gray
        textLabel.text = name
    }
    
    private func configure() {
        addSubview(textLabel)
        addSubview(image)
        image.translatesAutoresizingMaskIntoConstraints = false
        
        textLabel.textAlignment = .center
        textLabel.textColor = .black
        textLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: topAnchor, constant: 65),
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            textLabel.heightAnchor.constraint(equalToConstant: 18),
            
            image.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            image.leadingAnchor.constraint(equalTo: textLabel.leadingAnchor),
            image.heightAnchor.constraint(equalToConstant: 32),
            image.widthAnchor.constraint(equalTo: image.heightAnchor)
        ])
    }
    
}
