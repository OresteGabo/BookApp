//
//  BookDetailView.swift
//
//

import SwiftUI

struct BookDetailView: View {
    let book: Book
    
    @EnvironmentObject var favorites: FavoritesViewModel
    
    // Define the height for the visible cover image block
    let coverBlockHeight: CGFloat = 200

    // Computed property to clean up the bookshelf names (unchanged)
    var cleanedBookshelves: [String]? {
        guard let bookshelves = book.bookshelves else { return nil }
        return bookshelves.map { shelf in
            return shelf.replacingOccurrences(of: "Category: ", with: "")
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                
                // ⭐️ NEW: Prominent Image and Text Header
                VStack(alignment: .center, spacing: 12) {
                    
                    // Book Cover Image
                    AsyncImage(url: book.coverURL) { phase in
                        Group {
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .scaledToFit()
                            } else {
                                // Placeholder/Error view
                                Image(systemName: "book.closed.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.secondary)
                                    .padding(30)
                                    .background(Color(.systemGray5))
                            }
                        }
                        
                        .frame(height: coverBlockHeight)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                    }
                    .shadow(radius: 10)
                    
                    // Title
                    Text(book.title)
                        .font(.title2.bold())
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    // Author
                    if let author = book.authors?.first?.name {
                        Text(author)
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 30)

                
                // --- Details Section ---
                
                VStack(alignment: .leading, spacing: 16) {
                    
                    // Downloads
                    if let downloads = book.downloadCount {
                        HStack(spacing: 4) {
                            Image(systemName: "arrow.down.circle.fill")
                                .foregroundColor(.blue)
                            Text("\(downloads) downloads")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    // Bookshelves/Categories
                    if let bookshelves = cleanedBookshelves, !bookshelves.isEmpty {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Bookshelves")
                                .font(.subheadline.bold())
                            Text(bookshelves.joined(separator: ", "))
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .lineLimit(5)
                        }
                    }

                    Divider().padding(.vertical, 8)

                    // Summary
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Summary")
                            .font(.headline)
                        
                        if let summary = book.firstSummary, !summary.isEmpty {
                            Text(summary)
                                .font(.body)
                                .multilineTextAlignment(.leading)
                        } else {
                            Text("No summary available for this book.")
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.primary.opacity(0.1), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.light, for: .navigationBar)

        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    favorites.toggleFavorite(book)
                } label: {
                    Image(systemName: favorites.isFavorite(book) ? "star.fill" : "star")
                        .foregroundColor(favorites.isFavorite(book) ? .yellow : .gray)
                }
            }
        }
    }
}
