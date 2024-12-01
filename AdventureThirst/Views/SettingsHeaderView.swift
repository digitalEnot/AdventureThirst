//
//  SettingsHeaderView.swift
//  AdventureThirst
//
//  Created by Evgeni Novik on 29.11.2024.
//

import UIKit

class SettingsHeaderView: UIView {
    
    private let photoView = UIImageView()
    private let imagePicker = ImagePicker()
    private let imagePickerButton = UIButton(type: .system)
    private let userName = UILabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        getUserData()
        configure()
        constraints()
    }

    
    private func getUserData() {
        Task {
            do {
                let session = try await AuthenticationManager.shared.getCurrentSession()
                let userdata = try await DatabaseManager.shared.fetchToDoItems(for: session.uid)
                print(session.uid)
                let photoData = try await StorageManager.shared.fetchProfilePhoto(for: session)
                
                photoView.image = UIImage(data: photoData)
                userName.text = userdata[0].name
            } catch {
                print("error when fetching userData: \(error)")
            }
        }
    }
    
    private func configure() {
        addSubview(photoView)
//        photoView.image = UIImage(named: "profile")
        photoView.translatesAutoresizingMaskIntoConstraints = false
        photoView.layer.cornerRadius = 50
        photoView.layer.masksToBounds = true
        
        addSubview(userName)
//        userName.text = "Евгений"
        userName.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        userName.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    private func constraints() {
        NSLayoutConstraint.activate([
            photoView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            photoView.centerXAnchor.constraint(equalTo: centerXAnchor),
            photoView.heightAnchor.constraint(equalToConstant: 100),
            photoView.widthAnchor.constraint(equalToConstant: 100),
            
            userName.topAnchor.constraint(equalTo: photoView.bottomAnchor, constant: 15),
            userName.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


#Preview() {
    SettingsVC()
}
