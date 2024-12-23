//
//  Company.swift
//  AdventureThirst
//
//  Created by Evgeni Novik on 08.12.2024.
//

import Foundation

struct AppCompany: Codable {
    let name: String
    let description: String
    let photo: Data
    let address: String
    var activities: [String]
    let phoneNumber: String
    let openHours: String
    let userUid: String
    let bookedActivities: [String]
}

struct Company: Codable {
    let id: Int
    let name: String
    let description: String
    let address: String
    let activities: [String]
    let phoneNumber: String
    let openHours: String
    let userUid: String
    let bookedActivities: [String]
}

struct CompanyPayLoad: Codable {
    let name: String
    let description: String
    let address: String
    let activities: [String]
    let phoneNumber: String
    let openHours: String
    let userUid: String
    let bookedActivities: [String]
    
    enum CodingKeys: String, CodingKey {
        case name
        case description
        case address
        case activities
        case phoneNumber = "phone_number"
        case openHours = "open_hours"
        case userUid = "user_uid"
        case bookedActivities = "booked_activities"
    }
}
