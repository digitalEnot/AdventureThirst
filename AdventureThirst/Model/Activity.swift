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
    let price: String
    let duration: String
    let activityCategory: String
    let photo: UIImage
    let companyName: String
    let uid: String
}

struct Activity: Codable {
    let id: Int
    let name: String
    let location: String
    let description: String
    let price: String
    let duration: String
    let activityCategory: String
    let companyName: String
    let uid: String
}


struct ActivityPayLoad: Codable {
    let name: String
    let location: String
    let description: String
    let price: String
    let duration: String
    let activityCategory: String
    let companyName: String
    let uid: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case location
        case description
        case price
        case duration
        case activityCategory = "activity_category"
        case companyName = "company_name"
        case uid
    }
}
