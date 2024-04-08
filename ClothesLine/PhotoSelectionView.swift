//
//  PhotoSelectionView.swift
//  ClothesLine
//
//  Created by Timothy Van on 4/7/24.
//

import SwiftUI
import PhotosUI

struct PhotoSelectionView: View {
    @ObservedObject var vm = PhotoSelectionViewModel()
    
    var body: some View {
        VStack {

            Spacer()
           
            PhotoView(imageState: vm.imageState)
                .frame(width: 300, height: 400)
                .background(Gradient(colors: [.gray, .blue, .black]))
                .clipShape(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/))
                .overlay(alignment: .topLeading) {
                    PhotosPicker(selection: $vm.imageSelection, matching: .images) {
                        ZStack {
                            Circle()
                                .frame(width: 35)
                                .foregroundStyle(.gray)
                            Image(systemName: vm.imageSelection == nil ? "plus.circle.fill" : "pencil.circle.fill")
                                .font(.system(size: 30))
                                .foregroundStyle(RadialGradient(gradient: Gradient(colors: [.white, .gray]), center: .center, startRadius: .zero, endRadius: 30))
                            .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                        }
                        .offset(
                            x: -10,
                            y: -10
                        )
                        
                    }
                }
            
            Spacer()
            
            
            Spacer()
        }
    }
}

class PhotoSelectionViewModel: ObservableObject {
    @Published var imageSelection: PhotosPickerItem? = nil {
        didSet {
            if let imageSelection {
                self.loadImage()
            } else {
                imageState = .empty
            }
        }
    }
    @Published var imageState: ImageState = .success(Image(.sampleTimmyFit1))
    
    
    func loadImage() {
        guard let imageSelection = imageSelection else { return }
        
        imageSelection.loadTransferable(type: Image.self) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let image):
                self.imageState = .success(image!)
            case .failure(let failure):
                self.imageState = .failure(failure)
            }
        }
    }
    
}

enum ImageState {
    case empty
    case loading(Progress)
    case success(Image)
    case failure(Error)
}



#Preview {
    PhotoSelectionView()
}
