//
//  ATUser.swift
//  AdventureThirst
//
//  Created by Evgeni Novik on 26.11.2024.
//

import Foundation

struct ATUser: Codable {
    let uid: String
    let name: String
    let lastName: String
    let middleName: String?
    let photoID: String
}
