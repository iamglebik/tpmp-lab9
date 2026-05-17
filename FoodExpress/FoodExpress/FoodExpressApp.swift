//
//  FoodExpressApp.swift
//  FoodExpress
//
//  Created by Глеб Синяков on 16.05.26.
//

import SwiftUI

@main
struct FoodExpressApp: App {
    @State private var isLoggedIn: Bool = false
    
    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                MainTabView(isLoggedIn: $isLoggedIn)
            } else {
                AuthView(isLoggedIn: $isLoggedIn)
            }
        }
    }
}
