//
//  SettingsTableViewCell.swift
//  AdventureThirst
//
//  Created by Evgeni Novik on 26.11.2024.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    
    static let identifier = "SettingsTableViewCell"
    let cellTitle = UILabel()
    let cellImage = UIImageView()
    let arrowImage = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        clipsToBounds = true
    }
    
    func setCell(text: String?, image: UIImage?, textColor: UIColor, hasArrow: Bool = true) {
        cellTitle.text = text
        cellTitle.textColor = textColor
        cellImage.image = image?.withTintColor(.black, renderingMode: .alwaysOriginal)
        
        if hasArrow {
            arrowImage.image = UIImage(systemName: "chevron.right")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        }
    }
    
    private func configureUI() {
        addSubview(cellTitle)
        addSubview(cellImage)
        addSubview(arrowImage)
        
        cellTitle.text = "Настройки"
        cellTitle.translatesAutoresizingMaskIntoConstraints = false
        //cellTitle.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        cellTitle.textColor = .black
        
        cellImage.image = UIImage(systemName: "person.circle")
        cellImage.translatesAutoresizingMaskIntoConstraints = false
        
        
        arrowImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cellImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            cellImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            
            cellTitle.centerYAnchor.constraint(equalTo: centerYAnchor),
            cellTitle.leadingAnchor.constraint(equalTo: cellImage.trailingAnchor, constant: 10),
            
            arrowImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            arrowImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
    }
}


#Preview() {
    SettingsVC()
}
