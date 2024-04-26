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
            PhotoOutfit.self,
            ClothesLine.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var clothesLine: ClothesLine
    
    init() {
        guard let existingClothesLines = try? sharedModelContainer.mainContext.fetch(FetchDescriptor<ClothesLine>()) else {
            let mainClothesLine = ClothesLine(name: "Main Clothesline", desc: "Your main clothesline", outfits: [])
            clothesLine = mainClothesLine
            return
        }
        print("Found \(existingClothesLines.count) existing ClothesLines")
        
        if existingClothesLines.isEmpty {
            let mainClothesLine = ClothesLine(name: "Main Clothesline", desc: "Your main clothesline", outfits: [])
            sharedModelContainer.mainContext.insert(mainClothesLine)
            try? sharedModelContainer.mainContext.save()
            clothesLine = mainClothesLine
        } else {
            clothesLine = existingClothesLines.first!
        }
    }
    
    
    var body: some Scene {
        WindowGroup {
            ClothesLinePickerView()
        }
        .modelContainer(sharedModelContainer)
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
