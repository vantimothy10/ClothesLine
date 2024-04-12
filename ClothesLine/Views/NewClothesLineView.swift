//
//  NewClothesLineView.swift
//  ClothesLine
//
//  Created by Timothy Van on 4/12/24.
//

import SwiftUI

struct NewClothesLineView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name: String = ""
    @State private var desc: String = ""
    
    @FocusState private var isNameFocused: Bool
    @FocusState private var isDescFocused: Bool
    
    private var submittable: Bool {
        return !name.isEmpty
    }
    
    var body: some View {
        VStack(spacing: 50) {
            Text("Create a New ClothesLine")
                .padding()
            
            TextField("Name", text: $name)
                .frame(width: 300, height: 25, alignment: .top)
                .padding()
                .focused($isNameFocused)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.gray, lineWidth: 5)
                )
                .contentShape(RoundedRectangle(cornerRadius: 20))
                .onTapGesture {
                    isNameFocused = true
                }
            
            
            TextField("Description", text: $desc)
                .frame(width: 300, height: 25, alignment: .top)
                .padding()
                .focused($isDescFocused)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.gray, lineWidth: 5)
                )
                .contentShape(RoundedRectangle(cornerRadius: 20))
                .onTapGesture {
                    isDescFocused = true
                }
            
            if submittable {
                Button(action: {
                    submit()
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Submit")
                })            }
            
            Spacer()
        }
    }
    
    func submit() {
        let newClothesLine = ClothesLine(name: name, desc: desc, outfits: [])
        
        modelContext.insert(newClothesLine)
        try? modelContext.save()
    }
}

#Preview {
    VStack {
        
    }.sheet(isPresented: .constant(true), content: {
        NewClothesLineView()
            .presentationDetents([.medium])
    })
}
