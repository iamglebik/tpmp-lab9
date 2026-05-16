//
//  ContentView.swift
//  FoodExpress
//

import SwiftUI

struct ContentView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    
    var body: some View {
        if isLoggedIn {
            MainTabView(isLoggedIn: $isLoggedIn)
        } else {
            AuthView(isLoggedIn: $isLoggedIn)
        }
    }
}

#Preview {
    ContentView()
}
