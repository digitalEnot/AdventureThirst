//
//  AddBusinessView.swift
//  AdventureThirst
//
//  Created by Evgeni Novik on 05.12.2024.
//

import UIKit

class AddBusinessView: UIView {

    let viewTitle = UILabel()
    let viewDescription = UILabel()
    let picture = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubview(viewTitle)
        addSubview(viewDescription)
        addSubview(picture)
        
        backgroundColor = .white
        
        viewTitle.text = "Добавить свою компанию"
        viewTitle.translatesAutoresizingMaskIntoConstraints = false
        viewTitle.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        
        viewDescription.text = "Просто заполните небольшую анкету, \nа все остальные заботы мы возьмем на себя"
        viewDescription.translatesAutoresizingMaskIntoConstraints = false
        viewDescription.font = UIFont.systemFont(ofSize: 11, weight: .light)
        viewDescription.numberOfLines = 2
        
        picture.image = UIImage(named: "surfvan")
        picture.translatesAutoresizingMaskIntoConstraints = false
        picture.contentMode = .scaleAspectFit
//        picture.backgroundColor = .blue
        
        let padding: CGFloat = 18
        NSLayoutConstraint.activate([
            viewTitle.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            viewTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            
            viewDescription.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
            viewDescription.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            
            picture.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -15),
            picture.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 25),
            picture.heightAnchor.constraint(equalToConstant: 170),
            picture.widthAnchor.constraint(equalToConstant: 170)
        ])
    }
    
    

}

#Preview() {
    SettingsVC(userData: UserData(uid: "", email: "", name: "", lastName: "", middleName: "", photoData: Data()))
}
