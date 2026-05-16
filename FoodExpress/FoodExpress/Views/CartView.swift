//
//  CartView.swift
//  FoodExpress
//
//  Created by Глеб Синяков on 16.05.26.
//

import SwiftUI

struct CartView: View {
    
    // MARK: - Properties
    @EnvironmentObject var cartViewModel: CartViewModel
    @State private var showingCheckout = false
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            VStack {
                if cartViewModel.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "cart")
                            .font(.system(size: 80))
                            .foregroundColor(.gray)
                        Text("Корзина пуста")
                            .font(.title2)
                            .foregroundColor(.gray)
                        Text("Добавьте блюда из меню")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                } else {
                    List {
                        ForEach(cartViewModel.items) { item in
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(item.dish.name)
                                        .font(.headline)
                                    Text("\(item.dish.price, specifier: "%.2f") BYN")
                                        .font(.caption)
                                        .foregroundColor(.orange)
                                }
                                Spacer()
                                HStack(spacing: 15) {
                                    Button(action: {
                                        cartViewModel.updateQuantity(for: item.dish.id, quantity: item.quantity - 1)
                                    }) {
                                        Image(systemName: "minus.circle")
                                            .foregroundColor(.orange)
                                    }
                                    Text("\(item.quantity)")
                                        .font(.headline)
                                        .frame(width: 30)
                                    Button(action: {
                                        cartViewModel.updateQuantity(for: item.dish.id, quantity: item.quantity + 1)
                                    }) {
                                        Image(systemName: "plus.circle")
                                            .foregroundColor(.orange)
                                    }
                                }
                                Text("\(item.totalPrice, specifier: "%.2f") BYN")
                                    .font(.headline)
                                    .frame(width: 70, alignment: .trailing)
                            }
                            .padding(.vertical, 4)
                        }
                        .onDelete { indexSet in
                            cartViewModel.removeFromCart(at: indexSet)
                        }
                    }
                    
                    VStack(spacing: 15) {
                        HStack {
                            Text("Итого:")
                                .font(.title2)
                                .bold()
                            Spacer()
                            Text("\(cartViewModel.totalPrice, specifier: "%.2f") BYN")
                                .font(.title2)
                                .bold()
                                .foregroundColor(.orange)
                        }
                        .padding(.horizontal)
                        
                        Button(action: {
                            showingCheckout = true
                        }) {
                            Text("Оформить заказ")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.orange)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                                .font(.headline)
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 10)
                    }
                }
            }
            .navigationTitle("Корзина")
            .toolbar {
                if !cartViewModel.isEmpty {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                }
            }
            .sheet(isPresented: $showingCheckout) {
                CheckoutView()
                    .environmentObject(cartViewModel)
            }
        }
    }
}

#Preview {
    CartView()
        .environmentObject(CartViewModel())
}
