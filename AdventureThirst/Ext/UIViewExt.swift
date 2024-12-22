//
//  UIViewExt.swift
//  AdventureThirst
//
//  Created by Evgeni Novik on 22.12.2024.
//

import UIKit

extension UIView {
    func pinToEdges(of superView: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superView.topAnchor, constant: -49),
            leadingAnchor.constraint(equalTo: superView.leadingAnchor),
            trailingAnchor.constraint(equalTo: superView.trailingAnchor),
            bottomAnchor.constraint(equalTo: superView.bottomAnchor)
        ])
    }
}
