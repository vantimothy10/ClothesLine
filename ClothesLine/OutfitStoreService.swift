//
//  OutfitService.swift
//  ClothesLine
//
//  Created by Timothy Van on 4/7/24.
//

import Foundation

protocol OutfitStoreServiceProtocol {
    var outfits: [PhotoOutfit] { get set }
    
    func addOutfit(_ outfit: PhotoOutfit) -> Void
    
}

class OutfitStoreService: OutfitStoreServiceProtocol {
    var outfits: [PhotoOutfit] = []
    
    func addOutfit(_ outfit: PhotoOutfit) {
        outfits.append(outfit)
    }
    
    
}
