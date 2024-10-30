//
//  ContentView.swift
//  Simio
//
//  Created by Dila Dinesha on 2024-09-21.
//

import SwiftUI
import Firebase


struct ContentView: View {
    @EnvironmentObject var viewModel : AuthViewModel

    var body: some View {
        Group {
             
            NavigationView {
                if viewModel.userSession != nil {
                    // Wrap in NavigationView if not done
                    // DashboardView()  // Navigate to ProfileView when signed in
                    
                    if let role = viewModel.currentUser?.role {
                        
                        if role == "Swimmer" {
                            ProfileView()
                        } else if role == "Lifeguard" {
                            MainTabView()
                        }
                    }
                    
                } else {
                    WelcomeView()  // Show LoginView when not signed in
                }
            }
        }
    }
}

#Preview {
    
        ContentView().environmentObject(AuthViewModel())
    
}
