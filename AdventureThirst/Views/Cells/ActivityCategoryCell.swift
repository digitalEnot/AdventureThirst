//
//  ActivityCategorieCell.swift
//  AdventureThirst
//
//  Created by Evgeni Novik on 16.12.2024.
//

import UIKit

class ActivityCategoryCell: UICollectionViewCell {
    static let reuseID = "ActivityCategoryCell"
    
    let image = UIImageView()
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(icon: UIImage?, name: String?) {
//        let iconImage = UIImage(named: "ski")?.withRenderingMode(.alwaysTemplate)
//        image.image = iconImage
//        image.tintColor = .blue
        
        
        image.image = icon
        image.tintColor = .gray
        label.text = name
    }
    
    private func configure() {
        addSubview(image)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
//        image.tintColor = .gray
        
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 11, weight: .light)
        label.textColor = .gray
        
        NSLayoutConstraint.activate([
            image.centerXAnchor.constraint(equalTo: centerXAnchor),
            image.topAnchor.constraint(equalTo: topAnchor),
            image.heightAnchor.constraint(equalToConstant: 50),
            image.widthAnchor.constraint(equalToConstant: 50),
            
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 10)
        ])
    }
    
}
