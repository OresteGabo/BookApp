//
//  ContentView.swift
//  sujet_examen2
//
//  Created by muhirwa gabo Oreste on 10/11/2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            AllBooksView()
                .tabItem { Label("All Books", systemImage: "book") }

            FavoritesView()
                .tabItem { Label("Favorites", systemImage: "star.fill") }

            SearchBooksView()
                .tabItem { Label("Search", systemImage: "magnifyingglass") }
        }
        // ⭐️ Apply the frosted glass effect to the TabView
        .toolbarBackground(
            // Use .visible to ensure the custom background is drawn
            .visible,
            for: .tabBar
        )
        .toolbarBackground(
            // Use .ultraThinMaterial for the translucent, frosted effect
            .ultraThinMaterial,
            for: .tabBar
        )
    }
}
