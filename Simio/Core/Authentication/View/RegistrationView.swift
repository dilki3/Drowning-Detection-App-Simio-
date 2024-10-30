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
    @State private var showLifeguardSelection = false
    @State private var selectedLifeguards: [Lifeguard] = []
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        VStack {
            Image("swimming-man")
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 120)
                .padding(.vertical, 3)
            
            // Form Fields
            VStack {
                InputView(text: $email, title: "Email Address", placeholder: "name@example.com")
                    .autocapitalization(.none)
                
                InputView(text: $fullname, title: "Full Name", placeholder: "Enter your Name")
                
                InputView(text: $password, title: "Password", placeholder: "Enter your password", isSecureField: true)
                
                InputView(text: $confirmPassword, title: "Confirm Password", placeholder: "Confirm your password", isSecureField: true)
                
                // Role Picker
                Picker("Select Role", selection: $role) {
                    Text("Swimmer").tag("Swimmer")
                    Text("Lifeguard").tag("Lifeguard")
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                // Show lifeguard selection button if role is Swimmer
                if role == "Swimmer" {
                    Button(action: {
                        showLifeguardSelection = true
                    }) {
                        Text("Select Lifeguards")
                    }
                    .sheet(isPresented: $showLifeguardSelection) {
                        LifeguardSelectionView(selectedLifeguards: $selectedLifeguards)
                    }
                }
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
            } label: {
                HStack {
                    Text("SIGN UP")
                        .fontWeight(.semibold)
                    Image(systemName: "arrow.right")
                }
                .foregroundColor(.white)
                .frame(width: UIScreen.main.bounds.width - 32, height: 48)
            }
            .background(Color(.systemCyan))
            .disabled(!formIsValid)
            .opacity(formIsValid ? 1.0 : 0.5)
            .cornerRadius(10)
            .padding(.top, 24)
            
            Spacer()
            
            Button {
                dismiss()
            } label: {
                HStack(spacing: 3) {
                    Text("Already have an account?")
                    Text("Sign In")
                        .fontWeight(.bold)
                }
                .font(.system(size: 14))
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
            (role != "Swimmer" || selectedLifeguards.count > 0) // Ensure at least one lifeguard is selected for swimmers
    }
}

// Lifeguard selection modal view
struct LifeguardSelectionView: View {
    @Binding var selectedLifeguards: [Lifeguard]
    
    // Sample lifeguard data (this should come from Firestore in a real app)
    let lifeguards = [
        Lifeguard(id: "1", fullname: "Lifeguard 1", photo: "person.circle"),
        Lifeguard(id: "2", fullname: "Lifeguard 2", photo: "person.circle"),
        Lifeguard(id: "3", fullname: "Lifeguard 3", photo: "person.circle")
    ]
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Text("Select Lifeguards (1-2)")
                .font(.headline)
                .padding()
            
            List(lifeguards, id: \.id) { lifeguard in
                HStack {
                    Image(systemName: lifeguard.photo)
                        .resizable()
                        .frame(width: 40, height: 40)
                    
                    Text(lifeguard.fullname)
                    
                    Spacer()
                    
                    if selectedLifeguards.contains(where: { $0.id == lifeguard.id }) {
                        Image(systemName: "checkmark")
                            .foregroundColor(.green)
                    }
                }
                .onTapGesture {
                    toggleLifeguardSelection(lifeguard)
                }
            }
            
            Button("Confirm") {
                dismiss() // Dismiss the modal
            }
            .padding()
            .disabled(selectedLifeguards.count == 0) // Disable confirm button if no lifeguard is selected
        }
    }
    
    // Toggle selection of lifeguards
    func toggleLifeguardSelection(_ lifeguard: Lifeguard) {
        if selectedLifeguards.contains(where: { $0.id == lifeguard.id }) {
            selectedLifeguards.removeAll { $0.id == lifeguard.id }
        } else if selectedLifeguards.count < 2 {
            selectedLifeguards.append(lifeguard)
        }
    }
}

// Lifeguard model
struct Lifeguard: Identifiable {
    let id: String
    let fullname: String
    let photo: String // System image name or photo URL
}

// Authentication validation


struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView().environmentObject(AuthViewModel())
    }
}
