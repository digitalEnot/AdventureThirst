//
//  SettingsVC.swift
//  AdventureThirst
//
//  Created by Evgeni Novik on 08.11.2024.
//

import UIKit

struct ButtonView {
    let image: UIImage?
    let text: String
    let nextVC: UIViewController?
}

class SettingsVC: UIViewController {
    
    let sectionTitles = ["Настройки", "История", ""]
    let buttonsInSettingsSection: [ButtonView] = [
        ButtonView(image: UIImage(systemName: "person.text.rectangle"), text: "Персональная информация", nextVC: nil),
        
        ButtonView(image: UIImage(systemName: "creditcard"), text: "Способ оплаты", nextVC: nil)]
    
    
    private let homeFeedTable: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.separatorStyle = .none
        table.register(SettingsTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.identifier)
//        table.backgroundColor = .blue
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    
    private func configureTableView() {
        view.addSubview(homeFeedTable)
        view.backgroundColor = .systemBackground
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
//        homeFeedTable.tableHeaderView =
        
        
//        settingsTableView.translatesAutoresizingMaskIntoConstraints = false
//        
//        NSLayoutConstraint.activate([
//            settingsTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
//            settingsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            settingsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            settingsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//        ])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
    }
}

extension SettingsVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return buttonsInSettingsSection.count
        } else if section == 1 {
            return 2
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.identifier, for: indexPath) as? SettingsTableViewCell else {
            return UITableViewCell()
        }
        
        if indexPath.section == 0 {
            cell.setCell(text: buttonsInSettingsSection[indexPath.row].text, image: buttonsInSettingsSection[indexPath.row].image, textColor: .black)
        }
        
        if indexPath.section == 1 {
            cell.setCell(text: buttonsInSettingsSection[indexPath.row].text, image: buttonsInSettingsSection[indexPath.row].image, textColor: .black)
        }
        
        if indexPath.section == 2 {
            cell.setCell(text: "Выйти из аккаунта", image: nil, textColor: .red, hasArrow: false)
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            Task {
                do {
                    try await AuthenticationManager.shared.signOut()
                    let destVC = SignUpOrLogInVC(isModal: true)
                    let navController = UINavigationController(rootViewController: destVC)
                    navController.modalPresentationStyle = .popover
                    navController.isModalInPresentation = true
                    present(navController, animated: true)
                } catch {
                    print("error when logging out")
                }
            }
        }
        
        if indexPath.section == 0 {
            navigationController?.pushViewController(SignUpVC(isModal: false), animated: true)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sectionTitles[section]
    }
}

#Preview() {
    SettingsVC()
}
