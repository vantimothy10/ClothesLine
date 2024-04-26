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
                    LazyVStack(spacing: 1) {
                        ForEach(Array(vm.sortedOutfits.enumerated()), id: \.offset) { offset, outfit in
                            PhotoTileView(outfit: outfit, parentId: vm.clothesLine.id, refreshParent: $vm.shouldRefresh)
                                .scrollTransition { content, phase in
                                    content
                                        .opacity(phase.isIdentity ? 1 : 0.4)
                                        .scaleEffect(phase.isIdentity ? 1 : 0.75)
                                }
                        }
                    }
                    .padding()
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
            .onAppear{
                
                vm.sortOutfits()
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
    @Published var selectedOutfit: PhotoOutfit? = nil
    @Published var scrollPosition: Int? = nil
    var clothesLine: ClothesLine
    @Published var sortedOutfits: [PhotoOutfit] = []
    var searchString: String = ""
    
    @Published var shouldRefresh = false {
        didSet {
            if shouldRefresh {
                self.fetchClothesLine()
                shouldRefresh = false
            }
        }
    }
    
    private let modelContext: ModelContext
    
    
    init(clothesLine: ClothesLine, modelContext: ModelContext) {
        self.clothesLine = clothesLine
        self.modelContext = modelContext
        self.sortOutfits()
    }
    
    func fetchClothesLine() {
        let id = clothesLine.id
        let fetchDescriptor = FetchDescriptor<ClothesLine>(predicate: #Predicate { $0.id == id })
        do {
            let result = try modelContext.fetch(fetchDescriptor)
            if (result.first != nil) {
                clothesLine = result.first!
                self.sortOutfits()
            }
        } catch let error {
            print("Error fetching ClothesLine - \(error)")
        }
    }
    
    func sortOutfits() {
        sortedOutfits = clothesLine.outfits.sorted(by: { $0.date > $1.date})
        
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
