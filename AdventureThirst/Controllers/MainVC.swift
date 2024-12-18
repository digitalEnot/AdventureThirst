//
//  MainVC.swift
//  AdventureThirst
//
//  Created by Evgeni Novik on 08.11.2024.
//

import UIKit

enum FilterOption: String {
    case price = "По цене"
    case raiting = "По рейтигу"
    case duration = "По продолжительности"
}

enum SecondSection {
    case main
}

class MainVC: UIViewController {
    var activities: [AppActivity] = []
    var filteredActivities: [AppActivity] = []
    var dataSourse: UICollectionViewDiffableDataSource<Section, AppActivity>!
    var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    let search = SearchBar(textInPlaceholder: "Поиск приключений")
    let filters = UIView()
    let imageForFilters = UIImageView()
    
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
        ATCategory(name: ActivityNames.other, icon: UIImage(systemName: "oar.2.crossed"))
    ]
    var selectedCategory: ATCategory? = nil
    var selectedFilterOption: FilterOption? = nil
    private var categoriesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 75, height: 100)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ActivityCategoryCell.self, forCellWithReuseIdentifier: "ActivityCategoryCell")
        return collectionView
    }()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        configureCategoriesCollectionView()
        configureCollectionView()
        configureDataSourse()
        configure()
        configureConstants()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchActivities()
    }
    
    private func configureCategoriesCollectionView() {
        view.addSubview(categoriesCollectionView)
        categoriesCollectionView.delegate = self
        categoriesCollectionView.dataSource = self
        categoriesCollectionView.backgroundColor = .systemBackground
        categoriesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        categoriesCollectionView.showsHorizontalScrollIndicator = false
    }
    
    private func configure() {
        view.addSubview(search)
        view.addSubview(filters)
        filters.translatesAutoresizingMaskIntoConstraints = false
        filters.layer.cornerRadius = 25
        filters.layer.borderWidth = 1
        filters.layer.borderColor = UIColor(.gray).cgColor
        filters.addSubview(imageForFilters)
        imageForFilters.translatesAutoresizingMaskIntoConstraints = false
        imageForFilters.image = UIImage(systemName: "slider.horizontal.3")
        imageForFilters.tintColor = .black
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(filterTapped))
        filters.addGestureRecognizer(gesture)
    }
    
    private func configureConstants() {
        NSLayoutConstraint.activate([
            search.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            search.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            search.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -90),
            search.heightAnchor.constraint(equalToConstant: 60),
            
            categoriesCollectionView.topAnchor.constraint(equalTo: search.bottomAnchor, constant: 20),
            categoriesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            categoriesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            categoriesCollectionView.heightAnchor.constraint(equalToConstant: 100),
            
            collectionView.topAnchor.constraint(equalTo: categoriesCollectionView.bottomAnchor, constant: -20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            filters.centerYAnchor.constraint(equalTo: search.centerYAnchor),
            filters.leadingAnchor.constraint(equalTo: search.trailingAnchor, constant: 20),
            filters.heightAnchor.constraint(equalToConstant: 50),
            filters.widthAnchor.constraint(equalToConstant: 50),
            
            imageForFilters.centerXAnchor.constraint(equalTo: filters.centerXAnchor),
            imageForFilters.centerYAnchor.constraint(equalTo: filters.centerYAnchor),

        ])
    }
    
    private func fetchActivities() {
        Task {
            let activities = try await DatabaseManager.shared.fetchAllActivities()
            var activ: [AppActivity] = []
            for activity in activities {
                let photoData = try await StorageManager.shared.fetchActivityPhoto(for: activity.uid)
                let appActivity = AppActivity(name: activity.name, location: activity.location, description: activity.description, price: activity.price, duration: activity.duration, activityCategory: activity.activityCategory, photo: UIImage(data: photoData)!, companyName: activity.companyName, uid: activity.uid)
                activ.append(appActivity)
            }
            print(activ)
            self.activities = activ
            updateData(on: self.activities)
        }
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createOneColumnLayout(in: view))
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(ActivityCell.self, forCellWithReuseIdentifier: ActivityCell.reuseID)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    private func configureDataSourse() {
        dataSourse = UICollectionViewDiffableDataSource<Section, AppActivity>(collectionView: collectionView, cellProvider: { collectionView, indexPath, activity in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ActivityCell.reuseID, for: indexPath) as! ActivityCell
            cell.set(activity: activity)
            return cell
        })
    }
    
    
    func updateData(on activities: [AppActivity]) {
        var filteredActivities = activities
        if selectedCategory != nil {
            filteredActivities = activities.filter { $0.activityCategory == selectedCategory?.name?.rawValue }
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, AppActivity>()
        snapshot.appendSections([.main])
        snapshot.appendItems(filteredActivities)
        DispatchQueue.main.async {
            self.dataSourse.apply(snapshot, animatingDifferences: true)
        }
    }
    
    @objc func filterTapped() {
        let filterVC = FiltersVC(selectedFilterOption: selectedFilterOption)
        filterVC.delegate = self
        filterVC.modalPresentationStyle = .pageSheet
        
        if let sheet = filterVC.sheetPresentationController {
            sheet.detents = [.custom { _ in 366}]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersEdgeAttachedInCompactHeight = true
            sheet.prefersGrabberVisible = true
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
        }
        present(filterVC, animated: true, completion: nil)
    }
}


extension MainVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = categoriesCollectionView.dequeueReusableCell(withReuseIdentifier: "ActivityCategoryCell", for: indexPath) as? ActivityCategoryCell else { return UICollectionViewCell() }
        cell.set(icon: categories[indexPath.row].icon, name: categories[indexPath.row].name?.rawValue)
        if selectedCategory?.name?.rawValue == categories[indexPath.row].name?.rawValue {
            cell.image.tintColor = .black
            cell.label.textColor = .black
        } else {
            cell.image.tintColor = .gray
            cell.label.textColor = .gray
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoriesCollectionView {
            for cell in collectionView.visibleCells {
                guard let cell = cell as? ActivityCategoryCell else { return }
                cell.image.tintColor = .gray
                cell.label.textColor = .gray
            }
            guard let choosenCell = collectionView.cellForItem(at: indexPath) as? ActivityCategoryCell else { return }
            if categories[indexPath.row].name?.rawValue == selectedCategory?.name?.rawValue {
                selectedCategory = nil
                updateData(on: activities)
                return
            }
            choosenCell.image.tintColor = .black
            choosenCell.label.textColor = .black
            
            selectedCategory = categories[indexPath.row]
            updateData(on: activities)
        } else {
            
        }
    }
}

extension MainVC: FilterDelegate {
    func filterWasSelected(selectedFilterOption: FilterOption?) {
        if selectedFilterOption != nil {
            filters.backgroundColor = .black.withAlphaComponent(0.8)
            imageForFilters.tintColor = .white
        } else {
            filters.backgroundColor = .white
            imageForFilters.tintColor = .black
        }
        
        
        print(selectedFilterOption?.rawValue)
        self.selectedFilterOption = selectedFilterOption
    }
}
