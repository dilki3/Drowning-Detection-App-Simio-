//
//  Swimmer.swift
//  Simio
//
//  Created by Dila Dinesha on 2024-10-14.
//

import SwiftUI

import Foundation
import FirebaseFirestoreCombineSwift

struct Swimmer: Identifiable, Codable {
    
    //@id var id: String?
    var id: String
    let fullname: String
    let isOnline: Bool
    let proimage: String
    
    var initials: String {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: fullname) {
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        return ""
    }
}

// Example Swimmer for preview/testing purposes
extension Swimmer {
    static var MOCK_SWIMMER = Swimmer(id: "KskcVLCy1IGMTBH3260y", fullname: "Dilki Dinesha", isOnline: true, proimage: "https://firebasestorage.googleapis.com/v0/b/simio-16ae8.appspot.com/o/swimmerimage%2Fg1.jpeg?alt=media&token=dadddb4e-3e64-45cb-9a5f-4cd5895efc3c")
}

