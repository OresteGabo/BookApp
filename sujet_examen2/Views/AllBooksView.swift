// AllBooksView.swift (Simplified for a clean main page)

import SwiftUI

struct AllBooksView: View {
    @EnvironmentObject var viewModel: BookViewModel
    @EnvironmentObject var favoritesViewModel: FavoritesViewModel // Kept for consistency
    @State private var showingFilterSheet = false // Kept for the toolbar filter button

    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading && viewModel.books.isEmpty {
                    VStack {
                        ProgressView("Loading Books...")
                            .scaleEffect(1.5)
                    }
                } else {
                    // Use a ScrollView to stack the horizontal recents above the vertical list
                    ScrollView {
                        VStack(spacing: 0) {
                            
                            
                            
                            // We need to give the inner List a fixed height to function correctly inside a ScrollView
                            BookCatalogContentView(viewModel: viewModel)
                                .frame(minHeight: 800)
                        }
                    }
                }
            }
            .navigationTitle("Tous les livres")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                
                // Keep the filter button to access the FilterBookshelvesView
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingFilterSheet = true
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                    }
                    .disabled(viewModel.isLoading)
                }
            }
        }
        .task {
            // Ensure the initial load uses the new retry logic
            if viewModel.books.isEmpty {
                await viewModel.loadBooks()
            }
        }
        .sheet(isPresented: $showingFilterSheet) {
            FilterBookshelvesView(viewModel: viewModel)
        }
    }
}


struct BookCatalogContentView: View {
    @ObservedObject var viewModel: BookViewModel
    var body: some View {
        
        
        // MAIN CONTENT: The List (or Empty States)
        if viewModel.filteredBooks.isEmpty && !viewModel.isLoading {
            // Empty state (filtered or truly empty)
            Spacer()
            VStack(spacing: 12) {
                let isLoadFailure = viewModel.books.isEmpty
                
                Image(systemName: isLoadFailure ? "wifi.exclamationmark" : "xmark.circle")
                    .font(.largeTitle)
                    .foregroundColor(.secondary)
                
                Text(isLoadFailure ? "Failed to load books. Check your connection." : "No books match the current filters.")
                    .foregroundColor(.secondary)
                
                // Retry Button Logic
                if isLoadFailure {
                    Button("Retry Loading") {
                        Task {
                            await viewModel.loadBooks()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.top, 10)
                }
            }
            .padding()
            Spacer()
        } else {
            // The main catalog list
            List(viewModel.filteredBooks) { book in
                NavigationLink(destination: BookDetailView(book: book)) {
                    BookRowView(book: book)
                }
            }
            .listStyle(.plain)
            .background(Color(.systemBackground).edgesIgnoringSafeArea(.all))
        }
    }
}
