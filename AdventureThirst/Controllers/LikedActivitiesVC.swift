//
//  LikedActivitiesVC.swift
//  AdventureThirst
//
//  Created by Evgeni Novik on 21.12.2024.
//

import UIKit

enum Ssection {
    case main
}

class LikedActivitiesVC: UIViewController {
    
    var userData: UserData
    var likedActivities: [AppActivity] = []
    var collectionView: UICollectionView!
    var dataSourse: UICollectionViewDiffableDataSource<Section, AppActivity>!
    
    init(userData: UserData?) {
        self.userData = userData ?? UserData(uid: "", email: "", name: "", lastName: "", middleName: "", photoData: Data(), likedActivities: [])
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchLikes()
        configure()
        configureCollectionView()
        configureDataSourse()
    }
    
    private func fetchLikes() {
        Task {
            let userData = try await DatabaseManager.shared.fetchToDoItems(for: userData.uid)
            for activityId in userData[0].likedActivities {
                let ativ = try await DatabaseManager.shared.fetchActvity(for: activityId)
                let activity = ativ[0]
                let photo = try await StorageManager.shared.fetchActivityPhoto(for: activityId)
                let appActivity = AppActivity(name: activity.name, location: activity.location, description: activity.description, price: activity.price, duration: activity.duration, activityCategory: activity.activityCategory, photo: UIImage(data: photo)!, companyName: activity.companyName, uid: activity.uid, rating: activity.rating)
                likedActivities.append(appActivity)
            }
            updateData(on: likedActivities)
        }
    }
    
    private func configure() {
        view.backgroundColor = .systemBackground
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createTwoSquareColumnLayout(in: view))
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(LikedActivitiesCell.self, forCellWithReuseIdentifier: LikedActivitiesCell.reuseID)
    }
    
    func configureDataSourse() {
        dataSourse = UICollectionViewDiffableDataSource<Section, AppActivity>(collectionView: collectionView, cellProvider: { collectionView, indexPath, activity in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LikedActivitiesCell.reuseID, for: indexPath) as! LikedActivitiesCell
            cell.set(activity: activity)
            cell.isLiked(true)
            cell.setIconToLiked()
            cell.delegate = self
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
    
}

extension LikedActivitiesVC: UICollectionViewDelegate {
    
}

extension LikedActivitiesVC: UnlikeDelegate {
    func didPressedUnLike(activity: AppActivity) {
        if let index = likedActivities.firstIndex(of: activity) {
            likedActivities.remove(at: index)
            if let index2 = userData.likedActivities.firstIndex(of: activity.uid) {
                userData.likedActivities.remove(at: index2)
            }
            updateData(on: likedActivities)
            
            
            Task {
                try await DatabaseManager.shared.updateLikes(likes: userData.likedActivities, for: userData.uid)
                print("Like removed")
            }
        }
    }
}
