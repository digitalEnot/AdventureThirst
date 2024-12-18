//
//  Activity.swift
//  AdventureThirst
//
//  Created by Evgeni Novik on 17.12.2024.
//

import UIKit

struct AppActivity: Hashable {
    let name: String
    let location: String
    let description: String
    let price: Int
    let duration: Int
    let activityCategory: String
    let photo: UIImage
    let companyName: String
    let uid: String
    let rating: Double
}

struct Activity: Codable {
    let id: Int
    let name: String
    let location: String
    let description: String
    let price: Int
    let duration: Int
    let activityCategory: String
    let companyName: String
    let uid: String
    let rating: Double
}


struct ActivityPayLoad: Codable {
    let name: String
    let location: String
    let description: String
    let price: Int
    let duration: Int
    let activityCategory: String
    let companyName: String
    let uid: String
    let rating: Double
    
    enum CodingKeys: String, CodingKey {
        case name
        case location
        case description
        case price
        case duration
        case activityCategory = "activity_category"
        case companyName = "company_name"
        case uid
        case rating
    }
}
