//
//  BookService.swift
//  sujet_examen2
//
//  Created by muhirwa gabo Oreste on 10/11/2025.
//

import Foundation

class BookService {
    func fetchBooks(searchTerm: String? = nil) async throws -> [Book] {
        let baseURL = "https://gutendex.com/books/"
        let urlString = searchTerm != nil ? "\(baseURL)?search=\(searchTerm!)" : baseURL
        guard let url = URL(string: urlString) else { return [] }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoded = try JSONDecoder().decode(BookResponse.self, from: data)
        return decoded.results
    }
    
}
