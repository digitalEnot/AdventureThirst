//
//  BookedActivityForBusinessVC.swift
//  AdventureThirst
//
//  Created by Evgeni Novik on 23.12.2024.
//

import UIKit

enum BookedActivityForBusinessVCSection {
    case main
}

class BookedActivityForBusinessVC: UIViewController {

    let company: AppCompany
    var bookings: [BookedActivityForBusiness] = []
    var collectionView: UICollectionView!
    var dataSourse: UICollectionViewDiffableDataSource<BookedActivityForBusinessVCSection, BookedActivityForBusiness>!

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchBookings()
        configure()
        configureCollectionView()
        configureDataSourse()
    }
    
    init(company: AppCompany) {
        self.company = company
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func fetchBookings() {
        Task {
            let company = try await DatabaseManager.shared.fetchCompanyWithName(for: company.name)
            let bookingsIds = company[0].bookedActivities
            var bookings: [BookedActivityForBusiness] = []
            for bookingId in bookingsIds {
                let booking = try await DatabaseManager.shared.fetchBookedActivityForBusiness(for: bookingId)
                bookings.append(booking[0])
            }
            self.bookings = bookings
            updateData(on: bookings)
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
        collectionView.register(BookedActivityForBusinessCell.self, forCellWithReuseIdentifier: BookedActivityForBusinessCell.reuseID)
    }

    func configureDataSourse() {
        dataSourse = UICollectionViewDiffableDataSource<BookedActivityForBusinessVCSection, BookedActivityForBusiness>(collectionView: collectionView, cellProvider: { collectionView, indexPath, bookedActivity in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookedActivityForBusinessCell.reuseID, for: indexPath) as! BookedActivityForBusinessCell
            cell.set(activity: bookedActivity)
            return cell
        })
    }
    
    func updateData(on bookedActivityForBusiness: [BookedActivityForBusiness]) {
        var snapshot = NSDiffableDataSourceSnapshot<BookedActivityForBusinessVCSection, BookedActivityForBusiness>()
        snapshot.appendSections([.main])
        snapshot.appendItems(bookedActivityForBusiness)
        DispatchQueue.main.async {
            self.dataSourse.apply(snapshot, animatingDifferences: true)
        }
    }
}

extension BookedActivityForBusinessVC: UICollectionViewDelegate {
    
}
