//
//  RegistrationView.swift
//  Simio
//
//  Created by Dila Dinesha on 2024-09-21.
//


import SwiftUI

struct RegistrationView: View {
    @State private var email = ""
    @State private var fullname = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var role = "Swimmer"
    @State private var navigateToSwimmerDashboard = false
    @State private var navigateToLifeguardDashboard = false
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        VStack {
            Image("lt")
                .resizable()
                .scaledToFill()
                .frame(width: 50, height: 50)
                .padding(.vertical, 20)
                .padding(.top, 20)
            // Form Fields
            VStack {
                Text("Sign Up")
                    .fontWeight(.bold)
                    .font(.system(size: 26))
                    .foregroundColor(.black)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 7)
                Text("Enter your credentials to continue")
                    .font(.system(size: 14))
                    .foregroundColor(.black)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom,20)
                                   
                InputView(text: $email, title: "Email Address", placeholder: "name@example.com")
                    .autocapitalization(.none)
                
                InputView(text: $fullname, title: "Full Name", placeholder: "Enter your Name")
                
                InputView(text: $password, title: "Password", placeholder: "Enter your password", isSecureField: true)
                
                InputView(text: $confirmPassword, title: "Confirm Password", placeholder: "Confirm your password", isSecureField: true)
                
                // Role Picker
                DropdownView(
                    selection: $role,
                    title: "Select Role",
                    placeholder: "Choose a role",
                    options: ["Swimmer", "Lifeguard"]
                )
            }
            .padding(.horizontal)
            .padding(.top, 12)
            // Sign-Up Button
            Button {
                /*Task {
                    if formIsValid {
                        do {
                            // Pass selectedLifeguards' IDs for swimmer
                            try await viewModel.createUser(
                                withEmail: email,
                                password: password,
                                fullname: fullname,
                                role: role,
                                assignedLifeguardIds: selectedLifeguards.map { $0.id }
                            )
                            dismiss() // Dismiss and go to the login page
                        } catch {
                            print("Error creating user: \(error.localizedDescription)")
                        }
                    }
                }*/
                Task {
                     if formIsValid {
                         do {
                             try await viewModel.createUser(
                                 withEmail: email,
                                 password: password,
                                 fullname: fullname,
                                 role: role
                             )
                             // Handle successful sign-up (e.g., navigate to dashboard)
                             // Navigate based on the user's role
                             if role == "Swimmer" {
                                 navigateToSwimmerDashboard = true
                                 
                             } else if role == "Lifeguard" {
                                 navigateToLifeguardDashboard = true
                                 
                             }
                         } catch {
                             print("Error signing up: \(error.localizedDescription)")
                         }
                     }
                 }
            } label: {
                HStack {
                    Text("SIGN UP")
                        .fontWeight(.semibold)
                    Image(systemName: "arrow.right")
                }
                .foregroundColor(.white)
                .frame(width: UIScreen.main.bounds.width - 32, height: 48)
            }
            //.background(Color(.systemCyan))
            .background(Color(hex:"03346E"))
            .disabled(!formIsValid)
            .opacity(formIsValid ? 1.0 : 0.5)
            .cornerRadius(10)
            .padding(.top, 24)
            
            Spacer()
            
            NavigationLink(destination: ProfileView(), isActive: $navigateToSwimmerDashboard) {
                     EmptyView()
                 }
            NavigationLink(destination: DashboardView().navigationBarBackButtonHidden(true), isActive: $navigateToLifeguardDashboard) {
                     EmptyView()
                 }
            
            NavigationLink(destination: LoginView().navigationBarBackButtonHidden(true))
            {
                        HStack(spacing: 3) {
                            Text("Already have an account?")
                            Text("Sign In")
                                .fontWeight(.bold)
                        }
                        .font(.system(size: 15))
                        //.foregroundColor(.black)
                    }
        }
    }
    // Form validation
    var formIsValid: Bool {
        return !email.isEmpty &&
            email.contains("@") &&
            !password.isEmpty &&
            password.count > 5 &&
            !fullname.isEmpty &&
            confirmPassword == password &&
            !role.isEmpty
    }
}

// Authentication validation

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            RegistrationView().environmentObject(AuthViewModel())
        }
    }
}
