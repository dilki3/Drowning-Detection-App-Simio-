//
//  AlerthistoryView.swift
//  Simio
//
//  Created by Dila Dinesha on 2024-10-24.
//

import SwiftUI
import FirebaseFirestore
import SwiftUI

struct AlerthistoryView: View {
    @ObservedObject var sensorDataVM = SensorDataViewModel.shared // Assuming you have a shared instance of the ViewModel

    var body: some View {
        VStack {
            Text("Drowning Alert History")
                .font(.title2)
                //.padding(.bottom,5)
                .foregroundColor(Color(hex:"03346E"))
                .fontWeight(.bold)
                .padding()
            List {
                
                ForEach(sensorDataVM.drowningAlertHistory, id: \.sensorData.id) { alert in
                    HStack {
                        VStack(alignment: .leading) {
                            // Display the swimmer's full name
                            Text("Swimmer: \(alert.swimmerFullName)")
                                .font(.headline)
                            
                            // Display the alert timestamp
                            Text("Date: \(alert.sensorData.timestamp, formatter: dateFormatter)")
                                .font(.subheadline)
                            
                            // Display the swimmer's condition state
                            Text(alert.sensorData.state.description)
                                .foregroundColor(alert.sensorData.state.color)
                        }
                        Spacer()
                        // Delete button
                        Button(action: {
                            // Call the delete function
                            sensorDataVM.deleteDrowningAlert(alert.sensorData.id)
                        }) {
                            Image(systemName: "trash")
                                .foregroundColor(.red) // Optional: Change color for better visibility
                        }
                        .buttonStyle(PlainButtonStyle()) // Optional: Style for the button
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .navigationTitle("Drowning Alert History") // Optional: Set the title for navigation
        .onAppear {
            sensorDataVM.fetchDrowningAlertHistory() // Fetch the alert history when the view appears
        }
    }
}


private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return formatter
}()


#Preview {
    AlerthistoryView()
}
