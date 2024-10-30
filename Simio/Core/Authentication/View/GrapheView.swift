//
//  GrapheView.swift
//  Simio
//
//  Created by Dila Dinesha on 2024-10-24.
//

import SwiftUI
import Charts

struct GrapheView: View {
    @StateObject var sensorDataVM = SensorDataViewModel.shared
    var swimmer: Swimmer // Pass the swimmer data
    
    var body: some View {
        VStack {
            Text("Heart Rate and\n SpO2 History")
                .font(.largeTitle)
                //.padding(.bottom,5)
                .foregroundColor(Color(hex:"03346E"))
                .fontWeight(.bold)
                .padding()
            VStack{
                // Display heart rate history chart
                if !sensorDataVM.historicalData.isEmpty {
                    // Heart Rate Chart
                    Text("Heart Rate Chart")
                        .font(.system(size: 23))
                        .fontWeight(.medium)
                        .padding()
                    
                    Chart(sensorDataVM.historicalData) { dataPoint in
                        LineMark(
                            x: .value("Date", dataPoint.timestamp),
                            y: .value("Heart Rate", dataPoint.heartRate)
                        )
                        .foregroundStyle(.red)
                        .lineStyle(StrokeStyle(lineWidth: 2))
                    }
                    .frame(height: 200)
                    .padding()
                    
                    // SpO2 Chart
                    Text("SpO2 Chart")
                        .font(.system(size: 23))
                        .fontWeight(.medium)
                        .padding()
                    Chart(sensorDataVM.historicalData) { dataPoint in
                        LineMark(
                            x: .value("Date", dataPoint.timestamp),
                            y: .value("SpO2", dataPoint.spo2)
                        )
                        .foregroundStyle(.blue)
                        .lineStyle(StrokeStyle(lineWidth: 2))
                    }
                    .frame(height: 200)
                    .padding()
                    
                } else {
                    ProgressView("Loading Sensor Data History...")
                }
            }
        }
        .alert(isPresented: $sensorDataVM.showAlert) {
                 Alert (
                     title: Text("Drowning Alert"),
                     message: Text(sensorDataVM.alertMessage),
                     dismissButton: .default(Text("OK"))
                 )
        }
     
        .onAppear {
            sensorDataVM.fetchAllSensorData(forSwimmerId: swimmer.id) // Fetch all data on load
        }
        .padding(.horizontal,10)
        .ignoresSafeArea()
        //.navigationTitle("")
        .padding(.bottom ,50)
       
    }
    
}



#Preview {
    
    GrapheView(swimmer: Swimmer.MOCK_SWIMMER) // Use the mock swimmer instance
            .environmentObject(SensorDataViewModel.shared) // Use the shared view model
}
