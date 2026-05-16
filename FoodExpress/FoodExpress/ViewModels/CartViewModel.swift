//
//  CartViewModel.swift
//  FoodExpress
//
//  Created by Глеб Синяков on 16.05.26.
//

import Foundation

class CartViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var items: [CartItem] = []
    
    // MARK: - Private Properties
    private let userDefaultsKey = "cart_items"
    
    // MARK: - Init
    init() {
        loadCart()
    }
    
    // MARK: - Public Methods
    func addToCart(dish: Dish, quantity: Int = 1) {
        if let index = items.firstIndex(where: { $0.dish.id == dish.id }) {
            items[index].quantity += quantity
        } else {
            items.append(CartItem(dish: dish, quantity: quantity))
        }
        saveCart()
    }
    
    func removeFromCart(at indexSet: IndexSet) {
        items.remove(atOffsets: indexSet)
        saveCart()
    }
    
    func updateQuantity(for dishId: Int, quantity: Int) {
        if let index = items.firstIndex(where: { $0.dish.id == dishId }) {
            if quantity <= 0 {
                items.remove(at: index)
            } else {
                items[index].quantity = quantity
            }
            saveCart()
        }
    }
    
    var totalPrice: Double {
        items.reduce(0) { $0 + $1.totalPrice }
    }
    
    var isEmpty: Bool {
        items.isEmpty
    }
    
    var itemCount: Int {
        items.reduce(0) { $0 + $1.quantity }
    }
    
    func clearCart() {
        items.removeAll()
        saveCart()
    }
    
    // MARK: - Private Methods
    private func saveCart() {
        if let encoded = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        }
    }
    
    private func loadCart() {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey),
           let savedItems = try? JSONDecoder().decode([CartItem].self, from: data) {
            items = savedItems
        }
    }
}
