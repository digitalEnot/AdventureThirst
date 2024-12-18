//
//  SearchBar.swift
//  AdventureThirst
//
//  Created by Evgeni Novik on 17.12.2024.
//

import UIKit

class SearchBar: UITextField {
    
    private let padding = UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 30)

    init(textInPlaceholder: String) {
        super.init(frame: .zero)
        configure(textInPlaceholder: textInPlaceholder)
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
    
    private func configure(textInPlaceholder: String) {
        translatesAutoresizingMaskIntoConstraints = false
        
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.shadowRadius = 10
        
        layer.cornerRadius = 25
        
        textColor = .label
        tintColor = .label
        
        backgroundColor = .systemBackground
        autocorrectionType = .no
//        clearButtonMode = .whileEditing
        returnKeyType = .done
        
        placeholder = textInPlaceholder
        font = .boldSystemFont(ofSize: 15)
        
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold, scale: .default)
        let glass = UIImageView(image: UIImage(systemName: "magnifyingglass", withConfiguration: largeConfig))
        glass.frame = CGRect(x: 10, y: 0, width: 40, height: 40)
        glass.contentMode = .center
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 55, height: 40))
        paddingView.addSubview(glass)
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}
