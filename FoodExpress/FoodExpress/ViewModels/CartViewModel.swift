//
//  CartViewModel.swift
//  FoodExpress
//
//  Created by Глеб Синяков on 16.05.26.
//

import Foundation

class CartViewModel: ObservableObject {
    
    @Published var items: [CartItem] = []
    
    var totalAmount: Double {
        items.reduce(0) { $0 + $1.totalPrice }
    }
    
    var totalItems: Int {
        items.reduce(0) { $0 + $1.quantity }
    }
    
    func addToCart(dish: Dish) {
        if let index = items.firstIndex(where: { $0.dish.id == dish.id }) {
            items[index].quantity += 1
        } else {
            items.append(CartItem(dish: dish, quantity: 1))
        }
    }
    
    func removeFromCart(item: CartItem) {
        items.removeAll { $0.id == item.id }
    }
    
    func updateQuantity(item: CartItem, quantity: Int) {
        if quantity <= 0 {
            removeFromCart(item: item)
        } else if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index].quantity = quantity
        }
    }
    
    func clearCart() {
        items.removeAll()
    }
}
