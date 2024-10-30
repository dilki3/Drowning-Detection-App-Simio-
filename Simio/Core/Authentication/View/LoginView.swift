//
//  LoginView.swift
//  Simio
//
//  Created by Dila Dinesha on 2024-09-21.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
   
    @State private var navigateToSwimmerDashboard = false
    @State private var navigateToLifeguardDashboard = false
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        NavigationStack{
            VStack {
                // Image at the top
                    Image("lt")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50)
                        .padding(.bottom, 40)
                        .padding(.top, 20)
                    
                    
                    Text("Sign In")
                        .font(.system(size: 26))
                        .foregroundColor(.black)
                        .fontWeight(.bold)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 5)
                    
                    Text("Please Enter your email and password")
                        .font(.system(size: 15))
                        .foregroundColor(.black)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, .screenWidth * 0.09)
                    
                    InputView(text: $email,
                              title: "Email Address",
                              placeholder: "name@example.com")
                    .autocapitalization(.none)
                    
                    InputView(text: $password,
                              title: "Password",
                              placeholder: "enter your password",
                              isSecureField: true)
                    
                    
                    Text("Forgot Password?")
                        .font(.system(size: 16))
                        .foregroundColor(.red)
                    
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
                        .padding(.bottom, .screenWidth * 0.03)
              
                    // Sign-In Button
                    Button {
                        /*Task {
                         do {
                         print("debug: Attempting to sign in with \(email)")
                         try await viewModel.signIn(withEmail: email, password: password)
                         
                         print("debug: Successfully signed in")
                         } catch {
                         print("debug: Failed to sign in with error: \(error.localizedDescription)")
                         errorMessage = "Failed to sign in. Please check your credentials."
                         }
                         }*/
                        Task {
                             do {
                                 print("debug: Attempting to sign in with \(email)")
                                 try await viewModel.signIn(withEmail: email, password: password)
                                 
                               
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
                    .background(Color(hex:"03346E"))
                    .cornerRadius(10)
                    .padding(.top, 24)
                    .disabled(!formIsValid)
                    .opacity(formIsValid ? 1.0 : 0.5)
                    
                    Spacer()
                // Error message
                    if !errorMessage.isEmpty {
                        Text(errorMessage)
                            .foregroundColor(.red)
                    }

                    // Navigation links
                    /*NavigationLink(destination: SwimmerDashboardView(), isActive: $navigateToSwimmerDashboard) {
                        EmptyView()
                    }

                    NavigationLink(destination: DashboardView(), isActive: $navigateToLifeguardDashboard) {
                        EmptyView()
                    }*/
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
                        .font(.system(size: 15))
                    }
                }
                .padding()
                
            }
      
        }
          var formIsValid: Bool {
                return !email.isEmpty &&
               email.contains("@") &&
               !password.isEmpty
         
          }
   }


#Preview {
    NavigationView
    {
        LoginView().environmentObject(AuthViewModel())
    }
}

