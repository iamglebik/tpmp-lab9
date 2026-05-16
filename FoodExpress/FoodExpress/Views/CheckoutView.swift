//
//  CheckoutView.swift
//  FoodExpress
//
//  Created by Глеб Синяков on 16.05.26.
//

import SwiftUI

struct CheckoutView: View {
    
    // MARK: - Properties
    @EnvironmentObject var cartViewModel: CartViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var selectedPaymentMethod = "Онлайн"
    @State private var deliveryAddress = ""
    @State private var comment = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    let paymentMethods = ["Онлайн", "ЕРИП", "Терминал", "Наличные"]
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Способ оплаты")) {
                    Picker("Способ оплаты", selection: $selectedPaymentMethod) {
                        ForEach(paymentMethods, id: \.self) { method in
                            Text(method).tag(method)
                        }
                    }
                    .pickerStyle(.menu)
                }
                
                Section(header: Text("Адрес доставки")) {
                    TextField("Введите адрес", text: $deliveryAddress)
                        .textFieldStyle(.roundedBorder)
                }
                
                Section(header: Text("Комментарий к заказу")) {
                    TextEditor(text: $comment)
                        .frame(height: 80)
                    Text("\(comment.count)/200")
                        .font(.caption)
                        .foregroundColor(comment.count > 200 ? .red : .gray)
                }
                
                Section(header: Text("Ваш заказ")) {
                    ForEach(cartViewModel.items) { item in
                        HStack {
                            Text(item.dish.name)
                            Spacer()
                            Text("\(item.quantity) x \(item.dish.price, specifier: "%.2f") BYN")
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    HStack {
                        Text("Итого:")
                            .font(.headline)
                        Spacer()
                        Text("\(cartViewModel.totalPrice, specifier: "%.2f") BYN")
                            .font(.headline)
                            .foregroundColor(.orange)
                    }
                }
            }
            .navigationTitle("Оформление заказа")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Подтвердить") {
                        placeOrder()
                    }
                    .disabled(deliveryAddress.isEmpty || cartViewModel.isEmpty)
                }
            }
            .alert(alertMessage, isPresented: $showingAlert) {
                Button("OK") {
                    if alertMessage == "Заказ успешно оформлен!" {
                        cartViewModel.clearCart()
                        dismiss()
                    }
                }
            }
        }
    }
    
    // MARK: - Methods
    private func placeOrder() {
        if deliveryAddress.isEmpty {
            alertMessage = "Введите адрес доставки"
            showingAlert = true
            return
        }
        
        if cartViewModel.isEmpty {
            alertMessage = "Корзина пуста"
            showingAlert = true
            return
        }
        
        // Получаем текущего пользователя
        let userEmail = UserDefaults.standard.string(forKey: "userEmail") ?? ""
        
        // Находим пользователя в БД
        let users = DatabaseService.shared.loginUser(email: userEmail, password: "")
        
        // Сохраняем заказ
        let items = cartViewModel.items.map { item in
            (dishId: item.dish.id, quantity: item.quantity, pricePerUnit: item.dish.price)
        }
        
        let success = DatabaseService.shared.saveOrder(
            userId: 1,
            restaurantId: cartViewModel.items.first?.dish.restaurantId ?? 1,
            paymentMethod: selectedPaymentMethod,
            deliveryAddress: deliveryAddress,
            comment: comment,
            totalAmount: cartViewModel.totalPrice,
            items: items
        )
        
        if success {
            alertMessage = "Заказ успешно оформлен!"
        } else {
            alertMessage = "Ошибка при оформлении заказа"
        }
        showingAlert = true
    }
}

#Preview {
    CheckoutView()
        .environmentObject(CartViewModel())
}
