//
//  OutfitService.swift
//  ClothesLine
//
//  Created by Timothy Van on 4/7/24.
//

import Foundation

protocol OutfitServiceProtocol {
    var outfits: [PhotoOutfit] { get set }
    
    func addOutfit(_ outfit: PhotoOutfit) -> Void
    
}

class OutfitService: OutfitServiceProtocol {
    var outfits: [PhotoOutfit] = []
    
    func addOutfit(_ outfit: PhotoOutfit) {
        outfits.append(outfit)
    }
    
    
}
