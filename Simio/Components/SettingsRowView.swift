//
//  SettingsRowView.swift
//  Simio
//
//  Created by Dila Dinesha on 2024-09-21.
//

import SwiftUI

struct SettingsRowView: View {
    let imageName: String
    let title: String
    let tintColor: Color
    var body: some View {
        HStack(spacing: 12){
            Image(systemName: imageName)
                .imageScale(.medium)
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .foregroundColor(tintColor)
            Text(title)
                .font(.system(size: 17))
                .foregroundColor(.black)
            
        }
        .padding(10)
    }
}

#Preview {
    SettingsRowView(imageName: "gear", title: "Version", tintColor: Color(Color(hex:"1E3E62")))
}
