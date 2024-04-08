//
//  PhotoScrollView.swift
//  ClothesLine
//
//  Created by Timothy Van on 4/7/24.
//

import SwiftUI
import SwiftData

struct PhotoScrollView: View {
    @Environment(\.modelContext) private var modelContext
    @ObservedObject var vm: PhotoScrollViewModel
    @Query(sort: \PhotoOutfit.date, order: .reverse) var outfits: [PhotoOutfit]
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView() {
                    LazyVStack() {
                        Button(action: {
                            vm.showSheet.toggle()
                        }, label: {
                            RoundedRectangle(cornerRadius: 25.0)
                                .foregroundStyle(.ultraThinMaterial)
                                .frame(width: 300, height: 30)
                                .contentShape(RoundedRectangle(cornerRadius: 25.0))
                                .overlay {
                                    Image(systemName:  "plus.circle")
                                        .font(.system(size: 20))
                                }
                        })
                        
                        
                        Rectangle()
                            .frame(width: 5, height: 30)
                        ForEach(outfits) { outfit in
                            VStack {
                                Text("\(vm.formatDate(date: outfit.date))")
                                PhotoTile(outfit: outfit)
                                    .contentShape(RoundedRectangle(cornerRadius: 25.0))
                                
                                
                                Rectangle()
                                    .frame(width: 5, height: 30)
                            }
                            
                        }
                        
                    }
                }
            }
            .navigationTitle("Your Clothesline")
            .sheet(isPresented: $vm.showSheet, content: {
                PhotoSelectionView(vm: PhotoSelectionViewModel(modelContext: modelContext))
            })
        }
        
    }
}


@MainActor
class PhotoScrollViewModel: ObservableObject {
    @Published var showSheet = false
    @Published var showDelete = false
    @Published var selectedOutfit: PhotoOutfit? = nil
    
    private let modelContext: ModelContext
    
    private let dateFormatter = DateFormatter()
    
    init(modelContext: ModelContext) {
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        self.modelContext = modelContext
    }
    
    func formatDate(date: Date) -> String {
        return dateFormatter.string(from: date)
        
    }
    
    func deleteSelectedOutfit() {
        guard let outfit = selectedOutfit else { return }
        
        DispatchQueue.main.async {
            self.modelContext.delete(outfit)
            try? self.modelContext.save()
        }
    }
    
    
}

#Preview {
    let sampleData = [
        PhotoOutfit(imageData: (UIImage(named: "sample.timmy.fit.1")?.pngData())!, date: Date.now, liked: true),
        PhotoOutfit(imageData: (UIImage(named: "sample.timmy.fit.2")?.pngData())!, date: Date.now.addingTimeInterval(86400), disliked: true),
        PhotoOutfit(imageData: (UIImage(named: "sample.timmy.fit.3")?.pngData())!, date: Date.now.addingTimeInterval(86400 * 3), disliked: true),
        PhotoOutfit(imageData: (UIImage(named: "sample.timmy.fit.1")?.pngData())!, date: Date.now.addingTimeInterval(86400 * 6), liked: true),
        PhotoOutfit(imageData: (UIImage(named: "sample.timmy.fit.2")?.pngData())!, date: Date.now.addingTimeInterval(86400 * 8), disliked: true),
        PhotoOutfit(imageData: (UIImage(named: "sample.timmy.fit.3")?.pngData())!, date: Date.now.addingTimeInterval(86400 * 10), liked: true)
    ]
    
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: PhotoOutfit.self, configurations: config)
    
    for data in sampleData {
        container.mainContext.insert(data)
    }
    
    return PhotoScrollView(vm: PhotoScrollViewModel(modelContext: container.mainContext)).modelContainer(container)
}
