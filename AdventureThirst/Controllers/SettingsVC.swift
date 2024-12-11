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
    var userData: UserData?
    var companies: [AppCompany]
    var numberOfSections = 0
    let sectionTitles = ["Настройки", "История", ""]
    let buttonsInSettingsSection: [ButtonView] = [
        ButtonView(image: UIImage(systemName: "person.text.rectangle"), text: "Персональная информация", nextVC: nil),
        ButtonView(image: UIImage(systemName: "creditcard"), text: "Способ оплаты", nextVC: nil)]
    
    private let settingsTable: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.separatorStyle = .none
        table.register(SettingsTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.identifier)
        table.register(CompanyCell.self, forCellReuseIdentifier: CompanyCell.reuseID)
        return table
    }()
    
    
    init(userData: UserData, companies: [AppCompany]) {
        self.userData = userData
        self.companies = companies
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        numberOfSections = companies.count + sectionTitles.count
        configureTableView()
    }
    
    
    private func configureTableView() {
        view.addSubview(settingsTable)
        view.backgroundColor = .systemBackground
        settingsTable.delegate = self
        settingsTable.dataSource = self
        let settingsHeader = SettingsHeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 300), companies: companies)
        if companies.count > 0 {
            settingsHeader.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 180)
            settingsHeader.updateCompanies(with: 1)
        }
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
        if companies.count > 0 {
            numberOfSections + 1
        } else {
            numberOfSections
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if companies.count > 0 {
            if section == numberOfSections + 1 - 3 {
                return buttonsInSettingsSection.count
            } else if section == numberOfSections  + 1 - 2 {
                return 2
            } else {
                return 1
            }
        } else {
            if section == numberOfSections - 3 {
                return buttonsInSettingsSection.count
            } else if section == numberOfSections - 2 {
                return 2
            } else {
                return 1
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let numOfSec = companies.count > 0 ? companies.count + sectionTitles.count + 1 : companies.count + sectionTitles.count
        
        if indexPath.section <= companies.count - 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CompanyCell.reuseID, for: indexPath) as? CompanyCell else {
                return UITableViewCell()
            }
            let company = companies[indexPath.section]
            let photo = UIImage(data: company.photo)!
            cell.set(companyName: company.name, address: company.address, workingHours: company.openHours, phoneNumber: company.phoneNumber, photo: photo)
            return cell
        } else if indexPath.section == companies.count && companies.count > 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.identifier, for: indexPath) as? SettingsTableViewCell else {
                return UITableViewCell()
            }
            cell.setCell(text: "Добавить компанию", image: nil, textColor: .blue, hasArrow: false)
            return cell
        } else if indexPath.section == numOfSec - 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.identifier, for: indexPath) as? SettingsTableViewCell else {
                return UITableViewCell()
            }
            cell.setCell(text: "Выйти из аккаунта", image: nil, textColor: .red, hasArrow: false)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.identifier, for: indexPath) as? SettingsTableViewCell else {
                return UITableViewCell()
            }
            cell.setCell(text: buttonsInSettingsSection[indexPath.row].text, image: buttonsInSettingsSection[indexPath.row].image, textColor: .black)
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let numOfSec = companies.count > 0 ? companies.count + sectionTitles.count + 1 : companies.count + sectionTitles.count
        if indexPath.section == numOfSec - 1 {
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
        } else if indexPath.section == companies.count && companies.count > 0 {
            showAddBusinessVC()
        
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if companies.count > 0 {
            if section == 0 {
                return "Мои компании"
            } else if section >= companies.count + 1 {
                return sectionTitles[section - companies.count - 1]
            } else {
                return ""
            }
        } else {
            return sectionTitles[section]
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section > 0 && section < companies.count + 1 {
            return 0
        } else {
            return 30
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        0
    }
}


extension SettingsVC: SettingsInfoDelegate {
    func didLogInToTheSystem(userData: UserData, companies: [AppCompany]) {
        numberOfSections = companies.count + sectionTitles.count
        self.companies = companies
        settingsTable.reloadData()
        if companies.count > 0 {
            let settingsHeader = SettingsHeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 180), companies: companies)
            settingsHeader.updateCompanies(with: 1)
            settingsHeader.setData(userData: userData)
            settingsTable.tableHeaderView = settingsHeader
        } else {
            let settingsHeader = SettingsHeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 300), companies: companies)
            settingsHeader.setData(userData: userData)
            settingsHeader.delegate = self
            settingsTable.tableHeaderView = settingsHeader
        }
    }
}


extension SettingsVC: AddBusinessDelegate {
    func showAddBusinessVC() {
        let destVC = BusinessFormVC()
        destVC.title = "Регистрация компании"
        destVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(destVC, animated: true)
    }
}


#Preview() {
    SettingsVC(userData: UserData(uid: "1", email: "", name: "", lastName: "", middleName: "", photoData: Data()), companies: [])
}
