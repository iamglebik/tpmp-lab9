//
//  CartView.swift
//  FoodExpress
//
//  Created by Глеб Синяков on 16.05.26.
//

import SwiftUI

struct CartView: View {
    @EnvironmentObject var viewModel: CartViewModel
    @State private var showCheckout: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.items.isEmpty {
                    Spacer()
                    VStack(spacing: 12) {
                        Image(systemName: "cart")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        Text(String(localized: "cart_empty"))
                            .font(.headline)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                } else {
                    List {
                        ForEach(viewModel.items) { item in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(item.dish.name)
                                        .font(.headline)
                                    Text("\(String(format: "%.2f", item.dish.price)) BYN")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                
                                Spacer()
                                
                                HStack(spacing: 12) {
                                    Button(action: {
                                        viewModel.updateQuantity(item: item, quantity: item.quantity - 1)
                                    }) {
                                        Image(systemName: "minus.circle")
                                            .foregroundColor(.orange)
                                    }
                                    
                                    Text("\(item.quantity)")
                                        .frame(minWidth: 20)
                                    
                                    Button(action: {
                                        viewModel.updateQuantity(item: item, quantity: item.quantity + 1)
                                    }) {
                                        Image(systemName: "plus.circle")
                                            .foregroundColor(.orange)
                                    }
                                }
                            }
                        }
                        .onDelete { indexSet in
                            for index in indexSet {
                                viewModel.removeFromCart(item: viewModel.items[index])
                            }
                        }
                    }
                    .listStyle(.plain)
                    
                    VStack(spacing: 12) {
                        HStack {
                            Text(String(localized: "cart_total"))
                                .font(.headline)
                            Spacer()
                            Text("\(String(format: "%.2f", viewModel.totalAmount)) BYN")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.orange)
                        }
                        
                        Button(action: {
                            showCheckout = true
                        }) {
                            Text(String(localized: "cart_checkout"))
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.orange)
                    }
                    .padding()
                }
            }
            .navigationTitle(String(localized: "cart_title"))
            .sheet(isPresented: $showCheckout) {
                CheckoutView()
            }
        }
    }
}