//
//  Outfit.swift
//  ClothesLine
//
//  Created by Timothy Van on 4/7/24.
//

import Foundation
import SwiftUI

class PhotoOutfit: Identifiable {
    let id = UUID()
    var image: Image
    var date: Date
    var approved: Bool?
    var notes: String?
    
    init(image: Image, date: Date, approved: Bool? = nil, notes: String? = nil) {
        self.image = image
        self.date = date
        self.approved = approved
        self.notes = notes
    }
    
    
}
