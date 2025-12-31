//
//  FavoritesViewModel.swift
//  sujet_examen2
//
//  Created by muhirwa gabo Oreste on 11/11/2025.
//

import Foundation

@MainActor
class FavoritesViewModel: ObservableObject {
    @Published var favorites: [Book] = []

    private let favoritesKey = "favoriteBooks"

    init() {
        loadFavorites()
    }

    func toggleFavorite(_ book: Book) {
        if isFavorite(book) {
            favorites.removeAll { $0.id == book.id }
        } else {
            favorites.append(book)
        }
        saveFavorites()
    }

    func isFavorite(_ book: Book) -> Bool {
        favorites.contains(where: { $0.id == book.id })
    }

    func saveFavorites() {
        if let data = try? JSONEncoder().encode(favorites) {
            UserDefaults.standard.set(data, forKey: favoritesKey)
        }
    }
    

    private func loadFavorites() {
        if let data = UserDefaults.standard.data(forKey: favoritesKey),
           let decoded = try? JSONDecoder().decode([Book].self, from: data) {
            favorites = decoded
        }
    }
}
