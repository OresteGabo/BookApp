// Book.swift

import Foundation

struct BookResponse: Codable {
    let results: [Book]
}

struct Book: Identifiable, Codable {
    let id: Int
    let title: String
    let subjects: [String]? // Added from documentation
    let authors: [Author]?
    let summaries: [String]? // ⭐️ NEW: Add summaries field
    let downloadCount: Int?
    let formats: [String: String]?
    let bookshelves: [String]?

    struct Author: Codable {
        let name: String
    }
    
    // ... existing textURL and coverURL computed properties ...
    var textURL: URL? {
        // Find the plain text format (if available)
        if let link = formats?["text/plain; charset=utf-8"] ?? formats?["text/plain"] {
            return URL(string: link)
        }
        return nil
    }
    
    var coverURL: URL? {
        if let link = formats?["image/jpeg"]?.replacingOccurrences(of: "medium", with: "medium") {
            return URL(string: link)
        }
        return nil
    }
    
    // ⭐️ NEW: Computed property to get the first summary text
    var firstSummary: String? {
        // Return the first summary found, if any
        return summaries?.first
    }
}
