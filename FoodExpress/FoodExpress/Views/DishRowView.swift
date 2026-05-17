//
//  DishRowView.swift
//  FoodExpress
//
//  Created by Глеб Синяков on 16.05.26.
//

import SwiftUI

struct DishRowView: View {
    let dish: Dish
    let onAddToCart: () -> Void
    
    var imageName: String {
        switch dish.category {
        case "Пицца": return "flame.circle.fill"
        case "Суши": return "fish.circle.fill"
        case "Бургеры": return "fork.knife.circle.fill"
        case "Напитки": return "cup.and.saucer.fill"
        case "Закуски": return "takeoutbag.and.cup.and.straw.fill"
        default: return "cart.circle.fill"
        }
    }
    
    var imageColor: Color {
        switch dish.category {
        case "Пицца": return .red
        case "Суши": return .blue
        case "Бургеры": return .orange
        case "Напитки": return .green
        case "Закуски": return .yellow
        default: return .gray
        }
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .foregroundColor(imageColor)
                .padding(8)
                .background(imageColor.opacity(0.1))
                .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(dish.name)
                    .font(.headline)
                
                Text(dish.description)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .lineLimit(2)
                
                HStack {
                    Text("\(String(format: "%.2f", dish.price)) BYN")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.orange)
                    
                    Spacer()
                    
                    Button(action: onAddToCart) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.orange)
                    }
                }
            }
        }
        .padding(.vertical, 4)
    }
}