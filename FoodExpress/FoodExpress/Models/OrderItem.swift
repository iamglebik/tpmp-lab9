//
//  OrderItem.swift
//  FoodExpress
//
//  Created by Глеб Синяков on 16.05.26.
//

import Foundation

// MARK: - OrderItem (для БД)
struct OrderItem: Identifiable, Codable {
    let id: Int
    let orderId: Int
    let dishId: Int
    let quantity: Int
    let pricePerUnit: Double
}

// MARK: - CartItem (для корзины)
struct CartItem: Identifiable, Codable {
    let id = UUID()
    let dish: Dish
    var quantity: Int
    
    var totalPrice: Double {
        Double(quantity) * dish.price
    }
}
