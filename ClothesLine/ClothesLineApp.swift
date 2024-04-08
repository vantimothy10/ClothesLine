//
//  ClothesLineApp.swift
//  ClothesLine
//
//  Created by Timothy Van on 4/7/24.
//

import SwiftUI
import SwiftData

@main
struct ClothesLineApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
            PhotoOutfit.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            PhotoScrollView(vm: PhotoScrollViewModel(modelContext: sharedModelContainer.mainContext))
        }
        .modelContainer(sharedModelContainer)
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
