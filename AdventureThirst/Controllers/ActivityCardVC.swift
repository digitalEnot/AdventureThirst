//
//  ActivityInfoVC.swift
//  AdventureThirst
//
//  Created by Evgeni Novik on 19.12.2024.
//

import UIKit

class ActivityCardVC: UIViewController {
    
    let name = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 100))
    
    let activity: AppActivity

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)
        configure()
    }
    
    init(activity: AppActivity) {
        self.activity = activity
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(name)
        name.center = view.center
        name.text = activity.name
//        name.numberOfLines = 3
        name.textAlignment = .center
    }
    
    
}
