//
//  SearchTextField.swift
//  Simio
//
//  Created by Dila Dinesha on 2024-10-14.
//

import SwiftUI

struct SearchTextField: View {
   
    @State var placholder: String = "Placholder"
    @Binding var txt: String
    
    var body: some View {
        HStack(spacing: 15) {
            
            Image("search")
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
           
            TextField(placholder, text: $txt)
                .font(.system(size:17))
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .frame(minWidth: 0, maxWidth: .infinity)
        }
        .frame(height: 20)
        .padding(15)
        .background(Color(hex: "e8f5ff"))
        .cornerRadius(16)
    }
}

//#Preview {
  //  SearchTextField()
//}


struct SearchTextField_Previews: PreviewProvider {
    @State static var txt: String = ""
    static var previews: some View {
        SearchTextField(placholder: "Search Swimmer", txt: $txt)
            .padding(15)
    }
}

