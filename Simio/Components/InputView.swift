//
//  InputView.swift
//  Simio
//
//  Created by Dila Dinesha on 2024-09-21.
//

import SwiftUI

struct InputView: View {
    @Binding var text:String
    let title:String
    let placeholder: String
    var isSecureField = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12)
        {
            Text(title)
                .foregroundColor(Color(.darkGray))
                .fontWeight(.semibold)
                .font(.footnote)
            if isSecureField{
                SecureField(placeholder, text: $text)
                    .font(.system(size: 15))
            }else {
                TextField(placeholder, text: $text)
                    .font(.system(size: 15))
            }
            
            Divider()
        }
    }
}

#Preview {
    InputView(text: .constant(""), title: "Email Address", placeholder: "abc@gmail.com")
}
