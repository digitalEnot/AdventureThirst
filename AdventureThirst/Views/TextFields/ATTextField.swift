//
//  ATTextField.swift
//  AdventureThirst
//
//  Created by Evgeni Novik on 08.11.2024.
//

import UIKit

class ATTextField: UITextField {
    
    private let padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 30)
    
    init(placeholder: String) {
        super.init(frame: .zero)
        configure(placeholder: placeholder)
    }
    
    convenience init(placeholder: String, background: UIColor, border: UIColor) {
        self.init(placeholder: placeholder)
        layer.borderColor = border.cgColor
        layer.backgroundColor = background.cgColor
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: border])

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
    
    private func configure(placeholder: String) {
        translatesAutoresizingMaskIntoConstraints = false
        
        layer.borderWidth = 3
        layer.borderColor = UIColor.black.cgColor
        layer.cornerRadius = 10
        
        textColor = .label
        tintColor = .label
        
        backgroundColor = .systemBackground
        autocorrectionType = .no
        clearButtonMode = .whileEditing
        returnKeyType = .done
        
        attributedPlaceholder = NSAttributedString(string: placeholder)
        font = .boldSystemFont(ofSize: 15)
    }
}


#Preview() {
    PersonalInfoVC(appUser: AppUser(uid: "", email: ""), isModal: false)
}

