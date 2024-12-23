//
//  BookedActivityForBusiness.swift
//  AdventureThirst
//
//  Created by Evgeni Novik on 23.12.2024.
//

import Foundation

struct BookedActivityForBusiness: Codable, Hashable {
    let id: Int
    let uid: String
    let userPhoto: String
    let userName: String
    let activityName: String
    let date: String
    let time: String
}


struct BookedActivityForBusinessPayLoad: Codable {
    let uid: String
    let userPhoto: String
    let userName: String
    let activityName: String
    let date: String
    let time: String
    
    
    enum CodingKeys: String, CodingKey {
        case uid
        case userPhoto = "user_photo"
        case userName = "user_name"
        case activityName = "activity_name"
        case date
        case time
    }
}
