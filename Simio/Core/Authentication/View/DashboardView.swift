//
//  DashboardView.swift
//  Simio
//
//  Created by Dila Dinesha on 2024-10-11.
//

import SwiftUI

struct DashboardView: View {
    @StateObject var dashVM = DashboardViewModel.shared
    @StateObject var sensorDataVM = SensorDataViewModel.shared
    // States for dropdown handling
    @State private var showFilterDropdown = false
    @State private var selectedFilter: String = "All"
    
    var body: some View {
        ZStack {
            //ScrollView {
                VStack {
                    Image("lt")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                    
                    HStack {
                        Image("location")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16, height: 16)
                        
                        Text("Colombo 1, Sri Lanka")
                            .font(.system(size: 16))
                            .foregroundColor(Color(hex: "#A9A9A9"))
                    }
                    
                    HStack {
                        // Search text field
                        SearchTextField(placholder: "Search Swimmer", txt: $dashVM.txtSearch)
                            .padding(.leading, 15) // Padding on the leading side for consistent spacing
                            .padding(.vertical, 10) // Add some vertical padding for better UI appearance
                            .onChange(of: dashVM.txtSearch, perform: { _ in
                                dashVM.applyFilters() // Apply filters when search text changes
                            })
                        
                        Spacer() // This pushes the filter picker to the right side
                        
                        // Filter Picker with Icon
                        Menu {
                            VStack(alignment: .leading, spacing:0) {
                                Picker("Filter", selection: $selectedFilter) {
                                    ForEach(dashVM.filterOptions, id: \.self) { filter in
                                        Text(filter)
                                            .tag(filter)
                                    }
                                }
                                
                                // Apply filter when selection changes
                                .onChange(of: selectedFilter) { newValue in
                                    dashVM.filterStatus = newValue
                                    dashVM.applyFilters()
                                }
                                // Set the width of the Picker options
                            }
                            //.pickerStyle(MenuPickerStyle())
                        } label: {
                            HStack {
                                Image(systemName: "slider.horizontal.3")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 22, height: 22)
                                    .foregroundColor(.black)
                            }
                            .padding(8)
                            //.background(Color(hex: "#EFEFEF"))
                            .cornerRadius(8)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .foregroundColor(Color(hex: "e8f5ff")) // Blue border around the rectangle
                            )
                        }
                        //.offset(y: 2)
                        .padding(.trailing, 15)
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    ScrollView(.vertical,showsIndicators: false){
                        VStack(alignment: .leading) {
                            ForEach(dashVM.filteredSwimmers) { swimmer in
                                // Entire row wrapped in a navigation link to go to SwimmerDetailView
                                NavigationLink(destination: SwimmerDashboard(swimmer: swimmer)) {
                                    HStack {
                                        // Left side: Initials inside a circle
                                        HStack {
                                            
                                            if swimmer.proimage.isEmpty {
                                                Text(swimmer.initials)
                                                    .font(.system(size: 18))
                                                    .fontWeight(.bold)
                                                    .frame(width: 70, height: 70)
                                                    .background(Color.gray.opacity(0.3))
                                                    .clipShape(Circle())
                                                
                                            } else {
                                                AsyncImage(url: URL(string:swimmer.proimage)) { phase in
                                                    if let image = phase.image {image.resizable()
                                                            .aspectRatio(contentMode: .fill)
                                                            .frame(width: 70, height: 70)
                                                            .clipShape(Circle())
                                                    } else if phase.error != nil {
                                                        Text(swimmer.initials)
                                                            .font(.system(size: 18))
                                                            .fontWeight(.bold)
                                                            .frame(width: 70, height: 70)
                                                            .background(Color.gray.opacity(0.3))
                                                            .clipShape(Circle())
                                                    } else {
                                                        ProgressView()
                                                            .frame(width: 70, height: 70)
                                                    }
                                                }
                                            }
                                            
                                            VStack  {
                                                // Swimmer's name
                                                Text(swimmer.fullname)
                                                    .font(.system(size: 17))
                                                    .fontWeight(.medium)
                                                //.padding(.leading, 10)
                                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                                
                                                HStack(spacing: 6) {
                                                    
                                                    Circle()
                                                        .fill(swimmer.isOnline ? Color.green : Color.red)
                                                        .frame(width: 10, height: 10)
                                                    Text(swimmer.isOnline ? "Online" : "Offline")
                                                        .font(.system(size: 14))
                                                        .foregroundColor(.gray)
                                                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                                }
                                                
                                            }
                                            .padding(.leading,5)
                                            
                                        }
                                        
                                        
                                        
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.black)
                                            .font(.system(size: 14))
                                            .padding(.trailing, 7)
                                        
                                        
                                    }
                                    .padding(.vertical,10)
                                    .padding(.horizontal,10)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.blue, lineWidth: 1)
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                                .padding(.vertical,2)
                                .padding(.horizontal,3)
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    
                }
                .padding(.top, .topInsets)
                .padding(.bottom, 100)
            //}
        }
        .ignoresSafeArea()
        .navigationTitle("")
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        //.ignoresSafeArea()
        .alert(isPresented: $sensorDataVM.showAlert) {
                   Alert(
                       title: Text("Drowning Alert"),
                       message: Text(sensorDataVM.alertMessage),
                       dismissButton: .default(Text("Acknowledge"), action: {
                           sensorDataVM.showAlert = false
                       })
                   )
               }
               .onAppear {
                   sensorDataVM.startListeningForNewDrowningAlerts() // Start listener when Dashboard appears
               }
               .onDisappear {
                   sensorDataVM.stopListeningForNewDrowningAlerts() // Stop listener when Dashboard disappears
               }
    }
}


#Preview {
    
    NavigationView{
        DashboardView()
    }
    
}
