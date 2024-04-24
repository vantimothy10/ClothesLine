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
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var vm: PhotoSelectionViewModel
    @FocusState var isFocused: Bool
    
    
    var body: some View {
        
        ScrollView {
            VStack(alignment: .center) {
                
                PhotoView(imageState: vm.imageState)
                    .frame(width: 300, height: 400)
                    .background(.gray)
                    .clipShape(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/))
                    .overlay(alignment: .topLeading) {
                        if vm.selectedImage == nil {
                            // MARK: Show the PhotoPicker if there hasnt been a selection already
                            PhotosPicker(selection: $vm.imageSelection, matching: .images) {
                                ZStack {
                                    Circle()
                                        .frame(width: 35)
                                        .foregroundStyle(.gray)
                                        .shadow(radius: 2)
                                    Image(systemName: vm.imageSelection == nil ? "plus.circle" : "pencil.circle")
                                        .font(.system(size: 30))
                                        .foregroundStyle(.white)
                                }
                                .offset(
                                    x: -10,
                                    y: -10
                                )
                            }
                        } else {
                            Button(action: {
                                vm.selectedImage = nil
                            }, label: {
                                ZStack {
                                    Circle()
                                        .frame(width: 35)
                                        .foregroundStyle(.red)
                                        .shadow(radius: 2)
                                    Image(systemName: "x.circle")
                                        .font(.system(size: 30))
                                        .foregroundStyle(.white)
                                }
                                .offset(
                                    x: -10,
                                    y: -10
                                )
                                
                            })
                        }
                        
                    }
                    .overlay(alignment: .topTrailing) {
                        if vm.imageSelection == nil {
                            Button(action: {
                                vm.showCamera.toggle()
                            }, label: {
                                ZStack {
                                    Circle()
                                        .frame(width: 35)
                                        .foregroundStyle(.gray)
                                        .shadow(radius: 2)
                                    Image(systemName: vm.imageSelection == nil ? "camera.circle" : "pencil.circle")
                                        .font(.system(size: 30))
                                        .foregroundStyle(.white)
                                }
                                .offset(
                                    x: 10,
                                    y: -10
                                )
                                
                        })
                        } else {
                            Button(action: {
                                vm.imageSelection = nil
                            }, label: {
                                ZStack {
                                    Circle()
                                        .frame(width: 35)
                                        .foregroundStyle(.red)
                                        .shadow(radius: 2)
                                    Image(systemName: "x.circle")
                                        .font(.system(size: 30))
                                        .foregroundStyle(.white)
                                }
                                .offset(
                                    x: 10,
                                    y: -10
                                )
                                
                            })
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
                    .focused($isFocused)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(.gray, lineWidth: 5)
                    )
                    .contentShape(RoundedRectangle(cornerRadius: 20))
                    .onTapGesture {
                        isFocused = true
                    }
                
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
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Submit")
                    })
                }
                
                
                Spacer()
            }
            .fullScreenCover(isPresented: $vm.showCamera) {
                AccessCameraView(selectedImage: $vm.selectedImage)
            }
            .padding()
        }
    }
}

@MainActor
class PhotoSelectionViewModel: ObservableObject {
    // MARK: Image Picker Variables
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
    
    // MARK: Camera Selection Variables
    @Published var showCamera = false
    @Published var selectedImage: UIImage? = nil {
        didSet {
            if selectedImage != nil {
                self.loadTakenPicture()
            } else {
                imageState = .empty
            }
        }
    }
    
    // MARK: Photo Outfit Variables
    var date: Date = Date()
    @Published var liked: Bool = false
    @Published var disliked: Bool = false
    var notes: String = "No notes!"
    
    var submittable: Bool {
        return imageData != nil && (liked || disliked)
    }
    
    let currentClothesline: ClothesLine
    
    private var modelContext: ModelContext
    
    init(currentClothesline: ClothesLine, modelContext: ModelContext) {
        self.currentClothesline = currentClothesline
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
    
    func loadTakenPicture() {
        guard let selectedImage = selectedImage, let data = selectedImage.pngData() else { return }
        
        self.imageData = data
        self.imageState = .success(data)
    }
    
    @MainActor func submit() {
        UIApplication.shared.endEditing()
        if let imageData = imageData {
            let photoOutfit = PhotoOutfit(imageData: imageData, date: date, liked: liked, disliked: disliked, notes: notes)
            currentClothesline.outfits.append(photoOutfit)
            modelContext.insert(currentClothesline)
            try? modelContext.save()
        }
        
        let fetch = FetchDescriptor<PhotoOutfit>()
        let result = try? modelContext.fetch(fetch)
        
        result.map({ print(String(describing: $0)) })
        
        
    }
    
}

enum ImageState {
    case empty
    case loading(Progress)
    case success(Data)
    case failure(Error)
}

struct AccessCameraView: UIViewControllerRepresentable {
    
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) var isPresented
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(picker: self)
    }
}

// Coordinator will help to preview the selected image in the View.
class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var picker: AccessCameraView
    
    init(picker: AccessCameraView) {
        self.picker = picker
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else { return }
        self.picker.selectedImage = selectedImage
        self.picker.isPresented.wrappedValue.dismiss()
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
    
    return PhotoSelectionView(vm: PhotoSelectionViewModel(currentClothesline: sampleClothesLine, modelContext: container.mainContext))
}
