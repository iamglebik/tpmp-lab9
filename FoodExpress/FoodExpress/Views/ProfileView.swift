//
//  ProfileView.swift
//  FoodExpress
//
//  Created by Глеб Синяков on 16.05.26.
//

import SwiftUI

struct ProfileView: View {
    @Binding var isLoggedIn: Bool
    @AppStorage("userName") private var userName = ""
    @AppStorage("userEmail") private var userEmail = ""
    @AppStorage("userPhone") private var userPhone = ""
    @StateObject private var authViewModel = AuthViewModel()
    @State private var showingEditProfile = false
    
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
                
                Button(action: {
                    showingEditProfile = true
                }) {
                    Text("Редактировать профиль")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .sheet(isPresented: $showingEditProfile) {
                    EditProfileView()
                }
                
                Button(action: {
                    authViewModel.logout()
                    isLoggedIn = false
                }) {
                    Text("Выйти")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Профиль")
        }
    }
}
