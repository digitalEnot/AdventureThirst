//
//  BookedActivitiesVC.swift
//  AdventureThirst
//
//  Created by Evgeni Novik on 23.12.2024.
//

import UIKit

enum BookedActivitiesVCSection {
    case main
}

class BookedActivitiesVC: UIViewController {
    
    let userData: UserData
    var activiteis: [BookedActivity] = []
    var collectionView: UICollectionView!
    var dataSourse: UICollectionViewDiffableDataSource<BookedActivitiesVCSection, BookedActivity>!

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchActivities()
        configure()
        configureCollectionView()
        configureDataSourse()
    }
    
    init(userData: UserData) {
        self.userData = userData
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func fetchActivities() {
        Task {
            let userData = try await DatabaseManager.shared.fetchToDoItems(for: userData.uid)
            let activiteisIds = userData[0].bookedActivities
            var bookedActivities: [BookedActivity] = []
            for activityId in activiteisIds {
                let bookedActivity = try await DatabaseManager.shared.fetchBookedActivity(for: activityId)
                bookedActivities.append(bookedActivity[0])
            }
            self.activiteis = bookedActivities
            updateData(on: activiteis)
        }
    }
    

    private func configure() {
        view.backgroundColor = .systemBackground
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createOneRectangleColumnLayout(in: view))
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(BookedActivityCell.self, forCellWithReuseIdentifier: BookedActivityCell.reuseID)
    }
    
    func configureDataSourse() {
        dataSourse = UICollectionViewDiffableDataSource<BookedActivitiesVCSection, BookedActivity>(collectionView: collectionView, cellProvider: { collectionView, indexPath, bookedActivity in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookedActivityCell.reuseID, for: indexPath) as! BookedActivityCell
            cell.set(activity: bookedActivity)
            if indexPath.row != 0 {
                cell.addTopBorder(color: .gray, thickness: 1)
            }
            return cell
        })
    }
    
    func updateData(on bookedActivities: [BookedActivity]) {
        var snapshot = NSDiffableDataSourceSnapshot<BookedActivitiesVCSection, BookedActivity>()
        snapshot.appendSections([.main])
        snapshot.appendItems(bookedActivities)
        DispatchQueue.main.async {
            self.dataSourse.apply(snapshot, animatingDifferences: true)
        }
    }
}

extension BookedActivitiesVC: UICollectionViewDelegate {
    
}
