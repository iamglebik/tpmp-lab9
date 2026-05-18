//
//  CheckoutView.swift
//  FoodExpress
//
//  Created by Глеб Синяков on 17.05.26.
//

import SwiftUI

struct CheckoutView: View {
    @EnvironmentObject var viewModel: CartViewModel
    @State private var paymentMethod: String = "Наличные"
    @State private var address: String = ""
    @State private var comment: String = ""
    @State private var showSuccess: Bool = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Состав заказа")
                            .font(.headline)
                        
                        ForEach(viewModel.items) { item in
                            HStack {
                                Text(item.dish.name)
                                    .font(.subheadline)
                                Spacer()
                                Text("\(item.quantity) x \(String(format: "%.2f", item.dish.price)) BYN")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        Divider()
                        
                        HStack {
                            Text(String(localized: "checkout_total"))
                                .font(.headline)
                            Spacer()
                            Text("\(String(format: "%.2f", viewModel.totalAmount)) BYN")
                                .font(.headline)
                                .foregroundColor(.orange)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(String(localized: "checkout_payment_method"))
                            .font(.headline)
                        
                        Picker(String(localized: "checkout_payment_method"), selection: $paymentMethod) {
                            Text(String(localized: "payment_cash")).tag("Наличные")
                            Text(String(localized: "payment_online")).tag("Онлайн")
                            Text(String(localized: "payment_erip")).tag("ЕРИП")
                            Text(String(localized: "payment_terminal")).tag("Терминал")
                        }
                        .pickerStyle(.segmented)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(String(localized: "checkout_delivery_address"))
                            .font(.headline)
                        
                        TextField(String(localized: "checkout_delivery_address"), text: $address)
                            .textFieldStyle(.roundedBorder)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(String(localized: "checkout_comment"))
                            .font(.headline)
                        
                        TextField(String(localized: "checkout_comment_placeholder"), text: $comment)
                            .textFieldStyle(.roundedBorder)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    Button(action: {
                        if address.isEmpty {
                            return
                        }
                        showSuccess = true
                        viewModel.clearCart()
                    }) {
                        Text(String(localized: "checkout_confirm"))
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.orange)
                    .disabled(address.isEmpty)
                }
                .padding()
            }
            .navigationTitle(String(localized: "checkout_title"))
            .alert(String(localized: "checkout_success"), isPresented: $showSuccess) {
                Button("OK") {
                    dismiss()
                }
            } message: {
                Text(String(localized: "checkout_success_message"))
            }
        }
    }
}
