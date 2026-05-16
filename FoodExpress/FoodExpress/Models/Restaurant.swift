//
//  Restaurant.swift
//  FoodExpress
//
//  Created by Глеб Синяков on 16.05.26.
//

import Foundation

struct Restaurant: Identifiable, Codable {
    let id: Int
    let name: String
    let latitude: Double
    let longitude: Double
    let cuisineType: String
}
