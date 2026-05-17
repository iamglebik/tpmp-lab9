//
//  DatabaseService.swift
//  FoodExpress
//
//  Created by Глеб Синяков on 16.05.26.
//

import Foundation
import SQLite

class DatabaseService {
    static let shared = DatabaseService()
    private var db: Connection?
    
    // Tables
    private let users = Table("users")
    private let restaurants = Table("restaurants")
    private let dishes = Table("dishes")
    private let orders = Table("orders")
    private let orderItems = Table("order_items")
    
    // Users columns
    private let userIdCol = Expression<Int64>("id")
    private let userEmailCol = Expression<String>("email")
    private let userPasswordHashCol = Expression<String>("password_hash")
    private let userNameCol = Expression<String>("name")
    private let userPhoneCol = Expression<String>("phone")
    
    // Restaurants columns
    private let restIdCol = Expression<Int64>("id")
    private let restNameCol = Expression<String>("name")
    private let restLatCol = Expression<Double>("latitude")
    private let restLonCol = Expression<Double>("longitude")
    private let restCuisineCol = Expression<String>("cuisine_type")
    
    // Dishes columns
    private let dishIdCol = Expression<Int64>("id")
    private let dishNameCol = Expression<String>("name")
    private let dishDescCol = Expression<String>("description")
    private let dishPriceCol = Expression<Double>("price")
    private let dishCatCol = Expression<String>("category")
    private let dishImageCol = Expression<String>("image_name")
    private let dishRestIdCol = Expression<Int64>("restaurant_id")
    
    // Orders columns
    private let orderIdCol = Expression<Int64>("id")
    private let orderUserIdCol = Expression<Int64>("user_id")
    private let orderRestIdCol = Expression<Int64>("restaurant_id")
    private let orderStatusCol = Expression<String>("status")
    private let orderPayCol = Expression<String>("payment_method")
    private let orderAddrCol = Expression<String>("delivery_address")
    private let orderCommCol = Expression<String>("comment")
    private let orderTotalCol = Expression<Double>("total_amount")
    private let orderDateCol = Expression<String>("created_at")
    
    // OrderItems columns
    private let oiIdCol = Expression<Int64>("id")
    private let oiOrderIdCol = Expression<Int64>("order_id")
    private let oiDishIdCol = Expression<Int64>("dish_id")
    private let oiQtyCol = Expression<Int>("quantity")
    private let oiPriceCol = Expression<Double>("price_per_unit")
    
    private init() {
        setupDatabase()
    }
    
    private func setupDatabase() {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let dbPath = "\(path)/foodexpress.db"
        
        do {
            db = try Connection(dbPath)
            createTables()
            insertTestDataIfNeeded()
        } catch {
            print("Database connection error: \(error)")
        }
    }
    
    private func createTables() {
        do {
            try db?.run(users.create(ifNotExists: true) { t in
                t.column(userIdCol, primaryKey: .autoincrement)
                t.column(userEmailCol, unique: true)
                t.column(userPasswordHashCol)
                t.column(userNameCol)
                t.column(userPhoneCol)
            })
            
            try db?.run(restaurants.create(ifNotExists: true) { t in
                t.column(restIdCol, primaryKey: .autoincrement)
                t.column(restNameCol)
                t.column(restLatCol)
                t.column(restLonCol)
                t.column(restCuisineCol)
            })
            
            try db?.run(dishes.create(ifNotExists: true) { t in
                t.column(dishIdCol, primaryKey: .autoincrement)
                t.column(dishNameCol)
                t.column(dishDescCol)
                t.column(dishPriceCol)
                t.column(dishCatCol)
                t.column(dishImageCol)
                t.column(dishRestIdCol)
            })
            
            try db?.run(orders.create(ifNotExists: true) { t in
                t.column(orderIdCol, primaryKey: .autoincrement)
                t.column(orderUserIdCol)
                t.column(orderRestIdCol)
                t.column(orderStatusCol)
                t.column(orderPayCol)
                t.column(orderAddrCol)
                t.column(orderCommCol)
                t.column(orderTotalCol)
                t.column(orderDateCol)
            })
            
            try db?.run(orderItems.create(ifNotExists: true) { t in
                t.column(oiIdCol, primaryKey: .autoincrement)
                t.column(oiOrderIdCol)
                t.column(oiDishIdCol)
                t.column(oiQtyCol)
                t.column(oiPriceCol)
            })
        } catch {
            print("Create tables error: \(error)")
        }
    }
    
    private func insertTestDataIfNeeded() {
        do {
            let count = try db?.scalar(restaurants.count) ?? 0
            if count == 0 {
                insertTestRestaurants()
                insertTestDishes()
            }
        } catch {
            print("Check test data error: \(error)")
        }
    }
    
    private func insertTestRestaurants() {
        do {
            try db?.run(restaurants.insert(restNameCol <- "Пицца Хаус", restLatCol <- 53.8930, restLonCol <- 27.5674, restCuisineCol <- "Итальянская"))
            try db?.run(restaurants.insert(restNameCol <- "Суши Маркет", restLatCol <- 53.9025, restLonCol <- 27.5618, restCuisineCol <- "Японская"))
            try db?.run(restaurants.insert(restNameCol <- "Бургер Кинг", restLatCol <- 53.9094, restLonCol <- 27.5709, restCuisineCol <- "Американская"))
        } catch {
            print("Insert restaurants error: \(error)")
        }
    }
    
    private func insertTestDishes() {
        do {
            try db?.run(dishes.insert(dishNameCol <- "Маргарита", dishDescCol <- "Классическая пицца", dishPriceCol <- 18.0, dishCatCol <- "Пицца", dishImageCol <- "pizza", dishRestIdCol <- 1))
            try db?.run(dishes.insert(dishNameCol <- "Пепперони", dishDescCol <- "Острая пицца", dishPriceCol <- 22.0, dishCatCol <- "Пицца", dishImageCol <- "pizza", dishRestIdCol <- 1))
            try db?.run(dishes.insert(dishNameCol <- "Филадельфия", dishDescCol <- "Нежные роллы", dishPriceCol <- 25.0, dishCatCol <- "Суши", dishImageCol <- "sushi", dishRestIdCol <- 2))
            try db?.run(dishes.insert(dishNameCol <- "Чизбургер", dishDescCol <- "Сочный бургер", dishPriceCol <- 15.0, dishCatCol <- "Бургеры", dishImageCol <- "burger", dishRestIdCol <- 3))
            try db?.run(dishes.insert(dishNameCol <- "Кола", dishDescCol <- "Освежающий напиток", dishPriceCol <- 3.5, dishCatCol <- "Напитки", dishImageCol <- "drink", dishRestIdCol <- 3))
        } catch {
            print("Insert dishes error: \(error)")
        }
    }
    
    // MARK: - User Methods
    func registerUser(email: String, password: String, name: String, phone: String) -> User? {
        do {
            let insert = users.insert(userEmailCol <- email, userPasswordHashCol <- password, userNameCol <- name, userPhoneCol <- phone)
            let rowId = try db?.run(insert)
            return User(id: Int(rowId ?? 0), email: email, passwordHash: password, name: name, phone: phone)
        } catch {
            print("Registration error: \(error)")
            return nil
        }
    }
    
    func loginUser(email: String, password: String) -> User? {
        do {
            let query = users.filter(userEmailCol == email && userPasswordHashCol == password)
            if let row = try db?.pluck(query) {
                return User(
                    id: Int(row[userIdCol]),
                    email: row[userEmailCol],
                    passwordHash: row[userPasswordHashCol],
                    name: row[userNameCol],
                    phone: row[userPhoneCol]
                )
            }
        } catch {
            print("Login error: \(error)")
        }
        return nil
    }
    
    // MARK: - Restaurant Methods
    func getAllRestaurants() -> [Restaurant] {
        var result: [Restaurant] = []
        do {
            if let rows = try db?.prepare(restaurants) {
                for row in rows {
                    result.append(Restaurant(
                        id: Int(row[restIdCol]),
                        name: row[restNameCol],
                        latitude: row[restLatCol],
                        longitude: row[restLonCol],
                        cuisineType: row[restCuisineCol]
                    ))
                }
            }
        } catch {
            print("Error fetching restaurants: \(error)")
        }
        return result
    }
    
    // MARK: - Dish Methods
    func getAllDishes() -> [Dish] {
        var result: [Dish] = []
        do {
            if let rows = try db?.prepare(dishes) {
                for row in rows {
                    result.append(Dish(
                        id: Int(row[dishIdCol]),
                        name: row[dishNameCol],
                        description: row[dishDescCol],
                        price: row[dishPriceCol],
                        category: row[dishCatCol],
                        imageName: row[dishImageCol],
                        restaurantId: Int(row[dishRestIdCol])
                    ))
                }
            }
        } catch {
            print("Error fetching dishes: \(error)")
        }
        return result
    }
}
