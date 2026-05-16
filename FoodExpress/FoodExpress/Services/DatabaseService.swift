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
    private let id = Expression<Int64>("id")
    private let email = Expression<String>("email")
    private let passwordHash = Expression<String>("password_hash")
    private let userName = Expression<String>("name")
    private let phone = Expression<String>("phone")
    
    // Restaurants columns
    private let restId = Expression<Int64>("id")
    private let restName = Expression<String>("name")
    private let latitude = Expression<Double>("latitude")
    private let longitude = Expression<Double>("longitude")
    private let cuisineType = Expression<String>("cuisine_type")
    
    // Dishes columns
    private let dishId = Expression<Int64>("id")
    private let dishName = Expression<String>("name")
    private let dishDescription = Expression<String>("description")
    private let price = Expression<Double>("price")
    private let category = Expression<String>("category")
    private let imageName = Expression<String>("image_name")
    private let restaurantId = Expression<Int64>("restaurant_id")
    
    // Orders columns
    private let orderId = Expression<Int64>("id")
    private let userId = Expression<Int64>("user_id")
    private let status = Expression<String>("status")
    private let paymentMethod = Expression<String>("payment_method")
    private let deliveryAddress = Expression<String>("delivery_address")
    private let comment = Expression<String>("comment")
    private let totalAmount = Expression<Double>("total_amount")
    private let createdAt = Expression<String>("created_at")
    
    // OrderItems columns
    private let orderItemId = Expression<Int64>("id")
    private let orderForeignKey = Expression<Int64>("order_id")
    private let dishForeignKey = Expression<Int64>("dish_id")
    private let quantity = Expression<Int>("quantity")
    private let pricePerUnit = Expression<Double>("price_per_unit")
    
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
                t.column(id, primaryKey: .autoincrement)
                t.column(email, unique: true)
                t.column(passwordHash)
                t.column(userName)
                t.column(phone)
            })
            
            try db?.run(restaurants.create(ifNotExists: true) { t in
                t.column(restId, primaryKey: .autoincrement)
                t.column(restName)
                t.column(latitude)
                t.column(longitude)
                t.column(cuisineType)
            })
            
            try db?.run(dishes.create(ifNotExists: true) { t in
                t.column(dishId, primaryKey: .autoincrement)
                t.column(dishName)
                t.column(dishDescription)
                t.column(price)
                t.column(category)
                t.column(imageName)
                t.column(restaurantId)
            })
            
            try db?.run(orders.create(ifNotExists: true) { t in
                t.column(orderId, primaryKey: .autoincrement)
                t.column(userId)
                t.column(restaurantId)
                t.column(status)
                t.column(paymentMethod)
                t.column(deliveryAddress)
                t.column(comment)
                t.column(totalAmount)
                t.column(createdAt)
            })
            
            try db?.run(orderItems.create(ifNotExists: true) { t in
                t.column(orderItemId, primaryKey: .autoincrement)
                t.column(orderForeignKey)
                t.column(dishForeignKey)
                t.column(quantity)
                t.column(pricePerUnit)
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
            try db?.run(restaurants.insert(restName <- "Пицца Хаус", latitude <- 53.8930, longitude <- 27.5674, cuisineType <- "Итальянская"))
            try db?.run(restaurants.insert(restName <- "Суши Маркет", latitude <- 53.9025, longitude <- 27.5618, cuisineType <- "Японская"))
            try db?.run(restaurants.insert(restName <- "Бургер Кинг", latitude <- 53.9094, longitude <- 27.5709, cuisineType <- "Американская"))
        } catch {
            print("Insert restaurants error: \(error)")
        }
    }
    
    private func insertTestDishes() {
        do {
            try db?.run(dishes.insert(dishName <- "Маргарита", dishDescription <- "Классическая пицца", price <- 18.0, category <- "Пицца", imageName <- "pizza", restaurantId <- 1))
            try db?.run(dishes.insert(dishName <- "Пепперони", dishDescription <- "Острая пицца", price <- 22.0, category <- "Пицца", imageName <- "pizza", restaurantId <- 1))
            try db?.run(dishes.insert(dishName <- "Филадельфия", dishDescription <- "Нежные роллы", price <- 25.0, category <- "Суши", imageName <- "sushi", restaurantId <- 2))
            try db?.run(dishes.insert(dishName <- "Чизбургер", dishDescription <- "Сочный бургер", price <- 15.0, category <- "Бургеры", imageName <- "burger", restaurantId <- 3))
            try db?.run(dishes.insert(dishName <- "Кола", dishDescription <- "Освежающий напиток", price <- 3.5, category <- "Напитки", imageName <- "drink", restaurantId <- 3))
        } catch {
            print("Insert dishes error: \(error)")
        }
    }
    
    // MARK: - User Methods
    func registerUser(email: String, password: String, name: String, phone: String) -> User? {
        do {
            let insert = users.insert(self.email <- email, passwordHash <- password, userName <- name, self.phone <- phone)
            let rowId = try db?.run(insert)
            return User(id: Int(rowId ?? 0), email: email, passwordHash: password, name: name, phone: phone)
        } catch {
            print("Registration error: \(error)")
            return nil
        }
    }
    
    func loginUser(email: String, password: String) -> User? {
        do {
            let query = users.filter(self.email == email && passwordHash == password)
            if let userRow = try db?.pluck(query) {
                return User(
                    id: Int(userRow[id]),
                    email: userRow[self.email],
                    passwordHash: userRow[passwordHash],
                    name: userRow[userName],
                    phone: userRow[phone]
                )
            }
        } catch {
            print("Login error: \(error)")
        }
        return nil
    }
    
    // MARK: - Restaurant Methods
    func fetchRestaurants() -> [Restaurant] {
        var result: [Restaurant] = []
        do {
            let query = restaurants.select(restId, restName, latitude, longitude, cuisineType)
            let rows = try db?.prepare(query)
            if let rows = rows {
                for row in rows {
                    let restaurant = Restaurant(
                        id: Int(row[restId]),
                        name: row[restName],
                        latitude: row[latitude],
                        longitude: row[longitude],
                        cuisineType: row[cuisineType]
                    )
                    result.append(restaurant)
                }
            }
        } catch {
            print("Fetch restaurants error: \(error)")
        }
        return result
    }
    
    // MARK: - Dish Methods
    func fetchDishes(restaurantId: Int) -> [Dish] {
        var result: [Dish] = []
        do {
            let query = dishes.filter(self.restaurantId == Int64(restaurantId))
            let rows = try db?.prepare(query)
            if let rows = rows {
                for row in rows {
                    let dish = Dish(
                        id: Int(row[dishId]),
                        name: row[dishName],
                        description: row[dishDescription],
                        price: row[price],
                        category: row[category],
                        imageName: row[imageName],
                        restaurantId: Int(row[self.restaurantId])
                    )
                    result.append(dish)
                }
            }
        } catch {
            print("Fetch dishes error: \(error)")
        }
        return result
    }
    
    // MARK: - Order Methods
    func saveOrder(userId: Int, restaurantId: Int, paymentMethod: String, deliveryAddress: String, comment: String, totalAmount: Double, items: [(dishId: Int, quantity: Int, pricePerUnit: Double)]) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = dateFormatter.string(from: Date())
        
        do {
            let insertOrder = orders.insert(
                self.userId <- Int64(userId),
                self.restaurantId <- Int64(restaurantId),
                status <- "new",
                self.paymentMethod <- paymentMethod,
                self.deliveryAddress <- deliveryAddress,
                self.comment <- comment,
                self.totalAmount <- totalAmount,
                createdAt <- dateString
            )
            let orderIdValue = try db?.run(insertOrder)
            guard let orderIdValue = orderIdValue else { return false }
            
            for item in items {
                let insertItem = orderItems.insert(
                    orderForeignKey <- orderIdValue,
                    dishForeignKey <- Int64(item.dishId),
                    quantity <- item.quantity,
                    pricePerUnit <- item.pricePerUnit
                )
                try db?.run(insertItem)
            }
            return true
        } catch {
            print("Save order error: \(error)")
            return false
        }
    }
}
