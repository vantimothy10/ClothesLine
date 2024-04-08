//
//  PhotoSelectionView.swift
//  ClothesLine
//
//  Created by Timothy Van on 4/7/24.
//

import SwiftUI
import PhotosUI
import SwiftData

struct PhotoSelectionView: View {
    @ObservedObject var vm: PhotoSelectionViewModel
    
    var body: some View {
        
        ScrollView {
            VStack(alignment: .center) {

               
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
                                    .shadow(radius: 2)
                                Image(systemName: vm.imageSelection == nil ? "plus.circle.fill" : "pencil.circle.fill")
                                    .font(.system(size: 30))
                                    .foregroundStyle(RadialGradient(gradient: Gradient(colors: [.white, .gray]), center: .center, startRadius: .zero, endRadius: 30))
                                
                            }
                            .offset(
                                x: -10,
                                y: -10
                            )
                            
                        }
                    }
                    .overlay(alignment: .bottomTrailing) {
                        if vm.disliked {
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
                        
                        if vm.liked {
                            RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                                .foregroundColor( .green )
                                .frame(width: 50, height: 50)
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
                    .padding()
                
                DatePicker("", selection: $vm.date, displayedComponents: [.date])
                    .frame(width: 100)
                
                TextField("Notes:", text: $vm.notes)
                    .frame(width: 300, height: 25, alignment: .top)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(.gray, lineWidth: 5)
                    )
                    .contentShape(RoundedRectangle(cornerRadius: 20))
                
                HStack(spacing: 75) {
                    Button {
                        vm.liked.toggle()
                    } label: {
                        RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                            .foregroundColor(vm.disliked ? .gray : .green)
                            .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 100)

                            .overlay {
                                ZStack {
                                    Image(systemName: "hand.thumbsup.circle")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundStyle(.ultraThickMaterial)
                                        .frame(width: 50, height: 50)
                                    
                                    if vm.liked {
                                        RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                                            .stroke(.gray, lineWidth: 5)
                                            .frame(width: 100, height: 100)
                                    }
                                }
                               
                            }
                    }
                    .disabled(vm.disliked)

                    
                    Button {
                        vm.disliked.toggle()
                    } label: {
                        RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                            .foregroundColor(vm.liked ? .gray : .red)
                            .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 100)
                            .overlay {
                                ZStack {
                                    Image(systemName: "hand.thumbsdown.circle")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundStyle(.ultraThickMaterial)
                                    .frame(width: 50, height: 50)
                                    
                                    if vm.disliked {
                                        RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                                            .stroke(.gray, lineWidth: 5)
                                            .frame(width: 100, height: 100)
                                    }
                                }
                            }
                    }
                    .disabled(vm.liked)

                }
                .frame(width: 300)
                .padding()
                
               
                if vm.submittable {
                    Button(action: {
                        vm.submit()
                    }, label: {
                        Text("Submit")
                    })
                }

                
                Spacer()
            }
            .padding()
        }
    }
}

@MainActor
class PhotoSelectionViewModel: ObservableObject {
    // MARK: Image Variables
    @Published var imageSelection: PhotosPickerItem? = nil {
        didSet {
            if imageSelection != nil {
                self.loadImage()
            } else {
                imageState = .empty
            }
        }
    }
    @Published var imageState: ImageState = .empty
    @Published var imageData: Data? = nil
    
    // MARK: Photo Outfit Variables
    @Published var date: Date = Date()
    @Published var liked: Bool = false
    @Published var disliked: Bool = false
    @Published var notes: String = "No notes!"
    
    var submittable: Bool {
        return imageData != nil && (liked || disliked)
    }
    
    private var modelContext: ModelContext
    
    init( modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    
    func loadImage() {
        guard let imageSelection = imageSelection else { return }
        
        imageSelection.loadTransferable(type: Data.self) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let imageData):
                DispatchQueue.main.async {
                    self.imageData = imageData
                    self.imageState = .success(imageData!)
                }
                
            case .failure(let failure):
                self.imageState = .failure(failure)
            }
        }
    }
    
    @MainActor func submit() {
        if let imageData = imageData {
            let photoOutfit = PhotoOutfit(imageData: imageData, date: date, liked: liked, disliked: disliked, notes: notes)
            
            modelContext.insert(photoOutfit)
            try? modelContext.save()
        }
        
        
    }
    
}

enum ImageState {
    case empty
    case loading(Progress)
    case success(Data)
    case failure(Error)
}



#Preview {
    let sampleData = [
        PhotoOutfit(imageData: (UIImage(named: "sample.timmy.fit.1")?.pngData())!, date: Date.now),
        PhotoOutfit(imageData: (UIImage(named: "sample.timmy.fit.2")?.pngData())!, date: Date.now.addingTimeInterval(86400)),
        PhotoOutfit(imageData: (UIImage(named: "sample.timmy.fit.3")?.pngData())!, date: Date.now.addingTimeInterval(86400 * 3)),
        PhotoOutfit(imageData: (UIImage(named: "sample.timmy.fit.1")?.pngData())!, date: Date.now.addingTimeInterval(86400 * 6)),
        PhotoOutfit(imageData: (UIImage(named: "sample.timmy.fit.2")?.pngData())!, date: Date.now.addingTimeInterval(86400 * 8)),
        PhotoOutfit(imageData: (UIImage(named: "sample.timmy.fit.3")?.pngData())!, date: Date.now.addingTimeInterval(86400 * 10))
    ]
    
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: PhotoOutfit.self, configurations: config)
    
    for data in sampleData {
        container.mainContext.insert(data)
    }
    
    return PhotoSelectionView(vm: PhotoSelectionViewModel(modelContext: container.mainContext))
}
