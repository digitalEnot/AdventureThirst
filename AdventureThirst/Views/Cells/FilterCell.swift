//
//  FilterCell.swift
//  AdventureThirst
//
//  Created by Evgeni Novik on 18.12.2024.
//

import UIKit

class FilterCell: UITableViewCell {
    static let reuseID = "FilterCell"
    
    let titleFilter = UILabel()
    let descriptionFilter = UILabel()
    let stack = UIStackView()
    
    let filterView = UIView()
    let filterImage = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(label: String, description: String) {
        titleFilter.text = label
        descriptionFilter.text = description
    }
    
    func setSelected() {
        let configuration = UIImage.SymbolConfiguration(pointSize: 15, weight: .medium)
        filterImage.image = UIImage(systemName: "checkmark", withConfiguration: configuration)
        filterView.backgroundColor = .black
    }
    
    func setDefault() {
        filterImage.image = nil
        filterView.backgroundColor = .gray.withAlphaComponent(0.2)
    }
    
    private func configure() {
        addSubview(stack)
        addSubview(filterView)
        
        filterView.addSubview(filterImage)
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.addArrangedSubview(titleFilter)
        stack.addArrangedSubview(descriptionFilter)
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = 5
        
        filterView.translatesAutoresizingMaskIntoConstraints = false
        filterImage.translatesAutoresizingMaskIntoConstraints = false
        
        titleFilter.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        
        descriptionFilter.font = UIFont.systemFont(ofSize: 14)
        descriptionFilter.textColor = .gray
        
        filterView.backgroundColor = .gray.withAlphaComponent(0.2)
        filterView.layer.cornerRadius = 12.5
        filterView.clipsToBounds = true
        
        filterImage.tintColor = UIColor.white
        filterImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            filterView.centerYAnchor.constraint(equalTo: stack.centerYAnchor),
            filterView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            filterView.heightAnchor.constraint(equalToConstant: 25),
            filterView.widthAnchor.constraint(equalToConstant: 25),
            
            filterImage.centerYAnchor.constraint(equalTo: filterView.centerYAnchor),
            filterImage.centerXAnchor.constraint(equalTo: filterView.centerXAnchor),
        ])
    }
}

#Preview() {
    FilterCell()
}
