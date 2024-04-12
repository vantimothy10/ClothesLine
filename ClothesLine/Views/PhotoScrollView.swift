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
    
    var body: some View {
            VStack {
                
                Divider()
                ScrollView(.vertical) {
                    VStack() {
                        
                        // MARK: Button section
                        HStack {
                            // MARK: Jump to bottom button
                            if !vm.clothesLine.outfits.isEmpty {
                                Button(action: {
                                    vm.jumpToBottom()
                                }, label: {
                                    RoundedRectangle(cornerRadius: 25.0)
                                        .foregroundStyle(.ultraThinMaterial)
                                        .frame( height: 30)
                                        .contentShape(RoundedRectangle(cornerRadius: 25.0))
                                        .overlay {
                                            Image(systemName:  "arrowshape.down")
                                                .font(.system(size: 20))
                                        }
                            })
                            }
                            
                            // MARK: Add new tile button
                            Button(action: {
                                vm.showSheet.toggle()
                            }, label: {
                                RoundedRectangle(cornerRadius: 25.0)
                                    .foregroundStyle(.ultraThinMaterial)
                                    .frame( height: 30)
                                    .contentShape(RoundedRectangle(cornerRadius: 25.0))
                                    .overlay {
                                        Image(systemName:  "plus.circle")
                                            .font(.system(size: 20))
                                    }
                            })
                        }
                        .scrollTargetLayout()
                        
                        // MARK: Display created tiles
                        LazyVStack {
                            ForEach(Array(vm.clothesLine.outfits.enumerated()), id: \.offset) { offset, outfit in
                                VStack {
                                    Text("\(vm.formatDate(date: outfit.date))")
                                    PhotoTileView(outfit: outfit)
                                        .contentShape(RoundedRectangle(cornerRadius: 25.0))
                                    
                                }
                                .scrollTransition { content, phase in
                                    content
                                        .opacity(phase.isIdentity ? 1 : 0.4)
                                        .scaleEffect(phase.isIdentity ? 1 : 0.75)
                                }
                            }
                        }
                        .scrollTargetLayout()
                    
                        // MARK: Jump to top button
                        if !vm.clothesLine.outfits.isEmpty {
                            Button(action: {
                                vm.jumpToTop()
                            }, label: {
                                RoundedRectangle(cornerRadius: 25.0)
                                    .foregroundStyle(.ultraThinMaterial)
                                    .frame(width: 300, height: 30)
                                    .contentShape(RoundedRectangle(cornerRadius: 25.0))
                                    .overlay {
                                        Image(systemName:  "arrowshape.up")
                                            .font(.system(size: 20))
                                    }
                        })
                        }
                    }
                }
                .scrollPosition(id: $vm.scrollPosition, anchor: .center)
                .scrollTargetBehavior(.viewAligned)
                .onAppear{
                    
                }
                
            }
            .navigationTitle("\(vm.clothesLine.name)")
            .sheet(isPresented: $vm.showSheet, content: {
                PhotoSelectionView(vm: PhotoSelectionViewModel(currentClothesline: vm.clothesLine, modelContext: modelContext))
            })
        }
        
    
}


@MainActor
class PhotoScrollViewModel: ObservableObject {
    @Published var showSheet = false
    @Published var showDelete = false
    @Published var selectedOutfit: PhotoOutfit? = nil
    @Published var scrollPosition: Int? = nil
    @Published var clothesLine: ClothesLine
    var searchString: String = ""
    
    private let modelContext: ModelContext
    
    private let dateFormatter = DateFormatter()
    
    init(clothesLine: ClothesLine, modelContext: ModelContext) {
        
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        self.clothesLine = clothesLine
        self.modelContext = modelContext
    }
    
    func refreshClothesLine() {
        let id = clothesLine.id
        let fetchDescriptor = FetchDescriptor<ClothesLine>(predicate: #Predicate { $0.id == id })
        guard let foundClothesLine = try? modelContext.fetch(fetchDescriptor).first else {
            return
        }
        clothesLine = foundClothesLine
        sortClothesLines()
    }
    
    func sortClothesLines() {
        clothesLine.outfits = clothesLine.outfits.sorted(by: { $0.date.timeIntervalSince1970 < $1.date.timeIntervalSince1970 })
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
    
    func jumpToBottom() {
        withAnimation {
            if let count = try? modelContext.fetchCount(FetchDescriptor<PhotoOutfit>()) {
                scrollPosition = count - 1
            }
        }
    }
    
    func jumpToTop() {
        withAnimation {
            scrollPosition = 0
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
    let sampleClothesLine = ClothesLine(name: "Main Clothesline", desc: "This is your main clothesline", outfits: sampleOutfits)

    
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: ClothesLine.self, configurations: config)
    
    container.mainContext.insert(sampleClothesLine)
    
    return PhotoScrollView(vm: PhotoScrollViewModel(clothesLine: sampleClothesLine, modelContext: container.mainContext)).modelContainer(container)
}
