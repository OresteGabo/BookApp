//
//  BookRowView.swift
//  sujet_examen2
//
//  Created by muhirwa gabo Oreste on 15/11/2025.
//



import SwiftUI

struct BookRowView: View {
    let book: Book
    @EnvironmentObject var favoritesViewModel: FavoritesViewModel

    var body: some View {
        HStack(spacing: 15) {
            let imageSize = (width: 45.0, height: 60.0)
            let cornerRadius: CGFloat = 4.0
            // Book Cover Image
            AsyncImage(url: book.coverURL) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFill()
                    
                } else if phase.error != nil {
                    Image(systemName: "book.closed.fill")
                        .resizable()
                        .scaledToFit()
                        .padding(8)
                        .foregroundColor(.secondary)
                        .background(Color(.systemGray5))
                } else {
                    ProgressView()
                }
            }
            .frame(width: imageSize.width, height: imageSize.height)
            .clipped()
            .cornerRadius(cornerRadius)
           
            
            VStack(alignment: .leading, spacing: 2) {
                Text(book.title).font(.headline).lineLimit(1)
                if let author = book.authors?.first?.name {
                    Text(author).font(.subheadline).foregroundColor(.secondary).lineLimit(1)
                }
                if let downloads = book.downloadCount {
                    Text("\(downloads) downloads").font(.caption2).foregroundColor(.secondary.opacity(0.7))
                }
            }
            
            Spacer()
            
            // Favorites Star Icon
            if favoritesViewModel.isFavorite(book) {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
            }
        }
    }
}
