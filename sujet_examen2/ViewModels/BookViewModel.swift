//
//  BookViewModel.swift
//  sujet_examen2
//
//  Created by muhirwa gabo Oreste on 10/11/2025.
//


import Foundation

enum BookSortOrder {
    case title
    case downloads
}

@MainActor
class BookViewModel: ObservableObject {
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
            
    private let bookService = BookService()
    @Published var books: [Book] = []
    @Published var sortOrder: BookSortOrder = .title
    
    // Filtering state
    @Published var allBookshelves: [String] = []
    @Published var activeBookshelves: Set<String> = []
    
   
    @Published var searchText: String = ""
    
    // Computed property to return the FILTERED and sorted list
    var filteredBooks: [Book] {
        
        var currentBooks = books
        
        // 1. Apply Bookshelf Filtering
        if !activeBookshelves.isEmpty && activeBookshelves.count != allBookshelves.count {
            // Only filter if not all shelves are active AND the list is not empty
             currentBooks = currentBooks.filter { book in
                guard let bookShelves = book.bookshelves else { return false }
                // Check if the book has AT LEAST ONE shelf in the active set
                return bookShelves.contains(where: activeBookshelves.contains)
            }
        }
        // NOTE: If activeBookshelves is empty, we show all books (as per the filter view's Deselect All logic).
        
        // 2. Apply Search Filtering
        if !searchText.isEmpty {
            let lowercasedQuery = searchText.lowercased()
            currentBooks = currentBooks.filter { book in
                let titleMatch = book.title.lowercased().contains(lowercasedQuery)
                let authorMatch = book.authors?.contains { $0.name.lowercased().contains(lowercasedQuery) } ?? false
                return titleMatch || authorMatch
            }
        }
        
        // 3. Apply Sorting
        return currentBooks.sorted(by: {
            switch sortOrder {
            case .title:
                return $0.title < $1.title
            case .downloads:
                return ($0.downloadCount ?? 0) > ($1.downloadCount ?? 0)
            }
        })
    }
    
    // Existing sortedBooks property (removed as its logic is now inside filteredBooks for efficiency)
    
    func loadBooks(search: String? = nil) async {
        guard !isLoading else { return }
        
        isLoading = true
        errorMessage = nil

        do {
            let loadedBooks = try await bookService.fetchBooks(searchTerm: search)
            
            // Update the main books array
            self.books = loadedBooks
            
            // Populate and activate filters
            let shelves = loadedBooks.compactMap { $0.bookshelves }.flatMap { $0 }
            let uniqueShelves = Set(shelves).sorted()
            
            self.allBookshelves = uniqueShelves
            
            // ⭐️ FIX CONFIRMED: Initialize active filters to include ALL available shelves
            // This ensures all books are visible when the app first launches.
            self.activeBookshelves = Set(uniqueShelves)
            
        } catch {
            print("Error loading books: \(error.localizedDescription)")
            self.errorMessage = "Failed to load books: \(error.localizedDescription)"
            self.books = []
            self.allBookshelves = []
            self.activeBookshelves = []
        }
        
        isLoading = false
    }
    
    
    // Toggle function for the filter checkboxes
    func toggleBookshelfFilter(_ bookshelf: String) {
        if activeBookshelves.contains(bookshelf) {
            activeBookshelves.remove(bookshelf)
        } else {
            activeBookshelves.insert(bookshelf)
        }
    }

}
