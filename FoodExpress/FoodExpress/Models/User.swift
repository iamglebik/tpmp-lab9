//
//  User.swift
//  FoodExpress
//
//  Created by Глеб Синяков on 16.05.26.
//

import Foundation

struct User: Identifiable, Codable {
    let id: Int
    var email: String
    var passwordHash: String
    var name: String
    var phone: String
}
