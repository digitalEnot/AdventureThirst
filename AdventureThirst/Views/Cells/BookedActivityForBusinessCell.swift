//
//  BookedActivityForBusinessCell.swift
//  AdventureThirst
//
//  Created by Evgeni Novik on 23.12.2024.
//

import UIKit

class BookedActivityForBusinessCell: UICollectionViewCell {
    
    
    static let reuseID = "BookedActivityForBusinessCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(activity: BookedActivityForBusiness) {
        print(activity.activityName)
    }
    
}
