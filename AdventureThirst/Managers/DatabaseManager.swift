//
//  DatabaseManager.swift
//  AdventureThirst
//
//  Created by Evgeni Novik on 29.11.2024.
//

import Foundation
import Supabase

struct PersonalInfo: Codable {
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


class DatabaseManager {
    static let shared = DatabaseManager()
    private init() {}
    
    let client = SupabaseClient(supabaseURL: URL(string: "https://nqfktvbassmzpsqxbeff.supabase.co")!, supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5xZmt0dmJhc3NtenBzcXhiZWZmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzI0NDg4MjYsImV4cCI6MjA0ODAyNDgyNn0.c6V4iVcJdWPCat-aAV8LkTYlqIhfLccDVttBa-j7sGQ")
    
    func createToDoItem(item: PersonalInfoPayload) async throws {
        print("2")
        let response = try await client.from("personall").insert(item).execute()
        print("RESPONSE: \(response)")
    }
    
    func fetchToDoItems(for uid: String) async throws -> [PersonalInfo] {
        let response = try await client.from("personall").select().equals("user_uid", value: uid).execute()
        let data = response.data
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let todos = try decoder.decode([PersonalInfo].self, from: data)
        return todos
    }
    
//    func deleteToDoItem(id: Int) async throws {
//        let response = try await client.from("personal_info").delete().eq("id", value: id).execute()
//        print(response)
//        print(response.status)
//        print(response.data)
//    }
}

