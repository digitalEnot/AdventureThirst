//
//  BusinessActivitiesVC.swift
//  AdventureThirst
//
//  Created by Evgeni Novik on 08.12.2024.
//

import UIKit

enum Section {
    case main
}


class BusinessActivitiesVC: UIViewController {
    var company: AppCompany
    var activities: [AppActivity] = []
    var dataSourse: UICollectionViewDiffableDataSource<Section, AppActivity>!
    var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())

    
    init(company: AppCompany) {
        self.company = company
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavItems()
        configureCollectionView()
        configureDataSourse()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchActivities()
    }
    
    private func fetchActivities() {
        Task {
            let activities = try await DatabaseManager.shared.fetchActivities(for: self.company.name)
            var activ: [AppActivity] = []
            for activity in activities {
                let photoData = try await StorageManager.shared.fetchActivityPhoto(for: activity.uid)
                let appActivity = AppActivity(name: activity.name, location: activity.location, description: activity.description, price: activity.price, duration: activity.duration, activityCategory: activity.activityCategory, photo: UIImage(data: photoData)!, companyName: activity.companyName, uid: activity.uid, rating: activity.rating)
                activ.append(appActivity)
            }
            self.activities = activ
            updateData(on: self.activities)
        }
    }
    
    private func configureNavItems() {
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .done, target: self, action: #selector(plusPressed))
    }
    
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createOneColumnLayout(in: view))
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(ActivityCell.self, forCellWithReuseIdentifier: ActivityCell.reuseID)
    }
    
    
    private func configureDataSourse() {
        dataSourse = UICollectionViewDiffableDataSource<Section, AppActivity>(collectionView: collectionView, cellProvider: { collectionView, indexPath, activity in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ActivityCell.reuseID, for: indexPath) as! ActivityCell
            cell.set(activity: activity)
            return cell
        })
    }
    
    
    func updateData(on activities: [AppActivity]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, AppActivity>()
        snapshot.appendSections([.main])
        snapshot.appendItems(activities)
        DispatchQueue.main.async {
            self.dataSourse.apply(snapshot, animatingDifferences: true)
        }
    }
    
    
    @objc func plusPressed() {
        let destVC = AddActivityVC(company: company)
        destVC.delegate = self
        destVC.title = "Добавление активности"
        let navController = UINavigationController(rootViewController: destVC)
        navController.modalPresentationStyle = .popover
        navController.isModalInPresentation = true
        present(navController, animated: true)
    }
}

extension BusinessActivitiesVC: ActivityDelegate {
    func activityUploaded(activity: AppActivity) {
        company.activities.append(activity.name)
        activities.append(activity)
        updateData(on: self.activities)
    }
}

extension BusinessActivitiesVC: UICollectionViewDelegate {
    
}


