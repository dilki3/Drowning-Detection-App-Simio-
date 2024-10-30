//
//  MainTabView.swift
//  Simio
//
//  Created by Dila Dinesha on 2024-10-18.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            
            AlerthistoryView()
                .tabItem {
                    Image(systemName: "clock.fill")
                    Text("History")
                }
            
            ProfileView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
        }
        .accentColor(Color(hex: "044ba0"))
        .navigationTitle("")
        .ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
    NavigationView {
        MainTabView().environmentObject(AuthViewModel())
    }
}
