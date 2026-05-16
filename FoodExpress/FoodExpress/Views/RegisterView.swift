//
//  RegisterView.swift
//  FoodExpress
//
//  Created by Глеб Синяков on 16.05.26.
//

import SwiftUI

struct RegisterView: View {
    @Binding var isLoggedIn: Bool
    @StateObject private var viewModel = AuthViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                
                // MARK: - Name Field
                TextField(String(localized: "auth_name_placeholder"), text: $viewModel.name)
                    .textFieldStyle(.roundedBorder)
                
                // MARK: - Email Field
                TextField(String(localized: "auth_email_placeholder"), text: $viewModel.email)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                
                // MARK: - Phone Field
                TextField(String(localized: "auth_phone_placeholder"), text: $viewModel.phone)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.phonePad)
                
                // MARK: - Password Field
                SecureField(String(localized: "auth_password_placeholder"), text: $viewModel.password)
                    .textFieldStyle(.roundedBorder)
                
                // MARK: - Error Message
                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.caption)
                }
                
                // MARK: - Register Button
                Button(action: {
                    viewModel.register()
                    if viewModel.isLoggedIn {
                        isLoggedIn = true
                        dismiss()
                    }
                }) {
                    Text(String(localized: "auth_register_button"))
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(.orange)
                
                Spacer()
            }
            .padding()
            .navigationTitle(String(localized: "auth_register_button"))
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(String(localized: "auth_cancel")) {
                        dismiss()
                    }
                }
            }
        }
    }
}
