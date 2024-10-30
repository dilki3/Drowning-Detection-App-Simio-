//
//  RoundButton.swift
//  Simio
//
//  Created by Dila Dinesha on 2024-10-07.
//

import SwiftUI


struct RoundButton: View {
    @State var title: String = "Tittle"
    var didTap: (()->())?
    
    var body: some View {
        Button {
            didTap?()
        } label: {
            Text(title)
                .font(.system(size: 18)) // Specifies the font size
                .fontWeight(.bold)   // Specifies the font weight
                    
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
        }
        .frame( minWidth: 0, maxWidth: .infinity, minHeight: 60, maxHeight: 60 )
        .background(Color(hex:"03346E"))
        .cornerRadius(20)
    }
}
#Preview {
    RoundButton()
        .padding(20)
}

