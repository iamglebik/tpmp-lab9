//
//  AuthViewModel.swift
//  FoodExpress
//
//  Created by Глеб Синяков on 16.05.26.
//

import Foundation

class AuthViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var name: String = ""
    @Published var phone: String = ""
    @Published var errorMessage: String?
    @Published var isLoggedIn: Bool = false
    @Published var currentUser: User?
    
    // MARK: - Validation
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    func isValidPassword(_ password: String) -> Bool {
        return password.count >= 6
    }
    
    // MARK: - Login
    func login() {
        guard isValidEmail(email) else {
            errorMessage = String(localized: "auth_invalid_email")
            return
        }
        
        guard isValidPassword(password) else {
            errorMessage = String(localized: "auth_invalid_password")
            return
        }
        
        if let user = DatabaseService.shared.loginUser(email: email, password: password) {
            currentUser = user
            isLoggedIn = true
            errorMessage = nil
            
            // Сохраняем данные пользователя в UserDefaults для отображения в профиле
            UserDefaults.standard.set(user.name, forKey: "userName")
            UserDefaults.standard.set(user.email, forKey: "userEmail")
            UserDefaults.standard.set(user.phone, forKey: "userPhone")
        } else {
            errorMessage = "Неверный email или пароль"
        }
    }
    
    // MARK: - Register
    func register() {
        guard isValidEmail(email) else {
            errorMessage = String(localized: "auth_invalid_email")
            return
        }
        
        guard isValidPassword(password) else {
            errorMessage = String(localized: "auth_invalid_password")
            return
        }
        
        guard !name.isEmpty else {
            errorMessage = "Введите имя"
            return
        }
        
        guard !phone.isEmpty else {
            errorMessage = "Введите номер телефона"
            return
        }
        
        if let user = DatabaseService.shared.registerUser(
            email: email,
            password: password,
            name: name,
            phone: phone
        ) {
            currentUser = user
            isLoggedIn = true
            errorMessage = nil
            
            // Сохраняем данные пользователя в UserDefaults для отображения в профиле
            UserDefaults.standard.set(user.name, forKey: "userName")
            UserDefaults.standard.set(user.email, forKey: "userEmail")
            UserDefaults.standard.set(user.phone, forKey: "userPhone")
        } else {
            errorMessage = "Пользователь с таким email уже существует"
        }
    }
    
    // MARK: - Logout
    func logout() {
        currentUser = nil
        isLoggedIn = false
        email = ""
        password = ""
        name = ""
        phone = ""
        errorMessage = nil
        
        // Очищаем UserDefaults при выходе
        UserDefaults.standard.removeObject(forKey: "userName")
        UserDefaults.standard.removeObject(forKey: "userEmail")
        UserDefaults.standard.removeObject(forKey: "userPhone")
    }
}
