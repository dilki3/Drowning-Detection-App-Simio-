//
//  ProfileView.swift
//  Simio
//
//  Created by Dila Dinesha on 2024-09-21.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel : AuthViewModel
    var body: some View {
        if let user = viewModel.currentUser{
            List{
                Section{
                    HStack{
                        Text(user.initials)
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(width: 72, height: 72)
                            .background(Color(hex:"03346E"))
                            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                        
                        VStack(alignment: .leading,spacing: 5){
                            Text(user.fullname)
                                .font(.title2)
                                .fontWeight(.semibold)
                                .padding(.top, 4)
                            Text(user.email)
                                .font(.system(size: 18))
                                .foregroundColor(.gray)
                        }
                        .padding(10)
                    }
                    //.padding(.leading, 10)
                    .padding(.vertical,10)
                }
                Section("General"){
                    HStack{
                        SettingsRowView(imageName: "gear", title: "Version", tintColor: Color(Color(hex:"6EACDA")))
                        Spacer()
                        
                        Text ("1.0.0")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                    }
                    
                }
                Section("Account"){
                   
                    HStack{
                        SettingsRowView(imageName: "shield.fill", title: "Privacy Policy", tintColor: Color(Color(hex:"6EACDA")))
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.black)
                            .font(.system(size: 14))
                            .padding(.trailing, 7)
                        
                    }
                    HStack{
                        SettingsRowView(imageName: "info.circle.fill", title: "About", tintColor: Color(Color(hex:"6EACDA")))
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.black)
                            .font(.system(size: 14))
                            .padding(.trailing, 7)
                        
                    }
                    HStack{
                        SettingsRowView(imageName: "questionmark.circle.fill", title: "Help", tintColor: Color(Color(hex:"6EACDA")))
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.black)
                            .font(.system(size: 14))
                            .padding(.trailing, 7)
                        
                    }
                    Button{
                        viewModel.signOut()
                    }label: {
                        HStack{
                            SettingsRowView(imageName: "arrow.left.circle.fill", title: "Sign Out", tintColor: Color(Color(hex:"6EACDA")))
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.black)
                                .font(.system(size: 14))
                                .padding(.trailing, 7)
                            
                        }
                    }
                    
                    Button{
                        print("Delete account..")
                    }label: {
                        SettingsRowView(imageName: "xmark.circle.fill", title: "Delete Account", tintColor: .red)
                    }
                }
            }
        }
    }
}

#Preview {
    ProfileView().environmentObject(AuthViewModel())
}
