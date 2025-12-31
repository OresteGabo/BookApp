//
//  BookContentLoader.swift
//  sujet_examen2
//
//  Created by muhirwa gabo Oreste on 11/11/2025.
//

import Foundation

@MainActor
class BookContentLoader: ObservableObject {
    @Published var content: String = "Loading content..."

    func loadContent(from url: URL?) async {
        guard let url = url else {
            content = "No content available."
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let text = String(data: data, encoding: .utf8) ?? ""
            // Keep only the first few paragraphs for readability
            content = text.isEmpty ? "No readable content found." : String(text.prefix(2000))
        } catch {
            content = "Failed to load book content."
        }
    }
}
