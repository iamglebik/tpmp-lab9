//
//  AuthView.swift
//  FoodExpress
//
//  Created by Глеб Синяков on 16.05.26.
//

import SwiftUI

struct AuthView: View {
    @Binding var isLoggedIn: Bool
    @StateObject private var viewModel = AuthViewModel()
    @State private var showRegister: Bool = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                
                Spacer()
                
                // MARK: - Logo
                Text("FoodExpress")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.orange)
                
                Text("Доставка еды")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Spacer().frame(height: 30)
                
                // MARK: - Email Field
                TextField(String(localized: "auth_email_placeholder"), text: $viewModel.email)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                
                // MARK: - Password Field
                SecureField(String(localized: "auth_password_placeholder"), text: $viewModel.password)
                    .textFieldStyle(.roundedBorder)
                
                // MARK: - Error Message
                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.caption)
                }
                
                // MARK: - Login Button
                Button(action: {
                    viewModel.login()
                    if viewModel.isLoggedIn {
                        isLoggedIn = true
                    }
                }) {
                    Text(String(localized: "auth_login_button"))
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(.orange)
                
                // MARK: - Register Button
                Button(action: {
                    viewModel.errorMessage = nil
                    showRegister = true
                }) {
                    Text(String(localized: "auth_register_button"))
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                
                Spacer()
            }
            .padding()
            .sheet(isPresented: $showRegister) {
                RegisterView(isLoggedIn: $isLoggedIn)
            }
        }
    }
}
