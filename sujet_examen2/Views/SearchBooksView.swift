//
//  SearchBooksView.swift
//  sujet_examen2
//
//  Created by muhirwa gabo Oreste on 11/11/2025.
//

// SearchBooksView.swift

import SwiftUI

struct SearchBooksView: View {
    @StateObject private var viewModel = BookViewModel()
    @EnvironmentObject var favoritesViewModel: FavoritesViewModel
    @State private var query: String = ""
    @State private var searchTask: Task<Void, Never>? = nil

    var body: some View {
        NavigationView {
            VStack {
                // Search bar
                HStack {
                    TextField("Enter title or author...", text: $query)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                        .disableAutocorrection(true)
                        .textInputAutocapitalization(.never)

                    
                    if viewModel.isLoading {
                        ProgressView()
                            .padding(.trailing)
                    }
                }
                .padding(.top)
                
                // ⭐️ New: Handle initial state and no results
                Group {
                    if viewModel.isLoading {
                        // The spinner is already in the search bar, this is for a general loading state if needed
                        Color.clear.frame(height: 0)
                    } else if query.isEmpty {
                        Text("Start typing a title or author to search.")
                            .foregroundColor(.secondary)
                            .padding(.top, 50)
                    } else if viewModel.books.isEmpty && !viewModel.errorMessage.isNilOrEmpty {
                        Text(viewModel.errorMessage ?? "An error occurred while loading books.")
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding(.top, 50)
                    } else if viewModel.books.isEmpty {
                        Text("No results found for \"\(query)\".")
                            .foregroundColor(.secondary)
                            .padding(.top, 50)
                    } else {
                        // Results list
                        List(viewModel.books) { book in
                            NavigationLink(destination: BookDetailView(book: book)) {
                                BookRowView(book: book)
                            }
                        }
                        .listStyle(.insetGrouped)
                    }
                }
                
                Spacer()
            }
            .navigationTitle("Search Books")
        }
        // Search on "Return"
        .onSubmit(of: .text) {
            Task { await performSearch() }
        }
        // Live search with debounce
        .onChange(of: query) { oldValue, newValue in
            // Clear results immediately when typing starts
            if newValue.count < 3 {
                viewModel.books = []
            }
            
            guard newValue.count > 2 else { return }

            // Cancel previous search if still running
            searchTask?.cancel()
            searchTask = Task {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                await performSearch()
            }
        }
    }

    private func performSearch() async {
        guard !query.isEmpty else { return }
        await viewModel.loadBooks(search: query)
    }
}

// Extension to help check for nil or empty string easily
private extension Optional where Wrapped == String {
    var isNilOrEmpty: Bool {
        self?.isEmpty ?? true
    }
}
