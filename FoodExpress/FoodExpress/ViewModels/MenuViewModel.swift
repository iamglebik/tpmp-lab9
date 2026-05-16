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
    
    func loadRestaurants() {
        restaurants = DatabaseService.shared.fetchRestaurants()
    }
    
    func loadDishes(for restaurantId: Int) {
        dishes = DatabaseService.shared.fetchDishes(restaurantId: restaurantId)
    }
}
