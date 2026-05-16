//
//  Dish.swift
//  FoodExpress
//
//  Created by Глеб Синяков on 16.05.26.
//

import Foundation

struct Dish: Identifiable, Codable {
    let id: Int
    let name: String
    let description: String
    let price: Double
    let category: String
    let imageName: String
    let restaurantId: Int
}
