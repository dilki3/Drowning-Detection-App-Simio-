//
//  AuthViewModel.swift
//  Simio
//
//  Created by Dila Dinesha on 2024-09-21.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestoreCombineSwift
import FirebaseFirestore


@MainActor
class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
    init() {
        self.userSession = Auth.auth().currentUser
        
        Task {
            await fetchUser()
        }
    }
    
    // Create User (Sign Up)
    func createUser(withEmail email: String, password: String, fullname: String, role: String) async throws {
        do {
            // Create Firebase user
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            
            // Create user document in Firestore
            let user = User(id: result.user.uid, fullname: fullname, email: email, role: role, assignedSwimmers: nil)
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            
            await fetchUser()  // Fetch the created user data
            
            // Navigate after sign up based on role
            if role == "Swimmer" {
                // Navigate to swimmer dashboard
                // Your navigation code here
            } else if role == "Lifeguard" {
                // Navigate to lifeguard dashboard
                // Your navigation code hernil
            }
        } catch {
            print("Error creating user: \(error.localizedDescription)")
            throw error
        }
    }
    
    // Sign In (Login)
    func signIn(withEmail email: String, password: String) async throws {
        do {
            // Firebase sign-in
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()  // Fetch the signed-in user's data
            
            // Navigate based on user role
            /*if let role = currentUser?.role {
                if role == "Swimmer" {
                    // Navigate to swimmer dashboard
                    // Your navigation code here
                } else if role == "Lifeguard" {
                    // Navigate to lifeguard dashboard
                    // Your navigation code here
                }
            }*/
        } catch {
            print("Failed to sign in: \(error.localizedDescription)")
            throw error
        }
    }
    
    // Fetch User Data from Firestore
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        do {
            // Retrieve user data from Firestore
            let snapshot = try await Firestore.firestore().collection("users").document(uid).getDocument()
            self.currentUser = try snapshot.data(as: User.self)
        } catch {
            print("Failed to fetch user: \(error.localizedDescription)")
        }
    }
    
    // Sign Out
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.userSession = nil
            self.currentUser = nil
        } catch {
            print("Failed to sign out: \(error.localizedDescription)")
        }
    }
}
