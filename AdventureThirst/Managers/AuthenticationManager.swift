//
//  AuthenticationManager.swift
//  AdventureThirst
//
//  Created by Evgeni Novik on 03.11.2024.
//

import Foundation
import Supabase

struct AppUser {
    let uid: String
    let email: String?
}


final class AuthenticationManager {
    static let shared = AuthenticationManager()
    
    
    private init() {}
    
    
    let client = SupabaseClient(supabaseURL: URL(string: "https://nqfktvbassmzpsqxbeff.supabase.co")!, supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5xZmt0dmJhc3NtenBzcXhiZWZmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzI0NDg4MjYsImV4cCI6MjA0ODAyNDgyNn0.c6V4iVcJdWPCat-aAV8LkTYlqIhfLccDVttBa-j7sGQ")
    
    func getCurrentSession() async throws -> AppUser {
        let session = try await client.auth.session
        return AppUser(uid: session.user.id.uuidString, email: session.user.email)
        
    }
    
    func signInWithEmail(email: String, password: String) async throws -> AppUser {
        let session = try await client.auth.signIn(email: email, password: password)
        return AppUser(uid: session.user.id.uuidString, email: session.user.email)
    }
    
    func registerNewUserWithEmail(email: String, password: String) async throws -> AppUser {
        let regAuthResponse = try await client.auth.signUp(email: email, password: password)
        guard let session = regAuthResponse.session else {
            throw NSError()
        }
        return AppUser(uid: session.user.id.uuidString, email: session.user.email)
    }
    
    func signOut() async throws {
        try await client.auth.signOut()
    }
}
