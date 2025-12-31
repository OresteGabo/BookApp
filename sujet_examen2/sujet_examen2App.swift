// sujet_examen2App.swift

import SwiftUI

@main
struct sujet_examen2App: App {
    // ⭐️ FIX: Create the BookViewModel instance here
    @StateObject private var bookViewModel = BookViewModel()
    
    @StateObject private var favoritesViewModel = FavoritesViewModel()
    
    var body: some Scene {
        WindowGroup {
            // Assuming ContentView is your main TabView wrapper:
            ContentView()
                // Inject BOTH ViewModels into the environment.
                .environmentObject(bookViewModel)
                .environmentObject(favoritesViewModel)    
        }
    }
}
