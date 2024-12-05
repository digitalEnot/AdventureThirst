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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(userData: UserData) {
        self.userData = userData
        super.init(nibName: nil, bundle: nil)
    }
    
    var userData: UserData?
    
//    func updateSettingsHeader(userData: UserData) {
//        self.userData = userData
//        let settingsHeader = SettingsHeaderView(frame:  CGRect(x: 0, y: 0, width: view.bounds.width, height: 150))
//        settingsHeader.setData(userData: userData)
//        settingsTable.tableHeaderView = settingsHeader
//    }
    
    let sectionTitles = ["Настройки", "История", ""]
    let buttonsInSettingsSection: [ButtonView] = [
        ButtonView(image: UIImage(systemName: "person.text.rectangle"), text: "Персональная информация", nextVC: nil),
        
        ButtonView(image: UIImage(systemName: "creditcard"), text: "Способ оплаты", nextVC: nil)]
    
    
    private let settingsTable: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.separatorStyle = .none
        table.register(SettingsTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    
    private func configureTableView() {
        view.addSubview(settingsTable)
        view.backgroundColor = .systemBackground
        settingsTable.delegate = self
        settingsTable.dataSource = self
        let settingsHeader = SettingsHeaderView(frame:  CGRect(x: 0, y: 0, width: view.bounds.width, height: 270))
        settingsHeader.delegate = self
        settingsHeader.setData(userData: userData ?? nil)
        settingsTable.tableHeaderView = settingsHeader
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        settingsTable.frame = view.bounds
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
                    destVC.delegate = self
                    let navController = UINavigationController(rootViewController: destVC)
                    navController.modalPresentationStyle = .popover
                    navController.isModalInPresentation = true
                    present(navController, animated: true)
                } catch {
                    print("error when logging out")
                }
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sectionTitles[section]
    }
}

#Preview() {
    SettingsVC(userData: UserData(uid: "1", email: "", name: "", lastName: "", middleName: "", photoData: Data()))
}

extension SettingsVC: SettingsInfoDelegate {
    func didLogInToTheSystem(userData: UserData) {
        let header = settingsTable.tableHeaderView as? SettingsHeaderView
        header?.setData(userData: userData)
    }
}

extension SettingsVC: AddBusinessDelegate {
    func showAddBusinessVC() {
        print("hello")
        let destVC = BusinessFormVC()
        destVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(destVC, animated: true)
        
    }
}
