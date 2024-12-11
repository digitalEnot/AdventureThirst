//
//  BusinessActivitiesVC.swift
//  AdventureThirst
//
//  Created by Evgeni Novik on 08.12.2024.
//

import UIKit

protocol BusinessActivitiesDelegate: AnyObject {
    func popVC()
}

class BusinessActivitiesVC: UIViewController {
    
    let button = UIButton(frame: CGRect(origin: CGPoint(x: 100, y: 200), size: CGSize(width: 100, height: 40)))
    let company: AppCompany
    weak var delegate: BusinessActivitiesDelegate?
    
    init(company: AppCompany) {
        self.company = company
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        print(company.name)
    }
    

    private func configure() {
        view.addSubview(button)
        button.addTarget(self, action: #selector(pressed), for: .touchUpInside)
        button.backgroundColor = .red
    }
                          
    @objc func pressed() {
        delegate?.popVC()
    }
}

#Preview() {
    BusinessActivitiesVC(company: AppCompany(name: "", description: "", photo: Data(), address: "", activities: [], phoneNumber: "", openHours: "", userUid: ""))
}
