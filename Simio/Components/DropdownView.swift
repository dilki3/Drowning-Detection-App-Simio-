//
//  DropdownView.swift
//  Simio
//
//  Created by Dila Dinesha on 2024-10-10.
//

import SwiftUI

struct DropdownView: View {
    @Binding var selection: String
    let title: String
    let placeholder: String
    let options: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .foregroundColor(Color(.darkGray))
                .fontWeight(.semibold)
                .font(.footnote)
            
            Menu {
                ForEach(options, id: \.self) { option in
                    Button(option) {
                        selection = option
                    }
                }
            } label: {
                HStack {
                    Text(selection.isEmpty ? placeholder : selection)
                        .foregroundColor(selection.isEmpty ? .gray : .black)
                        .font(.system(size: 15))
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 8)
                .background(Color(.white))
                .cornerRadius(6)
            }
            
            Divider()
        }
    }
}

#Preview {
    DropdownView(selection: .constant(""), title: "Select Role", placeholder: "Choose a role", options: ["Swimmer", "Lifeguard"])
}
