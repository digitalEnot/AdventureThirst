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
