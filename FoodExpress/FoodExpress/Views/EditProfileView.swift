//
//  EditProfileView.swift
//  FoodExpress
//
//  Created by Глеб Синяков on 16.05.26.
//

import SwiftUI

struct EditProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("userName") private var userName = ""
    @AppStorage("userEmail") private var userEmail = ""
    @AppStorage("userPhone") private var userPhone = ""
    
    @State private var tempName: String
    @State private var tempEmail: String
    @State private var tempPhone: String
    
    init() {
        _tempName = State(initialValue: UserDefaults.standard.string(forKey: "userName") ?? "")
        _tempEmail = State(initialValue: UserDefaults.standard.string(forKey: "userEmail") ?? "")
        _tempPhone = State(initialValue: UserDefaults.standard.string(forKey: "userPhone") ?? "")
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Личная информация")) {
                    TextField("Имя", text: $tempName)
                    TextField("Email", text: $tempEmail)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    TextField("Телефон", text: $tempPhone)
                        .keyboardType(.phonePad)
                }
            }
            .navigationTitle("Редактировать профиль")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Сохранить") {
                        userName = tempName
                        userEmail = tempEmail
                        userPhone = tempPhone
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    EditProfileView()
}
