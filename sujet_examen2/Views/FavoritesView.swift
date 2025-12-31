//
//  FavoritesView.swift
//  sujet_examen2
//
//  Created by muhirwa gabo Oreste on 11/11/2025.
//

import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var viewModel: FavoritesViewModel
    var body: some View {
        NavigationView {
            if viewModel.favorites.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "star.slash")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                    Text("No favorites yet")
                        .foregroundColor(.gray)
                }
                .navigationTitle("Favorites")
            } else {
                List {
                    ForEach(viewModel.favorites) { book in
                        NavigationLink(destination: BookDetailView(book: book)) {
                            BookRowView(book: book)
                        }
                    }
                    .onDelete(perform: delete)
                }
                .navigationTitle("Favorites")
                .toolbar {
                    EditButton()
                }
            }
        }
    }
    private func delete(at offsets: IndexSet) {
        viewModel.favorites.remove(atOffsets: offsets)
        viewModel.saveFavorites()
    }

}
