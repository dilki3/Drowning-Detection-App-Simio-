//
//  DashboardView.swift
//  Simio
//
//  Created by Dila Dinesha on 2024-10-11.
//

import SwiftUI

struct DashboardView: View {
    @StateObject var dashVM = DashboardViewModel.shared
    
    var body: some View {
        ZStack{
            ScrollView {
                VStack(alignment: .leading) {
                    Image("drowning")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                    
                    HStack {
                        Image(systemName: "location.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16, height: 16)
                        
                        Text("Colombo 1, Sri Lanka")
                            .font(.system(size: 18))
                            .foregroundColor(Color(hex: "#A9A9A9"))
                    }
                    
                    SearchTextField(placholder: "Search Swimmer", txt: $dashVM.txtSearch)
                        .padding(.horizontal, 15)
                        .padding(.vertical, 10)
                    
                    // Filter options (bottom of search field)
                    HStack {
                        Button("Online") {
                            dashVM.filterStatus = "Online"
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(dashVM.filterStatus == "Online" ? Color.blue : Color.gray)
                        .cornerRadius(8)
                        .foregroundColor(.white)
                        
                        Button("Offline") {
                            dashVM.filterStatus = "Offline"
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(dashVM.filterStatus == "Offline" ? Color.blue : Color.gray)
                        .cornerRadius(8)
                        .foregroundColor(.white)
                    }
                    .padding(.horizontal)
                    
                    // Display assigned swimmers
                    ForEach(dashVM.filteredSwimmers, id: \.id) { swimmer in
                        HStack {
                            // Circle with swimmer's first letter
                            Circle()
                                .fill(Color(hex: "#CCCCCC"))
                                .frame(width: 40, height: 40)
                                .overlay(
                                    Text(swimmer.initials)
                                        .font(.system(size: 24))
                                        .foregroundColor(.black)
                                )
                            
                            VStack(alignment: .leading) {
                                Text(swimmer.fullname)
                                    .font(.system(size: 18))
                                    .foregroundColor(.black)
                                
                                // Show status
                                Text(swimmer.isOnline ? "Online" : "Offline")
                                    .foregroundColor(swimmer.isOnline ? .green : .red)
                                    .font(.system(size: 14))
                            }
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                    }
                }
                .padding(.top, 30)
            }
        }
        .onAppear {
            Task {
                await dashVM.fetchAssignedSwimmers()
            }
        }
    }
}



#Preview {
    
    DashboardView()
}
