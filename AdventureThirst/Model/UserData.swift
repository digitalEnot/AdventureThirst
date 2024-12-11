//
//  ATUser.swift
//  AdventureThirst
//
//  Created by Evgeni Novik on 26.11.2024.
//

import Foundation

struct UserData: Codable {
    let uid: String
    let email: String
    let name: String
    let lastName: String
    let middleName: String?
    let photoData: Data
}


struct userData: Codable {
    let id: Int
    let createdAt: String
    let name: String
    let lastName: String
    let middleName: String
    let userUid: String
}

struct PersonalInfoPayload: Codable {
    let name: String
    let lastName: String
    let middleName: String
    let userUid: String
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case lastName = "last_name"
        case middleName = "middle_name"
        case userUid = "user_uid"
    }
}
