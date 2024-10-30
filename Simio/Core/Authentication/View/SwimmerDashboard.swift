//
//  SwimmerDashboard.swift
//  Simio
//
//  Created by Dila Dinesha on 2024-10-14.
//

import SwiftUI
struct SwimmerDashboard: View {
    @StateObject var sensorDataVM = SensorDataViewModel.shared
    var swimmer: Swimmer // Pass the swimmer data
    @State private var showAlert = false // State to show alert
    var body: some View {
        VStack {
            if swimmer.isOnline {
                if let sensorData = sensorDataVM.currentSensorData {
                    // Display swimmer's name and profile image
                    VStack {
                        Text("Biometric Data")
                            .font(.largeTitle)
                            .foregroundColor(Color(hex:"03346E"))
                            .fontWeight(.bold)
                            .padding()
                        /*AsyncImage(url: URL(string: swimmer.proimage)) { image in
                         image.resizable()
                         .frame(width: 90, height: 90)
                         .clipShape(Circle())
                         } placeholder: {
                         ProgressView()
                         }*/
                        Text(swimmer.fullname)
                            .font(.system(size: 29))
                            //.padding()
                        //.fontWeight(.medium)
                        
                        // Heart Rate Section
                        VStack {
                            Image(systemName: "heart.fill")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .foregroundColor(sensorData.state.color)
                            //.foregroundColor(.red)
                                .padding()
                            
                            
                            
                            Text("\(sensorData.heartRate) bpm")
                                .font(.largeTitle)
                            //.font(.title)
                                .fontWeight(.medium)
                            //.padding(.top, 10)
                            
                            Text(sensorData.state.description)
                                .font(.title2)
                                .foregroundColor(sensorData.state.color)
                        }
                        .padding(.top,5)
                        
                        // SpO2 Section
                        VStack {
                            Image(systemName: "lungs.fill")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .foregroundColor(sensorData.state.color)
                                .padding()
                            
                            Text("\(sensorData.spo2)% SpO2")
                                .font(.largeTitle)
                                .fontWeight(.medium)
                                //.padding()
                               
                            Text(sensorData.state.description)
                                .font(.title2)
                                .foregroundColor(sensorData.state.color)
                        }
                        .padding(.bottom,30)
                        
                        NavigationLink {
                            GrapheView(swimmer: swimmer)
                        } label: {
                            RoundButton(title: "Graph History") {
                            }
                        }
                        .padding(.top,10)
                    }
                    // Show an alert if sensor data is dangerous
                    
                } else {
                    ProgressView("Loading Biometric Data...")
                }
            } else {
                // Swimmer is offline, show offline image and message
                VStack {
                        Image("no-wifi") // Use the name of your "offline" image
                                        .resizable()
                                        .frame(width: 150, height: 150)
                                        .padding()

                        Text("Currently \(swimmer.fullname) is offline.")
                                        .font(.title)
                                        .foregroundColor(.gray)
                                        .fontWeight(.bold)
                                        .padding()
                    }
            }
        }
        .onAppear {
                 if swimmer.isOnline {
                     sensorDataVM.fetchSensorData(forSwimmerId: swimmer.id) // Fetch sensor data only if swimmer is online
                     print("Fetching sensor data for swimmer ID: \(swimmer.id)")
                     // Trigger alert based on swimmer's state after data is loaded
                     if let sensorData = sensorDataVM.currentSensorData, sensorData.state == .drowningAlert {
                         showAlert = true
                     }
                 }
         }
        .alert(isPresented: $showAlert) {
                   Alert(
                       title: Text("Drowning Alert"),
                       message: Text("\(swimmer.fullname) is showing signs of drowning!"),
                       dismissButton: .default(Text("OK"))
                   )
         }
        .padding(.topInsets)
        .ignoresSafeArea()
        .navigationTitle("")
       // .navigationBarBackButtonHidden(true)

     
    }
    
}

struct SwimmerDashboard_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SwimmerDashboard(swimmer: Swimmer.MOCK_SWIMMER)
        }
    }
}

//4 October 2024 at 00:00:00 UTC+5:30

