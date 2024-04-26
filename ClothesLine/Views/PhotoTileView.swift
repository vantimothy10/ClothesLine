//
//  PhotoTile.swift
//  ClothesLine
//
//  Created by Timothy Van on 4/8/24.
//

import SwiftUI
import SwiftData

struct PhotoTileView: View {
    @Environment(\.modelContext) private var modelContext
    let outfit: PhotoOutfit
    let parentId: ClothesLine.ID
    @State private var showDetails = false
    @GestureState private var isLongPressed = false
    @State var longTapped: Bool = false
    @Binding var refreshParent: Bool
    
    private let dateFormatter = DateFormatter()
    
    init(outfit: PhotoOutfit, parentId: ClothesLine.ID, refreshParent: Binding<Bool>) {
        self.outfit = outfit
        self.parentId = parentId
        self._refreshParent = refreshParent
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
    }
    
    
    var body: some View {
        VStack {
            Text("\(formatDate(date: outfit.date))")
                .padding(.top, 0)
            if !showDetails {
                if let uiImage = UIImage(data: outfit.imageData) {
                    // MARK: Image Settings
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 350, height: 575)
                        .background(Gradient(colors: [.gray, .blue, .black]))
                        .clipShape(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/))
                        .opacity(isLongPressed ? 0.1 : 1)
                        .scaleEffect(isLongPressed ? 0.8 : 1)
                    // MARK: Tap Gesture Completion
                        .onTapGesture {
                            withAnimation {
                                showDetails.toggle()
                            }
                        }
                    // MARK: Long Press Gesture Settings
                        .gesture(
                            LongPressGesture(minimumDuration: 1)
                                .updating($isLongPressed, body: { value, state, transaction in
                                    state = value
                                    transaction.animation = Animation.easeOut(duration: 0.5)
                                })
                                .onEnded({ _ in
                                    longTapped = true
                                })
                        )
                    // MARK: Confirmation Dialog
                        .confirmationDialog("Delete this outfit?", isPresented: $longTapped) {
                            Button("Delete", role: .destructive) {
                                print("Deleting outfit \(outfit.id)")
                                deleteOutfit()
                            }
                            Button("Cancel", role: .cancel) { }
                        }
                    // MARK: Liked / Disliked Sticker
                        .overlay(alignment: .bottomTrailing) {
                            if outfit.disliked {
                                RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                                    .foregroundColor( .red )
                                    .frame(width: 50, height: 50)
                                    .overlay {
                                        ZStack {
                                            Image(systemName: "hand.thumbsdown.circle")
                                                .resizable()
                                                .scaledToFit()
                                                .foregroundStyle(.ultraThickMaterial)
                                                .frame(width: 50, height: 50)
                                        }
                                    }
                                    .offset(
                                        x: -10,
                                        y: -10
                                    )
                            }
                            
                            if outfit.liked {
                                RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                                    .foregroundColor( .green )
                                    .frame(width: 50, height: 50)
                                    .onTapGesture {
                                        withAnimation {
                                            showDetails.toggle()
                                        }
                                    }
                                    .overlay {
                                        ZStack {
                                            Image(systemName: "hand.thumbsup.circle")
                                                .resizable()
                                                .scaledToFit()
                                                .foregroundStyle(.ultraThickMaterial)
                                                .frame(width: 50, height: 50)
                                        }
                                    }
                                    .offset(
                                        x: -10,
                                        y: -10
                                    )
                            }
                        }
                }
            } else {
                ZStack {
                    RoundedRectangle(cornerRadius: 25.0)
                        .foregroundStyle(.ultraThinMaterial)
                        .onTapGesture {
                            withAnimation {
                                showDetails.toggle()
                            }
                        }
                    
                    VStack {
                        Text("Notes:")
                        
                        Text("\(outfit.notes )")
                    }
                }
                .frame(width: 350, height: 575)
                
            }
            
        }
        
    }
    
    func fetchClothesLine() -> ClothesLine? {
        let fetchDescriptor = FetchDescriptor<ClothesLine>(predicate: #Predicate { $0.id == parentId })
        do {
            let result = try modelContext.fetch(fetchDescriptor)
            if let clothesLine = result.first {
                return clothesLine
            }
        } catch let error {
            print(error)
        }
        return nil
    }
    
    func removeOutfitFromClothesLine(outfit: PhotoOutfit, clothesLine: ClothesLine) {
        let model = clothesLine.persistentBackingData
        let filteredOutfits = clothesLine.outfits.filter({ $0.id != outfit.id })
        model.setValue(forKey: \.outfits, to: filteredOutfits)
        
        try? self.modelContext.save()
    }
    
    func deleteOutfit() {
        DispatchQueue.main.async {
            self.modelContext.delete(outfit)
            if let clothesLine = fetchClothesLine() {
                removeOutfitFromClothesLine(outfit: outfit, clothesLine: clothesLine)
            }
            
            do {
                try self.modelContext.save()
            } catch let error {
                print("Error deleting outfit - \(error)")
            }
            
            refreshParent = true
        }
    }
    
    func formatDate(date: Date) -> String {
        return dateFormatter.string(from: date)
    }
    
}

#Preview {
    @State var mockBool = false
    let mockClothesLine = ClothesLine(name: "Test", desc: "test", outfits: [])
    
    return ScrollView {
        VStack {
            PhotoTileView(outfit: PhotoOutfit(imageData: (UIImage(named: "sample.timmy.fit.1")?.pngData())!, date: Date.now, liked: true, notes: "Note 1"), parentId: mockClothesLine.id, refreshParent: $mockBool)
            PhotoTileView(outfit: PhotoOutfit(imageData: (UIImage(named: "sample.timmy.fit.1")?.pngData())!, date: Date.now, disliked: true, notes: "Note 2"), parentId: mockClothesLine.id, refreshParent: $mockBool)
        }
    }
}
