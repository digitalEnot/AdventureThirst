//
//  AddActivityVC.swift
//  AdventureThirst
//
//  Created by Evgeni Novik on 16.12.2024.
//

import UIKit

struct ATCategory {
    let name: ActivityNames?
    let icon: UIImage?
}

enum ActivityNames: String {
    case ski = "Лыжи"
    case sup = "Sup-сёрфинг"
    case yacht = "Яхтинг"
    case paintball = "Пейнтбол"
    case skydiving = "Аэротруба"
    case snowboarding = "Сноубординг"
    case kiteserfing = "Кайтсёрфинг"
    case serfing = "Сёрфинг"
    case curling = "Кёрлинг"
    case climbing = "Скалолазание"
    case diving = "Дайвинг"
    case wake = "Вейксерфинг"
    case other = "Другое"
}

class AddActivityVC: UIViewController {
    
    let categories: [ATCategory] = [
        ATCategory(name: ActivityNames.ski, icon: UIImage(named: "ski")?.withRenderingMode(.alwaysTemplate)),
        ATCategory(name: ActivityNames.sup, icon: UIImage(systemName: "surfboard")),
        ATCategory(name: ActivityNames.yacht, icon: UIImage(named: "yacht")?.withRenderingMode(.alwaysTemplate)),
        ATCategory(name: ActivityNames.paintball, icon: UIImage(named: "paintball")?.withRenderingMode(.alwaysTemplate)),
        ATCategory(name: ActivityNames.skydiving, icon: UIImage(named: "skydiving")?.withRenderingMode(.alwaysTemplate)),
        ATCategory(name: ActivityNames.snowboarding, icon: UIImage(systemName: "figure.snowboarding")),
        ATCategory(name: ActivityNames.kiteserfing, icon: UIImage(named: "kitesurfing")?.withRenderingMode(.alwaysTemplate)),
        ATCategory(name: ActivityNames.serfing, icon: UIImage(systemName: "figure.surfing")),
        ATCategory(name: ActivityNames.curling, icon: UIImage(systemName: "figure.curling")),
        ATCategory(name: ActivityNames.climbing, icon: UIImage(named: "climbing")?.withRenderingMode(.alwaysTemplate)),
        ATCategory(name: ActivityNames.diving, icon: UIImage(named: "diving")?.withRenderingMode(.alwaysTemplate)),
        ATCategory(name: ActivityNames.wake, icon: UIImage(named: "wake")?.withRenderingMode(.alwaysTemplate)),
        ATCategory(name: ActivityNames.other, icon: UIImage(systemName: "oar.2.crossed"))
    ]
    let company: AppCompany
    var selectedCategory = ATCategory(name: nil, icon: nil)
    var categoriesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    let titleLabel = UILabel()
    let button = UIButton()
    
    weak var delegate: ActivityDelegate?
    
    init(company: AppCompany) {
        self.company = company
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        configure()
    }
    

    private func configureNavBar() {
        view.backgroundColor = .systemBackground
        let cancelButton = UIBarButtonItem(image: UIImage(systemName: "xmark.circle.fill"), style: .done, target: self, action: #selector(dismissVC))
        cancelButton.tintColor = .systemGray3
        navigationItem.rightBarButtonItem = cancelButton
        navigationItem.backButtonTitle = ""
    }
    
    private func configure() {
        categoriesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UIHelper.createTwoColumnLayout(in: view))
        categoriesCollectionView.register(RegistrationActivityCategoryCell.self, forCellWithReuseIdentifier: "RegistrationActivityCategoryCell")
        view.addSubview(categoriesCollectionView)
        
        categoriesCollectionView.delegate = self
        categoriesCollectionView.dataSource = self
        categoriesCollectionView.backgroundColor = .systemBackground
        categoriesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(titleLabel)
        titleLabel.text = "Выберете вид активности"
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        var buttonConfiguration = UIButton.Configuration.filled()
        buttonConfiguration.title = "Далее"
        buttonConfiguration.cornerStyle = .medium
        buttonConfiguration.baseBackgroundColor = .label
        buttonConfiguration.baseForegroundColor = .systemBackground
        buttonConfiguration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.systemFont(ofSize: 15, weight: .bold)
            return outgoing
        }
        button.isEnabled = false
        button.configuration = buttonConfiguration
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            categoriesCollectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            categoriesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            categoriesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            categoriesCollectionView.bottomAnchor.constraint(equalTo: button.topAnchor, constant: 10),

            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            button.heightAnchor.constraint(equalToConstant: 52),
        ])
    }
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }
    
    @objc func buttonPressed() {
        let path = ActivityInfoVC(selectedCategory: selectedCategory, company: company)
        path.delegate = delegate
        path.title = "Добавление активности"
        navigationController?.pushViewController(path, animated: true)
        
    }
}

extension AddActivityVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = categoriesCollectionView.dequeueReusableCell(withReuseIdentifier: "RegistrationActivityCategoryCell", for: indexPath) as? RegistrationActivityCategoryCell else { return UICollectionViewCell() }
        cell.layer.cornerRadius = 10
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.set(icon: categories[indexPath.row].icon, name: categories[indexPath.row].name?.rawValue)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        for cell in collectionView.visibleCells {
            guard let cell = cell as? RegistrationActivityCategoryCell else { return }
            cell.layer.borderColor = UIColor.gray.cgColor
            cell.image.tintColor = .gray
        }
        guard let choocenCell = collectionView.cellForItem(at: indexPath) as? RegistrationActivityCategoryCell else { return }
        choocenCell.layer.borderColor = UIColor.black.cgColor
        choocenCell.layer.borderWidth = 2
        choocenCell.image.tintColor = .black
        
        button.isEnabled = true
        selectedCategory = categories[indexPath.row]
    }
}
