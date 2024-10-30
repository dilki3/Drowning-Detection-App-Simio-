//
//  LoginView.swift
//  Simio
//
//  Created by Dila Dinesha on 2024-09-21.
//

import SwiftUI

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
    
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                // Image at the top
                Image("swimming-man")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 120)
                    .padding(.vertical, 32)
                
                // Form Fields for Email and Password
                VStack {
                    InputView(text: $email,
                              title: "Email Address",
                              placeholder: "name@example.com")
                        .autocapitalization(.none)
                    
                    InputView(text: $password,
                              title: "Password",
                              placeholder: "enter your password",
                              isSecureField: true)
                }
                .padding(.horizontal)
                .padding(.top, 12)
                
                // Display error message if any
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding(.top, 8)
                }
                
                // Sign-In Button
                Button {
                    Task {
                        do {
                            print("debug: Attempting to sign in with \(email)")
                            try await viewModel.signIn(withEmail: email, password: password)
                            
                            print("debug: Successfully signed in")
                        } catch {
                            print("debug: Failed to sign in with error: \(error.localizedDescription)")
                            errorMessage = "Failed to sign in. Please check your credentials."
                        }
                    }
                } label: {
                    HStack {
                        Text("SIGN IN")
                            .fontWeight(.semibold)
                        Image(systemName: "arrow.right")
                    }
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                }
                .background(Color(.systemCyan))
                .cornerRadius(10)
                .padding(.top, 24)
               // .disabled(!formIsValid)  // Disable button if form is invalid
                //.opacity(formIsValid ? 1.0 : 0.5)
                
                Spacer()
                
                // Navigation Link to Registration
                NavigationLink {
                    RegistrationView()
                        .navigationBarBackButtonHidden(true)
                } label: {
                    HStack(spacing: 3) {
                        Text("Don't have an account?")
                        Text("Sign Up")
                            .fontWeight(.bold)
                    }
                    .font(.system(size: 14))
                }
            }
            // Navigation to ProfileView based on userSession
          
        }
    }
}

// Authentication Validation



#Preview {
    LoginView().environmentObject(AuthViewModel())
}
