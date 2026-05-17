//
//  ProfileView.swift
//  FoodExpress
//
//  Created by Глеб Синяков on 16.05.26.
//

import SwiftUI

struct ProfileView: View {
    @Binding var isLoggedIn: Bool
    @StateObject private var authViewModel = AuthViewModel()
    
    private var userName: String {
        UserDefaults.standard.string(forKey: "userName") ?? ""
    }
    private var userEmail: String {
        UserDefaults.standard.string(forKey: "userEmail") ?? ""
    }
    private var userPhone: String {
        UserDefaults.standard.string(forKey: "userPhone") ?? ""
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 25) {
                
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 100))
                    .foregroundColor(.orange)
                
                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                        Text("Имя:")
                            .bold()
                            .frame(width: 80, alignment: .leading)
                        Text(userName.isEmpty ? "Не указано" : userName)
                    }
                    
                    HStack {
                        Text("Email:")
                            .bold()
                            .frame(width: 80, alignment: .leading)
                        Text(userEmail.isEmpty ? "Не указан" : userEmail)
                    }
                    
                    HStack {
                        Text("Телефон:")
                            .bold()
                            .frame(width: 80, alignment: .leading)
                        Text(userPhone.isEmpty ? "Не указан" : userPhone)
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .padding(.horizontal)
                
                Spacer()
                
                Button(action: {
                    authViewModel.logout()
                    isLoggedIn = false
                }) {
                    Text(String(localized: "profile_logout"))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .padding(.bottom, 30)
            }
            .padding(.top, 20)
            .navigationTitle(String(localized: "profile_title"))
        }
    }
}