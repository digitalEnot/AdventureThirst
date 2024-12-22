//
//  DatabaseManager.swift
//  AdventureThirst
//
//  Created by Evgeni Novik on 29.11.2024.
//

import Foundation
import Supabase



class DatabaseManager {
    static let shared = DatabaseManager()
    private init() {}
    
    let client = SupabaseClient(supabaseURL: URL(string: "https://nqfktvbassmzpsqxbeff.supabase.co")!, supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5xZmt0dmJhc3NtenBzcXhiZWZmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzI0NDg4MjYsImV4cCI6MjA0ODAyNDgyNn0.c6V4iVcJdWPCat-aAV8LkTYlqIhfLccDVttBa-j7sGQ")
    
    func createToDoItem(item: PersonalInfoPayload) async throws {
        let _ = try await client.from("personall").insert(item).execute()
    }
    
    func fetchToDoItems(for uid: String) async throws -> [userData] {
        let response = try await client.from("personall").select().equals("user_uid", value: uid).execute()
        let data = response.data
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let todos = try decoder.decode([userData].self, from: data)
        return todos
    }
    
    func createCompany(item: CompanyPayLoad) async throws {
        let _ = try await client.from("company").insert(item).execute()
    }
    
    func fetchCompany(for uid: String) async throws -> [Company] {
        let response = try await client.from("company").select().equals("user_uid", value: uid).execute()
        let data = response.data
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            let company = try decoder.decode([Company].self, from: data)
            return company
        } catch{
            throw error
        }
    }
    
    func createActivity(item: ActivityPayLoad, company: CompanyPayLoad) async throws {
        let _ = try await client.from("activities").insert(item).execute()
        let _ = try await client.from("company").update(["activities": company.activities]).eq("name", value: company.name).execute()
    }
    
    func fetchActivities(for companyName: String) async throws -> [Activity] {
        let response = try await client.from("activities").select().equals("company_name", value: companyName).execute()
        let data = response.data
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            let activities = try decoder.decode([Activity].self, from: data)
            return activities
        } catch{
            throw error
        }
    }
    
    func fetchAllActivities() async throws -> [Activity] {
        let response = try await client.from("activities").select().execute()
        let data = response.data
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            let activities = try decoder.decode([Activity].self, from: data)
            return activities
        } catch{
            throw error
        }
    }
    
    func updateLikes(likes: [String], for uid: String) async throws {
       let _ = try await client.from("personall").update(["liked_activities" : likes]).eq("user_uid", value: uid).execute()
    }
    
    func fetchActvity(for uid: String) async throws -> [Activity] {
        let response = try await client.from("activities").select().equals("uid", value: uid).execute()
        let data = response.data
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            let activities = try decoder.decode([Activity].self, from: data)
            return activities
        } catch{
            throw error
        }
    }
    
    func fetchCompanyWithName(for name: String) async throws -> [Company] {
        let response = try await client.from("company").select().equals("name", value: name).execute()
        let data = response.data
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            let company = try decoder.decode([Company].self, from: data)
            return company
        } catch{
            throw error
        }
    }
    
    
    
    
    
    
    
    func createBookedActivity(item: BookedActivityPayLoad) async throws {
        let _ = try await client.from("booked_activity").insert(item).execute()
    }
    
    func fetchBookedActivity(for uid: String) async throws -> [BookedActivity] {
        let response = try await client.from("booked_activity").select().equals("uid", value: uid).execute()
        let data = response.data
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            let bookedActivity = try decoder.decode([BookedActivity].self, from: data)
            return bookedActivity
        } catch{
            throw error
        }
    }
    
    func updateBookedActivities(bookedActivities: [String], for uid: String) async throws {
        let _ = try await client.from("personall").update(["booked_activities" : bookedActivities]).eq("user_uid", value: uid).execute()
    }
    
    
    
    
    func createBookedActivityForBusiness(item: BookedActivityForBusinessPayLoad) async throws {
        let _ = try await client.from("booked_activity_for_business").insert(item).execute()
    }
    
    func fetchBookedActivityForBusiness(for uid: String) async throws -> [BookedActivityForBusiness] {
        let response = try await client.from("booked_activity_for_business").select().equals("uid", value: uid).execute()
        let data = response.data
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            let bookedActivityForBusiness = try decoder.decode([BookedActivityForBusiness].self, from: data)
            return bookedActivityForBusiness
        } catch{
            throw error
        }
    }
    
    func updateBookedActivityForBusiness(bookedActivityForBusiness: [String], for name: String) async throws {
        let _ = try await client.from("company").update(["booked_activities" : bookedActivityForBusiness]).eq("name", value: name).execute()
    }
}

