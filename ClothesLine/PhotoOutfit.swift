//
//  Outfit.swift
//  ClothesLine
//
//  Created by Timothy Van on 4/7/24.
//

import Foundation
import SwiftData

@Model
class PhotoOutfit: Identifiable {
    let id = UUID()
    @Attribute(.externalStorage) var imageData: Data
    var date: Date
    var liked: Bool
    var disliked: Bool
    var notes: String
    
    init(imageData: Data, date: Date, liked: Bool = false, disliked: Bool = false, notes: String = "") {
        self.imageData = imageData
        self.date = date
        self.liked = liked
        self.disliked = disliked
        self.notes = notes
    }
    
    
}
