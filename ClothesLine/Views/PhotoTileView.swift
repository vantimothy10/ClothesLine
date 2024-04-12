//
//  PhotoTile.swift
//  ClothesLine
//
//  Created by Timothy Van on 4/8/24.
//

import SwiftUI

struct PhotoTileView: View {
    @Environment(\.modelContext) private var modelContext
    let outfit: PhotoOutfit
    @State private var showDetails = false
    @GestureState private var isLongPressed = false
    @State private var showDialog = false
    
    var body: some View {
        if !showDetails {
            if let uiImage = UIImage(data: outfit.imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 300, height: 400)
                    .background(Gradient(colors: [.gray, .blue, .black]))
                    .clipShape(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/))
                    .opacity(isLongPressed ? 0.5 : 1)
                    .onTapGesture {
                        withAnimation {
                            showDetails.toggle()
                        }
                    }
                    .gesture(
                        LongPressGesture(minimumDuration: 2)
                            .updating($isLongPressed, body: { value, state, transaction in
                                state = value
                                transaction.animation = Animation.easeIn(duration: 2)
                            })
                            .onEnded({ _ in
                                showDialog = true
                            })
                        
                    )
                    .confirmationDialog("Delete this outfit?", isPresented: $showDialog) {
                        Button("Delete", role: .destructive) {
                            deleteOutfit()
                        }
                        Button("Cancel", role: .cancel) { }
                        
                    }
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
                    .frame(width: 300, height: 400)
                    .foregroundStyle(.ultraThinMaterial)
                    .onTapGesture {
                        withAnimation {
                            showDetails.toggle()
                        }
                    }
                
                VStack {
                    Text("Notes:")
                    
                    Text("\(outfit.notes ?? "")")
                }
                
                
            }
            
        }
        
    }
    
    func deleteOutfit() {
        
        DispatchQueue.main.async {
            self.modelContext.delete(outfit)
            try? self.modelContext.save()
        }
    }
}

#Preview {
    ScrollView {
        VStack {
            PhotoTileView(outfit: PhotoOutfit(imageData: (UIImage(named: "sample.timmy.fit.1")?.pngData())!, date: Date.now, liked: true, notes: "Note 1"))
            PhotoTileView(outfit: PhotoOutfit(imageData: (UIImage(named: "sample.timmy.fit.1")?.pngData())!, date: Date.now, disliked: true, notes: "Note 2"))
        }
    }
}
