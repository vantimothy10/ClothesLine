//
//  ClothesLinePickerView.swift
//  ClothesLine
//
//  Created by Timothy Van on 4/12/24.
//

import SwiftUI
import SwiftData

struct ClothesLinePickerView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \ClothesLine.name) var clothesLines: [ClothesLine]
    @State private var showSheet = false
    
    var body: some View {
        NavigationStack {
            VStack {
                List{
                    ForEach(clothesLines) { clothesLine in
                        NavigationLink(clothesLine.name, value: clothesLine)
                    }
                    .onDelete{ indexSet in
                        
                        deleteClothesLine(indexSet: indexSet )
                    }
                }
                .navigationDestination(for: ClothesLine.self) { clothesLine in
                    PhotoScrollView(vm: PhotoScrollViewModel(clothesLine: clothesLine, modelContext: modelContext))
                }
            }
            .sheet(isPresented: $showSheet, content: {
                NewClothesLineView()
                    .presentationDetents([.medium])
            })
            .presentationDetents([.medium])
            .navigationBarItems(trailing: Button(action: {
                showSheet.toggle()
            }, label: {
                    Image(systemName: "plus")
                })
            )
            .navigationTitle("Your ClothesLines")

            
        }
    }
    
    func deleteClothesLine(indexSet: IndexSet) {
        if let arrIndex = indexSet.first {
            let clothesLine = clothesLines[arrIndex]
            modelContext.delete(clothesLine)
            try? modelContext.save()
        }
        
    }
}

#Preview {
    let sampleOutfits = [
        PhotoOutfit(imageData: (UIImage(named: "sample.timmy.fit.1")?.pngData())!, date: Date.now, liked: true),
        PhotoOutfit(imageData: (UIImage(named: "sample.timmy.fit.2")?.pngData())!, date: Date.now.addingTimeInterval(86400), disliked: true),
        PhotoOutfit(imageData: (UIImage(named: "sample.timmy.fit.3")?.pngData())!, date: Date.now.addingTimeInterval(86400 * 3), disliked: true),
        PhotoOutfit(imageData: (UIImage(named: "sample.timmy.fit.1")?.pngData())!, date: Date.now.addingTimeInterval(86400 * 6), liked: true),
        PhotoOutfit(imageData: (UIImage(named: "sample.timmy.fit.2")?.pngData())!, date: Date.now.addingTimeInterval(86400 * 8), disliked: true),
        PhotoOutfit(imageData: (UIImage(named: "sample.timmy.fit.3")?.pngData())!, date: Date.now.addingTimeInterval(86400 * 10), liked: true)
    ]
    let sampleClothesLine = ClothesLine(name: "Main ClothesLine", desc: "This is your main clothesline", outfits: sampleOutfits)
    let sampleClothesLine2 = ClothesLine(name: "Timmy's ClothesLine", desc: "This is Timmy's clothesline", outfits: sampleOutfits)
    let sampleClothesLine3 = ClothesLine(name: "Jenny's ClothesLine", desc: "This is Jenny's clothesline", outfits: sampleOutfits)
    
    
    
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: ClothesLine.self, configurations: config)
    
    container.mainContext.insert(sampleClothesLine)
    container.mainContext.insert(sampleClothesLine2)
    container.mainContext.insert(sampleClothesLine3)
    
    return ClothesLinePickerView().modelContainer(container)
}
