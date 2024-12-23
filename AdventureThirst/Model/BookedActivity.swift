//
//  BookedActivity.swift
//  AdventureThirst
//
//  Created by Evgeni Novik on 23.12.2024.
//

import Foundation


struct BookedActivity: Codable, Hashable {
    let id: Int
    let uid: String
    let activityPhoto: String
    let activityName: String
    let activityPrice: Int
    let activityLocation: String
    let date: String
    let time: String
}


struct BookedActivityPayLoad: Codable {
    let uid: String
    let activityPhoto: String
    let activityName: String
    let activityPrice: Int
    let activityLocation: String
    let date: String
    let time: String
    
    
    enum CodingKeys: String, CodingKey {
        case uid
        case activityPhoto = "activity_photo"
        case activityName = "activity_name"
        case activityPrice = "activity_price"
        case activityLocation = "activity_location"
        case date
        case time
    }
}
