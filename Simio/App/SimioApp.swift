//
//  SimioApp.swift
//  Simio
//
//  Created by Dila Dinesha on 2024-09-21.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestoreCombineSwift
import FirebaseFirestore

@main
struct SimioApp: App {
    @StateObject var viewModel =  AuthViewModel()
    //@StateObject var viewModel = AuthViewModel.shared
    
    // Initialize Firebase
       init() {
           FirebaseApp.configure()
           
          #if DEBUG
          let providerFactory = AppCheckDebugProviderFactory()
          AppCheck.setAppCheckProviderFactory(providerFactory)
          #endif
       }
    
    var body: some Scene {
   
        WindowGroup {
            ContentView().environmentObject(viewModel)
        }
    
    }
}
