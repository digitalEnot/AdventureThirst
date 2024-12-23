//
//  BusinessSettigsVC.swift
//  AdventureThirst
//
//  Created by Evgeni Novik on 12.12.2024.
//

import UIKit

protocol BusinessActivitiesDelegate: AnyObject {
    func popVC()
}

class BusinessSettigsVC: UIViewController {
    let company: AppCompany
    let sectionTitles = ["Информация", ""]
    let buttonsInInfoSection: [ButtonView] = [
        ButtonView(image: UIImage(systemName: "person.text.rectangle"), text: "Информация о компании", nextVC: nil),
        ButtonView(image: UIImage(systemName: "figure.badminton.circle"), text: "Записи", nextVC: nil)
    ]
    
    private let settingsTable: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.separatorStyle = .none
        table.register(SettingsTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.identifier)
        return table
    }()
    
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
        view.backgroundColor = .systemBackground
        configure()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        settingsTable.frame = view.bounds
    }
    
    
    private func configure() {
        view.addSubview(settingsTable)
        view.backgroundColor = .systemBackground
        settingsTable.delegate = self
        settingsTable.dataSource = self
        let settingsHeader = BusinessSettingsHeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 160), company: company)
        settingsTable.tableHeaderView = settingsHeader
    }
}

extension BusinessSettigsVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        sectionTitles.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            buttonsInInfoSection.count
        } else {
            1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.identifier, for: indexPath) as? SettingsTableViewCell else {
                return UITableViewCell()
            }
            cell.setCell(text: "Выйти из бизнесс профиля", image: nil, textColor: .red, hasArrow: false)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.identifier, for: indexPath) as? SettingsTableViewCell else {
                return UITableViewCell()
            }
            cell.setCell(text: buttonsInInfoSection[indexPath.row].text, image: buttonsInInfoSection[indexPath.row].image, textColor: .black)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            if indexPath.row == 0 {
//                let destVC = BookedActivitiesVC(userData: userData!)
//                navigationController?.pushViewController(destVC, animated: true)
            } else if indexPath.row == 1 {
                let destVC = BookedActivityForBusinessVC(company: company)
                navigationController?.pushViewController(destVC, animated: true)
            }
        } else {
            delegate?.popVC()
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
}
