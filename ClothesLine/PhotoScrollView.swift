//
//  PhotoScrollView.swift
//  ClothesLine
//
//  Created by Timothy Van on 4/7/24.
//

import SwiftUI

struct PhotoScrollView: View {
    @ObservedObject var vm = PhotoScrollViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    LazyVStack() {
                        Button(action: {
                            print("test")
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
                        ForEach(vm.outfits) { outfit in
                            VStack {
                                Text("\(vm.formatDate(date: outfit.date))")
                                outfit.image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 300, height: 400)
                                    .background(Gradient(colors: [.gray, .blue, .black]))
                                    .clipShape(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/))
                                Rectangle()
                                    .frame(width: 5, height: 30)
                            }
                            
                        }
                    }
                }
            }
            .navigationTitle("Your Clothesline")
            .sheet(isPresented: $vm.showSheet, content: {
                PhotoSelectionView()
            })
        }
    }
}

class PhotoScrollViewModel: ObservableObject {
    @Published var outfits: [PhotoOutfit] = [
        PhotoOutfit(image: Image(.sampleTimmyFit1), date: Date.now),
        PhotoOutfit(image: Image(.sampleTimmyFit2), date: Date.now.addingTimeInterval(86400)),
        PhotoOutfit(image: Image(.sampleTimmyFit3), date: Date.now.addingTimeInterval(86400 * 3)),
        PhotoOutfit(image: Image(.sampleTimmyFit1), date: Date.now.addingTimeInterval(86400 * 6)),
        PhotoOutfit(image: Image(.sampleTimmyFit2), date: Date.now.addingTimeInterval(86400 * 8)),
        PhotoOutfit(image: Image(.sampleTimmyFit3), date: Date.now.addingTimeInterval(86400 * 10)),
    
    ]
    
    @Published var showSheet = false
    
    private let dateFormatter = DateFormatter()
    
    init() {
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
    }
    
    func formatDate(date: Date) -> String {
        return dateFormatter.string(from: date)
        
    }
    

}

#Preview {
    PhotoScrollView()
}
