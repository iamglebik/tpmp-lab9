//
//  MenuViewModel.swift
//  FoodExpress
//
//  Created by Глеб Синяков on 16.05.26.
//

import Foundation

class MenuViewModel: ObservableObject {
    
    @Published var restaurants: [Restaurant] = []
    @Published var dishes: [Dish] = []
    @Published var filteredDishes: [Dish] = []
    @Published var categories: [String] = []
    @Published var selectedCategory: String = "Все"
    @Published var searchText: String = ""
    
    init() {
        loadData()
    }
    
    func loadData() {
        restaurants = DatabaseService.shared.getAllRestaurants()
        dishes = DatabaseService.shared.getAllDishes()
        
        var uniqueCategories = Set<String>()
        for dish in dishes {
            uniqueCategories.insert(dish.category)
        }
        categories = ["Все"] + Array(uniqueCategories).sorted()
        
        filterDishes()
    }
    
    func filterDishes() {
        var result = dishes
        
        if selectedCategory != "Все" {
            result = result.filter { $0.category == selectedCategory }
        }
        
        if !searchText.isEmpty {
            result = result.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
        
        filteredDishes = result
    }
    
    func selectCategory(_ category: String) {
        selectedCategory = category
        filterDishes()
    }
    
    func search(_ text: String) {
        searchText = text
        filterDishes()
    }
    
    func restaurantName(for restaurantId: Int) -> String {
        return restaurants.first { $0.id == restaurantId }?.name ?? "Ресторан"
    }
}
