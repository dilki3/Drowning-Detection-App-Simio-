//
//  DashboardViewModel.swift
//  Simio
//
//  Created by Dila Dinesha on 2024-10-14.
//

import SwiftUI

import Foundation
import FirebaseFirestore
import FirebaseAuth
import FirebaseFirestoreCombineSwift
import FirebaseStorage

class DashboardViewModel: ObservableObject {
    
    static let shared = DashboardViewModel()
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    //@Published var selectTab: Int = 0
    
    @Published var txtSearch = ""
    @Published var filterStatus = "All"
    @Published var swimmers: [Swimmer] = []
    @Published var filteredSwimmers: [Swimmer] = []
    var filterOptions: [String] = ["All", "Online", "Offline"]
      
  
    
    init() {
        // Initial data fetch
        applyFilters()
        Task {
            await fetchAssignedSwimmers()
        }
    }
    

    // Fetch assigned swimmers from Firebase
    func fetchAssignedSwimmers() async {
        guard let currentUser = Auth.auth().currentUser else { return }
        
        do {
            let userDoc = try await Firestore.firestore().collection("users").document(currentUser.uid).getDocument()
            
            if let userData = userDoc.data(),
               let assignedSwimmersIds = userData["assignedSwimmers"] as? [String] {
                
                var tempSwimmers: [Swimmer] = []
                for swimmerId in assignedSwimmersIds {
                    let swimmerDoc = try await Firestore.firestore().collection("Swimmer").document(swimmerId).getDocument()
                    
                    // Direct assignment without 'if let'
                    if let swimmerData = try? swimmerDoc.data(as: Swimmer.self) {
                        tempSwimmers.append(swimmerData)
                    }
                }
                
                DispatchQueue.main.async {
                    self.swimmers = tempSwimmers
                    self.applyFilters()
                }
            }
        } catch {
            print("Failed to fetch swimmers: \(error.localizedDescription)")
        }
    }

    
    // Filter swimmers based on search text and status
    func applyFilters() {
            filteredSwimmers = swimmers.filter { swimmer in
                (txtSearch.isEmpty || swimmer.fullname.lowercased().contains(txtSearch.lowercased())) &&
                (filterStatus == "All" || (filterStatus == "Online" && swimmer.isOnline) || (filterStatus == "Offline" && !swimmer.isOnline))
            }
        }
    func fetchProfileImage(for swimmer: Swimmer, completion: @escaping (String?) -> Void) {
            let storage = Storage.storage()
            let storageRef = storage.reference().child("profile_images/\(swimmer.id).jpg") // Assuming profile images are stored by swimmer ID

            // Download the image URL
            storageRef.downloadURL { url, error in
                if let error = error {
                    print("Error fetching image URL: \(error)")
                    completion(nil)
                } else if let urlString = url?.absoluteString {
                    completion(urlString)
                }
            }
        }
}

