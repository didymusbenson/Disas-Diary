//
//  GraveStepper.swift
//  Disas Diary
//
//  Created by DBenson on 12/13/24.
//

import SwiftUI

struct GraveStepper: View {
    @State var value = 0
    @State var name: String
    
    var body: some View {
        HStack{
            Button(action:{if value > 0 {value -= 1}}) {
                Text(Image(systemName:"chevron.backward")).font(.title2)
            }
            .buttonStyle(.bordered)

            .foregroundColor(.secondary)
            
            Text(name).font(.title2)
            Spacer()
            Text(String(value)).font(.title2)
            
            
            Button(action:{value += 1}) {
                Text(Image(systemName:"chevron.forward")).font(.title2)
            }
            .buttonStyle(.bordered)

            .foregroundColor(.secondary)
        }
        .cornerRadius(20)
        .padding(EdgeInsets(top:0, leading:5, bottom:0, trailing:5))
    }
}

#Preview {
    GraveStepper(name:"Creatures")
}
