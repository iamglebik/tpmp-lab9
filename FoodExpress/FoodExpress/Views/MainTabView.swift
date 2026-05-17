//
//  MainTabView.swift
//  FoodExpress
//
//  Created by Глеб Синяков on 16.05.26.
//

import SwiftUI

struct MainTabView: View {
    @Binding var isLoggedIn: Bool
    
    var body: some View {
        TabView {
            MainMenuView()
                .tabItem {
                    Label(String(localized: "tab_menu"), systemImage: "fork.knife")
                }
            
            MapView()
                .tabItem {
                    Label(String(localized: "tab_map"), systemImage: "map")
                }
            
            CartView()
                .tabItem {
                    Label(String(localized: "tab_cart"), systemImage: "cart")
                }
            
            ProfileView(isLoggedIn: $isLoggedIn)
                .tabItem {
                    Label(String(localized: "tab_profile"), systemImage: "person")
                }
        }
    }
}