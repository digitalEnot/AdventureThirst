//
//  MainVC.swift
//  AdventureThirst
//
//  Created by Evgeni Novik on 08.11.2024.
//

import UIKit

enum FilterOption: String {
    case price = "По цене"
    case rating = "По рейтигу"
    case duration = "По продолжительности"
}

enum SecondSection {
    case main
}

class MainVC: UIViewController {
    var userData: UserData
    var activities: [AppActivity] = []
    var searchedActivities: [AppActivity] = []
    var isSearching = false
    var filteredActivities: [AppActivity] = []
    var dataSourse: UICollectionViewDiffableDataSource<SecondSection, AppActivity>!
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
        ATCategory(name: ActivityNames.wake, icon: UIImage(named: "wake")?.withRenderingMode(.alwaysTemplate)),
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
    

    init(userData: UserData) {
        self.userData = userData
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backButtonTitle = ""
        fetchActivities()
        configureCategoriesCollectionView()
        configureCollectionView()
        configureDataSourse()
        configure()
        configureConstants()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
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
        search.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        search.delegate = self
        
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
                let appActivity = AppActivity(name: activity.name, location: activity.location, description: activity.description, price: activity.price, duration: activity.duration, activityCategory: activity.activityCategory, photo: UIImage(data: photoData)!, companyName: activity.companyName, uid: activity.uid, rating: activity.rating)
                activ.append(appActivity)
            }
//            print(activ)
            self.activities = activ.shuffled()
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
        dataSourse = UICollectionViewDiffableDataSource<SecondSection, AppActivity>(collectionView: collectionView, cellProvider: { [weak self] collectionView, indexPath, activity in
            guard let self = self else { return UICollectionViewCell() }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ActivityCell.reuseID, for: indexPath) as! ActivityCell
            cell.set(activity: activity)
            if self.userData.likedActivities.contains(activity.uid) {
                cell.setIconToLiked()
                cell.isLiked(true)
            } else {
                cell.setIconToDefault()
                cell.isLiked(false)
            }
            cell.delegate = self
            return cell
        })
    }
    
    
    func updateData(on activities: [AppActivity]) {
        print("gg")
        var filteredActivities = activities
        if selectedCategory != nil {
            filteredActivities = activities.filter { $0.activityCategory == selectedCategory?.name?.rawValue }
        }
        filteredActivities = applyFilters(activities: filteredActivities, filterOption: selectedFilterOption)
        
        var snapshot = NSDiffableDataSourceSnapshot<SecondSection, AppActivity>()
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
    
    @objc func textFieldDidChange() {
        guard let filter = search.text, filter != "" else {
            searchedActivities.removeAll()
            isSearching = false
            updateData(on: activities)
            return
        }
        
        isSearching = true
        searchedActivities = activities.filter { $0.name.lowercased().contains(filter.lowercased())}
        updateData(on: searchedActivities)
    }
    
    func applyFilters(activities: [AppActivity], filterOption: FilterOption?) -> [AppActivity] {
        switch filterOption {
        case .price:
            let activities = activities.sorted { $0.price < $1.price }
            return activities
        case .rating:
            let activities = activities.sorted { $0.rating > $1.rating }
            return activities
        case .duration:
            let activities = activities.sorted { $0.duration > $1.duration }
            return activities
        case .none:
            return activities
        }
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
                let searchBarText = search.text ?? ""
                searchedActivities = activities.filter { $0.name.lowercased().contains(searchBarText.lowercased()) }
                updateData(on: isSearching ? searchedActivities : activities)
                return
            }
            choosenCell.image.tintColor = .black
            choosenCell.label.textColor = .black
            
            selectedCategory = categories[indexPath.row]
            let searchBarText = search.text ?? ""
            searchedActivities = activities.filter { $0.name.lowercased().contains(searchBarText.lowercased()) }
            updateData(on: isSearching ? searchedActivities : activities)
        } else {
            let activeArray = isSearching ? searchedActivities : activities
            
            //
            var filteredActivities = activeArray
            if selectedCategory != nil {
                filteredActivities = activeArray.filter { $0.activityCategory == selectedCategory?.name?.rawValue }
            }
            filteredActivities = applyFilters(activities: filteredActivities, filterOption: selectedFilterOption)
            //
            
            let activity = filteredActivities[indexPath.item]
            let destVC = ActivityCardVC(activity: activity, userData: userData)
            destVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(destVC, animated: true)
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
        
        self.selectedFilterOption = selectedFilterOption
        let searchBarText = search.text ?? ""
        searchedActivities = activities.filter { $0.name.lowercased().contains(searchBarText.lowercased()) }
        updateData(on: isSearching ? searchedActivities : activities)
    }
}


extension MainVC: ActivityCellDelegate {
    func DidPressedLike(id: String) {
        userData.likedActivities.append(id)
        Task {
            try await DatabaseManager.shared.updateLikes(likes: userData.likedActivities, for: userData.uid)
        }
    }
    
    func didPressedUnLike(id: String) {
        if let index = userData.likedActivities.firstIndex(of: id) {
            userData.likedActivities.remove(at: index)
            
            Task {
                try await DatabaseManager.shared.updateLikes(likes: userData.likedActivities, for: userData.uid)
                print("Like removed")
            }
        }
        
    }
}



extension MainVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
