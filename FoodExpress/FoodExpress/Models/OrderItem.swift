//
//  OrderItem.swift
//  FoodExpress
//
//  Created by Глеб Синяков on 16.05.26.
//

import Foundation

struct OrderItem: Identifiable, Codable {
    var id: Int
    var orderId: Int
    var dishId: Int
    var quantity: Int
    var pricePerUnit: Double
    
    init(id: Int = Int.random(in: 1...9999), orderId: Int, dishId: Int, quantity: Int, pricePerUnit: Double) {
        self.id = id
        self.orderId = orderId
        self.dishId = dishId
        self.quantity = quantity
        self.pricePerUnit = pricePerUnit
    }
}
