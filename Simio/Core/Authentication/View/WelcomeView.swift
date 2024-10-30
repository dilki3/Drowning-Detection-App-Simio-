//
//  WelcomeView.swift
//  Simio
//
//  Created by Dila Dinesha on 2024-10-07.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        ZStack{
            Image("w12")
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            
            VStack{
                Spacer()
                
                Image("lt")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .padding(.bottom, 15)
                
                Text( "Welcome\nto SimiO App")
                    .font(.system(size:40,weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.bottom,5)
                
                Text( "Monitor your physiological data \nto easily detect drowning situations.")
                   
                    .font(.system(size: 18)) // Specifies the font size
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 30)
                
                NavigationLink {
                    LoginView().navigationBarBackButtonHidden(true)
                } label: {
                   RoundButton(title: "Get Started") {
                    }
                }
                
                Spacer()
                    .frame(height: 80)
            }
            .padding(.horizontal , 20)
        }
        .navigationTitle("")
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .ignoresSafeArea()
    }
        
    
}

#Preview {
    NavigationView {
        WelcomeView()
    }
}

