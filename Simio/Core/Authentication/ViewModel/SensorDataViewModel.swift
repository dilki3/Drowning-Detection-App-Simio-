//
//  SensorDataViewModel.swift
//  Simio
//
//  Created by Dila Dinesha on 2024-10-23.
//

import Foundation
import Combine
import FirebaseFirestore
import FirebaseFirestoreCombineSwift

class SensorDataViewModel: ObservableObject {
    @Published var sensorData: [SensorData] = [] // Stores all the fetched sensor data
        @Published var currentSensorData: SensorData?
        @Published var historicalData: [SensorData] = []
        @Published var drowningAlertHistory: [(sensorData: SensorData, swimmerFullName: String)] = [] // Store historical data with swimmer names

        private var db = Firestore.firestore() // Firestore database reference
        private var cancellables = Set<AnyCancellable>() // For Combine subscriptions
        @Published var showAlert: Bool = false
        @Published var alertMessage: String = ""
        private var listener: ListenerRegistration?
        
        // Shared instance for accessing the view model
        static let shared = SensorDataViewModel()

        // Fetch sensor data for a specific swimmer
        func fetchSensorData(forSwimmerId swimmerId: String) {
            db.collection("SensorData")
                .whereField("userId", isEqualTo: swimmerId)
                .order(by: "timestamp", descending: true)
                .limit(to: 1)
                .addSnapshotListener { [weak self] querySnapshot, error in
                    if let error = error {
                        print("Error fetching sensor data: \(error.localizedDescription)")
                        return
                    }
                    guard let documents = querySnapshot?.documents else { return }
                    let sensorDataList = documents.compactMap { try? $0.data(as: SensorData.self) }
                    self?.sensorData = sensorDataList
                    self?.currentSensorData = sensorDataList.first // Set the latest sensor data
                }
        }

        // Simulate data for preview/testing purposes
        func loadMockData() {
            self.sensorData = [SensorData.MOCK_SENSOR_DATA]
            self.currentSensorData = SensorData.MOCK_SENSOR_DATA
        }

        // Fetch all historical data for a specific swimmer
        func fetchAllSensorData(forSwimmerId swimmerId: String) {
            db.collection("SensorData")
                .whereField("userId", isEqualTo: swimmerId)
                .order(by: "timestamp", descending: false) // Order by timestamp for historical data
                .getDocuments()
                .tryMap { querySnapshot in
                    try querySnapshot.documents.compactMap { document in
                        try document.data(as: SensorData.self) // Parse Firestore data into SensorData model
                    }
                }
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        print("Error fetching sensor data: \(error.localizedDescription)")
                    case .finished:
                        break
                    }
                }, receiveValue: { [weak self] sensorDataList in
                    self?.historicalData = sensorDataList // Store historical data
                })
                .store(in: &cancellables)
        }

        // Start real-time listener for new drowning alerts
        func startListeningForNewDrowningAlerts() {
            listener = db.collection("SensorData")
                .whereField("isDrowningDetected", isEqualTo: true)
                .addSnapshotListener { [weak self] (snapshot, error) in
                    if let error = error {
                        print("Error listening for drowning alerts: \(error)")
                        return
                    }
                    
                    for documentChange in snapshot?.documentChanges ?? [] {
                        if documentChange.type == .added,
                           let data = try? documentChange.document.data(as: SensorData.self) {
                            
                            // Fetch the swimmer's full name using the userId
                            self?.fetchSwimmerFullName(swimmerId: data.userId) { fullName in
                                DispatchQueue.main.async {
                                    self?.showAlert = true
                                    self?.alertMessage = "Drowning detected for Swimmer: \(fullName)"
                                    // Store both the sensor data and full name in the history
                                    self?.drowningAlertHistory.insert((sensorData: data, swimmerFullName: fullName), at: 0)
                                }
                            }
                        }
                    }
                }
        }

        // Stop the listener when not needed
        func stopListeningForNewDrowningAlerts() {
            listener?.remove()
            listener = nil
        }

        // Fetch entire history of drowning alerts
        func fetchDrowningAlertHistory() {
            db.collection("SensorData")
                .whereField("isDrowningDetected", isEqualTo: true)
                .order(by: "timestamp", descending: true)
                .getDocuments { [weak self] (snapshot, error) in
                    if let error = error {
                        print("Error fetching drowning alert history: \(error)")
                        return
                    }
                    
                    self?.drowningAlertHistory.removeAll() // Clear existing history
                    
                    let fetchGroup = DispatchGroup() // Group for fetching names
                    
                    for document in snapshot?.documents ?? [] {
                        if let data = try? document.data(as: SensorData.self) {
                            fetchGroup.enter()
                            self?.fetchSwimmerFullName(swimmerId: data.userId) { fullName in
                                DispatchQueue.main.async {
                                    // Append the sensor data and full name as a tuple
                                    self?.drowningAlertHistory.append((sensorData: data, swimmerFullName: fullName))
                                    fetchGroup.leave()
                                }
                            }
                        }
                    }
                    
                    fetchGroup.notify(queue: .main) {
                        // Handle any actions after all names are fetched, if needed
                        print("All swimmer names fetched for drowning alert history.")
                    }
                }
        }

        private func fetchSwimmerFullName(swimmerId: String, completion: @escaping (String) -> Void) {
            db.collection("Swimmer").document(swimmerId).getDocument { (document, error) in
                if let document = document, document.exists, let data = document.data() {
                    let fullName = data["fullname"] as? String ?? "Unknown Swimmer"
                    completion(fullName)
                } else {
                    print("Swimmer document not found or error: \(error?.localizedDescription ?? "Unknown error")")
                    completion("Unknown Swimmer")
                }
            }
        }
    func deleteDrowningAlert(_ alertId: String) {
        // Assuming you have a reference to the Firestore database
        db.collection("SensorData").document(alertId).delete { error in
            if let error = error {
                print("Error deleting document: \(error)")
            } else {
                // Remove the alert from the local array
                self.drowningAlertHistory.removeAll { $0.sensorData.id == alertId }
                print("Drowning alert deleted successfully.")
            }
        }
    }

}
