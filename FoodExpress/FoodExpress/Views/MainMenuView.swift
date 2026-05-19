//
//  MainMenuView.swift
//  FoodExpress
//
//  Created by Глеб Синяков on 16.05.26.
//

import SwiftUI

struct MainMenuView: View {
    @StateObject private var menuViewModel = MenuViewModel()
    @EnvironmentObject var cartViewModel: CartViewModel
    @State private var searchText: String = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                
                // Поиск
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField(String(localized: "menu_search"), text: $searchText)
                        .onChange(of: searchText) { _, newValue in
                            menuViewModel.search(newValue)
                        }
                }
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
                .padding(.top, 8)
                
                // Категории
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(menuViewModel.categories, id: \.self) { category in
                            Button(action: {
                                menuViewModel.selectCategory(category)
                            }) {
                                Text(category)
                                    .font(.subheadline)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(
                                        menuViewModel.selectedCategory == category
                                            ? Color.orange
                                            : Color(.systemGray6)
                                    )
                                    .foregroundColor(
                                        menuViewModel.selectedCategory == category
                                            ? .white
                                            : .primary
                                    )
                                    .cornerRadius(20)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                }
                
                // Индикатор корзины
                if cartViewModel.totalItems > 0 {
                    HStack {
                        Image(systemName: "cart.fill")
                            .foregroundColor(.orange)
                        Text("\(cartViewModel.totalItems) шт. — \(String(format: "%.2f", cartViewModel.totalAmount)) BYN")
                            .font(.caption)
                            .fontWeight(.medium)
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 6)
                    .background(Color.orange.opacity(0.1))
                }
                
                // Список блюд
                if menuViewModel.filteredDishes.isEmpty {
                    Spacer()
                    Text("Блюда не найдены")
                        .foregroundColor(.gray)
                    Spacer()
                } else {
                    List {
                        ForEach(menuViewModel.filteredDishes) { dish in
                            DishRowView(dish: dish) {
                                cartViewModel.addToCart(dish: dish)
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle(String(localized: "menu_title"))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: CartView()) {
                        ZStack(alignment: .topTrailing) {
                            Image(systemName: "cart")
                                .font(.title3)
                            
                            if cartViewModel.totalItems > 0 {
                                Text("\(cartViewModel.totalItems)")
                                    .font(.caption2)
                                    .foregroundColor(.white)
                                    .padding(4)
                                    .background(Color.red)
                                    .clipShape(Circle())
                                    .offset(x: 8, y: -8)
                            }
                        }
                    }
                }
            }
        }
    }
}