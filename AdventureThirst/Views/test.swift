//
//  test.swift
//  AdventureThirst
//
//  Created by Evgeni Novik on 26.11.2024.
//

import UIKit

class test: UIViewController {
    
    let photoView = UIImageView()
    let imagePicker = ImagePicker()

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        view.addSubview(photoView)
        photoView.translatesAutoresizingMaskIntoConstraints = false
        photoView.layer.cornerRadius = 100
        photoView.layer.masksToBounds = true
        photoView.image = UIImage(named: "profile")
        
        
        photoView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        photoView.addGestureRecognizer(tapGesture)
        
        NSLayoutConstraint.activate([
            photoView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            photoView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            photoView.heightAnchor.constraint(equalToConstant: 200),
            photoView.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    @objc func imageTapped() {
        imagePicker.showImagePicker(in: self) { [weak self] image in
            self?.photoView.image = image
        }
    }
}

#Preview() {
    test()
}
