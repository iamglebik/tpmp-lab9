//
//  MenuViewModelTests.swift
//  FoodExpressTests
//
//  Created by Глеб Синяков on 18.05.26.
//

import XCTest
@testable import FoodExpress

final class MenuViewModelTests: XCTestCase {
    
    var viewModel: MenuViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = MenuViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    // 1. Загрузка данных — рестораны не пустые
    func testLoadData_RestaurantsNotEmpty() {
        viewModel.loadData()
        XCTAssertFalse(viewModel.restaurants.isEmpty)
    }
    
    // 2. Загрузка данных — блюда не пустые
    func testLoadData_DishesNotEmpty() {
        viewModel.loadData()
        XCTAssertFalse(viewModel.dishes.isEmpty)
    }
    
    // 3. Загрузка данных — категории содержат "Все"
    func testLoadData_CategoriesContainsAll() {
        viewModel.loadData()
        XCTAssertTrue(viewModel.categories.contains("Все"))
    }
    
    // 4. Фильтрация по категории "Все"
    func testSelectCategory_All_ShowsAllDishes() {
        viewModel.loadData()
        viewModel.selectCategory("Все")
        XCTAssertEqual(viewModel.filteredDishes.count, viewModel.dishes.count)
    }
    
    // 5. Фильтрация по конкретной категории
    func testSelectCategory_Specific_FiltersCorrectly() {
        viewModel.loadData()
        viewModel.selectCategory("Пицца")
        for dish in viewModel.filteredDishes {
            XCTAssertEqual(dish.category, "Пицца")
        }
    }
    
    // 6. Поиск по названию блюда
    func testSearch_FindsMatchingDish() {
        viewModel.loadData()
        viewModel.search("Маргарита")
        XCTAssertFalse(viewModel.filteredDishes.isEmpty)
        XCTAssertTrue(viewModel.filteredDishes.contains { $0.name == "Маргарита" })
    }
    
    // 7. Поиск по несуществующему названию
    func testSearch_NoMatch_ReturnsEmpty() {
        viewModel.loadData()
        viewModel.search("НесуществующееБлюдо123")
        XCTAssertTrue(viewModel.filteredDishes.isEmpty)
    }
    
    // 8. Поиск по пустой строке — показывает все
    func testSearch_EmptyString_ShowsAll() {
        viewModel.loadData()
        viewModel.search("")
        XCTAssertEqual(viewModel.filteredDishes.count, viewModel.dishes.count)
    }
    
    // 9. Имя ресторана по id
    func testRestaurantName_ValidId_ReturnsName() {
        viewModel.loadData()
        if let firstRestaurant = viewModel.restaurants.first {
            let name = viewModel.restaurantName(for: firstRestaurant.id)
            XCTAssertFalse(name.isEmpty)
        }
    }
    
    // 10. Имя ресторана по несуществующему id
    func testRestaurantName_InvalidId_ReturnsDefault() {
        viewModel.loadData()
        let name = viewModel.restaurantName(for: 99999)
        XCTAssertEqual(name, "Ресторан")
    }
}
