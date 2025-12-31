//
//  FilterBookshelvesView.swift
//  sujet_examen2
//
//  Created by muhirwa gabo Oreste on 15/11/2025.
//

import SwiftUI

struct FilterBookshelvesView: View {
    @ObservedObject var viewModel: BookViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            List {
                // Section for Data Actions (Reload)
                Section(header: Text("Data Actions")) {
                    Button {
                        Task {
                            await viewModel.loadBooks()
                        }
                    } label: {
                        Label("Reload Books", systemImage: "arrow.clockwise")
                    }
                }
                
                // Section for Bookshelf Filtering
                Section(header: Text("Filter by Bookshelf (\(viewModel.activeBookshelves.count)/\(viewModel.allBookshelves.count) selected)")) {
                    
                    // Button to toggle all filters at once
                    Button {
                        if viewModel.activeBookshelves.count == viewModel.allBookshelves.count {
                            // If all are active, deselect all
                            viewModel.activeBookshelves = []
                        } else {
                            // Otherwise, select all
                            viewModel.activeBookshelves = Set(viewModel.allBookshelves)
                        }
                    } label: {
                        HStack {
                            Text(viewModel.activeBookshelves.count == viewModel.allBookshelves.count ? "Deselect All" : "Select All")
                                .bold()
                            Spacer()
                            Image(systemName: "checklist")
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    
                    // Individual Bookshelf Checkboxes
                    ForEach(viewModel.allBookshelves, id: \.self) { bookshelf in
                        Button {
                            // Toggles the filter without closing the sheet
                            viewModel.toggleBookshelfFilter(bookshelf)
                        } label: {
                            HStack {
                                Text(bookshelf)
                                Spacer()
                                // Display the checkbox/checkmark based on the state
                                if viewModel.activeBookshelves.contains(bookshelf) {
                                    Image(systemName: "checkmark.square.fill")
                                        .foregroundColor(.accentColor)
                                } else {
                                    Image(systemName: "square")
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Filter Books")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}
