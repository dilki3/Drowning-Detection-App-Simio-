//
//  User.swift
//  Simio
//
//  Created by Dila Dinesha on 2024-09-21.
//

import Foundation
import FirebaseFirestoreCombineSwift

struct User: Identifiable, Codable {
    
    let id: String
    let fullname: String
    let email: String
    let role: String // Added role field (e.g., "Swimmer" or "Lifeguard")
    //let assignedSwimmers: String?
    let assignedSwimmers: [String]?
    
    var initials: String {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: fullname) {
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        return ""
    }
}

// Extension for a mock user with updated fields
extension User {
    static var MOCK_USER = User(
        id: NSUUID().uuidString,
        fullname: "Dilki Dinesha",
        email: "test@gmail.com",
        role: "Swimmer", // Default role for the mock user
        assignedSwimmers: ["swimmer1ID", "swimmer2ID"] // Default is nil for the mock user
    )
}

