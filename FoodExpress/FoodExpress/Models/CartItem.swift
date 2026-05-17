//
//  CartItem.swift
//  FoodExpress
//
//  Created by Глеб Синяков on 17.05.26.
//

import Foundation

struct CartItem: Identifiable {
    let id: UUID = UUID()
    var dish: Dish
    var quantity: Int
    
    var totalPrice: Double {
        return dish.price * Double(quantity)
    }
}
