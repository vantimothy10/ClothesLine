//
//  PhotoView.swift
//  ClothesLine
//
//  Created by Timothy Van on 4/7/24.
//

import SwiftUI

struct PhotoView: View {
    let imageState: ImageState
    
    var body: some View {
        switch imageState {
        case .empty:
            Image(systemName: "photo")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
        case .loading(let progress):
            ProgressView()
                .controlSize(.large)
                .frame(width: 50, height: 50)
        case .success(let imageData):
            if let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            }
            
        case .failure(let error):
            Image(systemName: "exclamationmark.triangle")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
        }
    }
}

#Preview {
    
    VStack(spacing: 30) {
        PhotoView(imageState: .empty)
            .frame(width: 250, height: 250)
            .background(.gray)
            .clipShape(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/))
        PhotoView(imageState: .loading(Progress()))
            .frame(width: 250, height: 250)
            .background(.gray)
            .clipShape(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/))
        
        PhotoView(imageState: .success((UIImage(systemName: "photo.artframe")?.pngData()!)!))
            .frame(width: 250, height: 250)
            .background(.gray)
            .clipShape(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/))
        
        
    }
}
