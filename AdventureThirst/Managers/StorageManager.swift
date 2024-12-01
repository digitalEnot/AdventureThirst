//
//  StorageManager.swift
//  gg
//
//  Created by Evgeni Novik on 25.11.2024.
//
import Foundation
import Supabase


class StorageManager {
    static let shared = StorageManager()
    private init() {}

    
    private let apiKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5xZmt0dmJhc3NtenBzcXhiZWZmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzI0NDg4MjYsImV4cCI6MjA0ODAyNDgyNn0.c6V4iVcJdWPCat-aAV8LkTYlqIhfLccDVttBa-j7sGQ"
    
    private let secret = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5xZmt0dmJhc3NtenBzcXhiZWZmIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTczMjQ0ODgyNiwiZXhwIjoyMDQ4MDI0ODI2fQ.ZF4_p_emOHaDUs5F4CLtl7iuV7EAFIjFnX7VCBCIYDA"
    
    lazy var storage = SupabaseStorageClient(configuration: StorageClientConfiguration(url: URL(string: "https://nqfktvbassmzpsqxbeff.supabase.co/storage/v1")!, headers: [
        "Authorization": "Bearer \(secret)",
        "apikey": apiKey
    ], logger: nil))
    
    func uploadProfilePhoto(for user: AppUser, photoData: Data) async throws {
        do {
            _ = try await storage.from("images").list(path: "\(user.uid)")
            _ = try await storage.from("images").update("\(user.uid)/profile_photo.jpg", data: photoData, options: FileOptions(cacheControl: "2400"))
        } catch {
            _ = try await storage.from("images").upload("\(user.uid)/profile_photo.jpg", data: photoData, options: FileOptions(cacheControl: "2400"))
        }
    }
    
    func fetchProfilePhoto(for user: AppUser) async throws -> Data {
        return try await storage.from("images").download(path:"\(user.uid)/profile_photo.jpg")
    }
}
