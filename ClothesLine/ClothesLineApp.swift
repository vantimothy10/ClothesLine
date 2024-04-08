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
            PhotoScrollView()
        }
        .modelContainer(sharedModelContainer)
    }
}
