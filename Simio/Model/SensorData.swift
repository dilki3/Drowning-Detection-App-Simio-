//
//  SensorData.swift
//  Simio
//
//  Created by Dila Dinesha on 2024-10-23.
//

import Foundation
import FirebaseFirestoreCombineSwift
import SwiftUICore

struct SensorData: Identifiable, Codable {
    var id: String // sensorDataId
    let userId: String // swimmer's id
    let heartRate: Int
    let spo2: Int
    let isDrowningDetected: Bool
    var resolved: Bool
    let timestamp: Date

    // Computed property to check if heart rate and SpO2 fall into potential risk or drowning alert categories
    var state: SwimmerState {
        if spo2 < 85 || heartRate < 50 {
            return .drowningAlert
        } else if (spo2 >= 85 && spo2 <= 94) && heartRate > 100 {
            return .potentialRisk
        } else if (spo2 >= 95 && spo2 <= 100) && (heartRate >= 60 && heartRate <= 160) {
            return .normal
        } else {
            return .potentialRisk // For unexpected or non-critical deviations
        }
    }

}

// Enum representing swimmer's condition state
enum SwimmerState {
    case normal
    case potentialRisk
    case drowningAlert

    var description: String {
        switch self {
        case .normal:
            return "Swimmer is healthy and actively moving."
        case .potentialRisk:
            return "Potential Risk: Early drowning or distress detected."
        case .drowningAlert:
            return "Drowning Alert: Immediate action required!"
        }
    }

    var color: Color {
        switch self {
        case .normal:
            return .green
        case .potentialRisk:
            return .orange
        case .drowningAlert:
            return .red
        }
    }
}

// Example SensorData for preview/testing purposes
extension SensorData {
    static var MOCK_SENSOR_DATA = SensorData(id: "1", userId: "1", heartRate: 55, spo2: 88, isDrowningDetected: true, resolved: false, timestamp: Date())
}


