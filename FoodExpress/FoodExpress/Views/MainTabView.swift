//
//  MainTabView.swift
//  FoodExpress
//
//  Created by Глеб Синяков on 16.05.26.
//

import SwiftUI

// MARK: - MainTabView
struct MainTabView: View {
    
    // MARK: - Properties
    @Binding var isLoggedIn: Bool
    @StateObject private var cartViewModel = CartViewModel()
    @State private var selectedTab = 0
    
    // MARK: - Body
    var body: some View {
        TabView(selection: $selectedTab) {
            
            // Вкладка 1: Меню
            MenuView()
                .tabItem {
                    Label("Меню", systemImage: "menucard.fill")
                }
                .tag(0)
            
            // Вкладка 2: Карта
            MapView()
                .tabItem {
                    Label("Карта", systemImage: "map.fill")
                }
                .tag(1)
            
            // Вкладка 3: Корзина (с бейджем количества)
            CartView()
                .environmentObject(cartViewModel)
                .tabItem {
                    Label("Корзина", systemImage: "cart.fill")
                }
                .badge(cartViewModel.items.count)
                .tag(2)
            
            // Вкладка 4: Профиль
            ProfileView(isLoggedIn: $isLoggedIn)
                .tabItem {
                    Label("Профиль", systemImage: "person.fill")
                }
                .tag(3)
        }
        .accentColor(.orange)
        .onAppear {
            // Настройка внешнего вида TabBar
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.systemBackground
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}

// MARK: - MenuView (Список ресторанов)
struct MenuView: View {
    
    // MARK: - Properties
    @StateObject private var viewModel = MenuViewModel()
    @State private var searchText = ""
    
    // MARK: - Computed Properties
    var filteredRestaurants: [Restaurant] {
        if searchText.isEmpty {
            return viewModel.restaurants
        } else {
            return viewModel.restaurants.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(filteredRestaurants) { restaurant in
                        NavigationLink(destination: RestaurantMenuView(restaurant: restaurant)) {
                            RestaurantCardView(restaurant: restaurant)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal)
                .padding(.top, 8)
            }
            .background(Color(.systemGray6))
            .navigationTitle("Рестораны")
            .searchable(text: $searchText, prompt: "Поиск ресторана")
            .onAppear {
                viewModel.loadRestaurants()
            }
        }
    }
}

// MARK: - RestaurantCardView (Карточка ресторана)
struct RestaurantCardView: View {
    
    // MARK: - Properties
    let restaurant: Restaurant
    
    // MARK: - Body
    var body: some View {
        HStack(spacing: 16) {
            // Иконка ресторана
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.orange.opacity(0.2))
                .frame(width: 70, height: 70)
                .overlay {
                    Image(systemName: "fork.knife")
                        .font(.title2)
                        .foregroundColor(.orange)
                }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(restaurant.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(restaurant.cuisineType)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .font(.caption2)
                        .foregroundColor(.yellow)
                    Text("4.5")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("•")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("30-45 мин")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

// MARK: - RestaurantMenuView (Меню ресторана)
struct RestaurantMenuView: View {
    
    // MARK: - Properties
    let restaurant: Restaurant
    @StateObject private var viewModel = MenuViewModel()
    @State private var dishes: [Dish] = []
    @State private var searchText = ""
    @State private var selectedCategory = "Все"
    @EnvironmentObject var cartViewModel: CartViewModel
    @State private var showingDishDetail: Dish?
    
    // MARK: - Categories
    let categories = ["Все", "Пицца", "Суши", "Бургеры", "Напитки"]
    
    // MARK: - Computed Properties
    var filteredDishes: [Dish] {
        var result = dishes
        
        // Фильтрация по категории
        if selectedCategory != "Все" {
            result = result.filter { $0.category == selectedCategory }
        }
        
        // Фильтрация по поиску
        if !searchText.isEmpty {
            result = result.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
        
        return result
    }
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            // Категории (горизонтальный скролл)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(categories, id: \.self) { category in
                        CategoryChip(
                            title: category,
                            isSelected: selectedCategory == category,
                            action: { selectedCategory = category }
                        )
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 12)
            }
            .background(Color(.systemBackground))
            
            // Список блюд
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(filteredDishes) { dish in
                        DishCardView(
                            dish: dish,
                            onAddToCart: {
                                cartViewModel.addToCart(dish: dish)
                            },
                            onTap: {
                                showingDishDetail = dish
                            }
                        )
                    }
                }
                .padding(.horizontal)
                .padding(.top, 8)
                .padding(.bottom, 16)
            }
            .background(Color(.systemGray6))
        }
        .navigationTitle(restaurant.name)
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $searchText, prompt: "Поиск блюд")
        .onAppear {
            dishes = DatabaseService.shared.fetchDishes(restaurantId: restaurant.id)
        }
        .sheet(item: $showingDishDetail) { dish in
            DishDetailView(dish: dish, onAddToCart: {
                cartViewModel.addToCart(dish: dish)
            })
        }
    }
}

// MARK: - CategoryChip
struct CategoryChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(isSelected ? .semibold : .regular)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.orange : Color.gray.opacity(0.15))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(20)
        }
    }
}

// MARK: - DishCardView (Карточка блюда)
struct DishCardView: View {
    let dish: Dish
    let onAddToCart: () -> Void
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // Иконка блюда
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.orange.opacity(0.15))
                    .frame(width: 70, height: 70)
                    .overlay {
                        Image(systemName: "fork.knife")
                            .font(.title2)
                            .foregroundColor(.orange)
                    }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(dish.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(dish.description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                    
                    Text("\(dish.price, specifier: "%.2f") BYN")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.orange)
                }
                
                Spacer()
                
                // Кнопка добавления в корзину
                Button(action: onAddToCart) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.orange)
                }
                .buttonStyle(BorderlessButtonStyle())
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - DishDetailView (Детали блюда)
struct DishDetailView: View {
    let dish: Dish
    let onAddToCart: () -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var quantity = 1
    @State private var selectedSize = "Средняя"
    
    let sizes = ["Маленькая", "Средняя", "Большая"]
    
    var totalPrice: Double {
        let basePrice = dish.price
        let sizeMultiplier: Double
        switch selectedSize {
        case "Маленькая": sizeMultiplier = 0.8
        case "Средняя": sizeMultiplier = 1.0
        case "Большая": sizeMultiplier = 1.3
        default: sizeMultiplier = 1.0
        }
        return basePrice * sizeMultiplier * Double(quantity)
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 20) {
                        // Изображение
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.orange.opacity(0.15))
                            .frame(height: 200)
                            .overlay {
                                Image(systemName: "fork.knife")
                                    .font(.system(size: 50))
                                    .foregroundColor(.orange)
                            }
                            .padding(.top)
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text(dish.name)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            
                            Text(dish.description)
                                .font(.body)
                                .foregroundColor(.secondary)
                            
                            Divider()
                            
                            // Выбор размера
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Размер порции")
                                    .font(.headline)
                                
                                Picker("Размер", selection: $selectedSize) {
                                    ForEach(sizes, id: \.self) { size in
                                        Text(size).tag(size)
                                    }
                                }
                                .pickerStyle(.segmented)
                            }
                            
                            Divider()
                            
                            // Количество
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Количество")
                                    .font(.headline)
                                
                                HStack {
                                    Button(action: { if quantity > 1 { quantity -= 1 } }) {
                                        Image(systemName: "minus.circle.fill")
                                            .font(.title2)
                                            .foregroundColor(.orange)
                                    }
                                    
                                    Text("\(quantity)")
                                        .font(.title2)
                                        .frame(width: 50)
                                    
                                    Button(action: { quantity += 1 }) {
                                        Image(systemName: "plus.circle.fill")
                                            .font(.title2)
                                            .foregroundColor(.orange)
                                    }
                                    
                                    Spacer()
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
                // Нижняя панель с ценой и кнопкой
                VStack(spacing: 0) {
                    Divider()
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Итого")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text("\(totalPrice, specifier: "%.2f") BYN")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.orange)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            onAddToCart()
                            dismiss()
                        }) {
                            Text("Добавить в корзину")
                                .fontWeight(.semibold)
                                .frame(width: 180, height: 50)
                                .background(Color.orange)
                                .foregroundColor(.white)
                                .cornerRadius(25)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Детали блюда")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Закрыть") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    MainTabView(isLoggedIn: .constant(true))
}
