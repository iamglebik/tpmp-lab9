import XCTest
@testable import FoodExpress

final class CartViewModelTests: XCTestCase {
    
    var viewModel: CartViewModel!
    var testDish: Dish!
    
    override func setUp() {
        super.setUp()
        viewModel = CartViewModel()
        testDish = Dish(id: 1, name: "Test Dish", description: "Test", price: 10.0, category: "Пицца", imageName: "test", restaurantId: 1)
    }
    
    override func tearDown() {
        viewModel = nil
        testDish = nil
        super.tearDown()
    }
    
    // 1. Добавление блюда в пустую корзину
    func testAddToCart_EmptyCart_AddsItem() {
        viewModel.addToCart(dish: testDish)
        XCTAssertEqual(viewModel.items.count, 1)
        XCTAssertEqual(viewModel.items.first?.dish.id, testDish.id)
        XCTAssertEqual(viewModel.items.first?.quantity, 1)
    }
    
    // 2. Добавление того же блюда увеличивает количество
    func testAddToCart_SameDish_IncreasesQuantity() {
        viewModel.addToCart(dish: testDish)
        viewModel.addToCart(dish: testDish)
        XCTAssertEqual(viewModel.items.count, 1)
        XCTAssertEqual(viewModel.items.first?.quantity, 2)
    }
    
    // 3. Общая сумма корзины
    func testTotalAmount_CalculatesCorrectly() {
        viewModel.addToCart(dish: testDish)
        viewModel.addToCart(dish: testDish)
        XCTAssertEqual(viewModel.totalAmount, 20.0)
    }
    
    // 4. Общее количество товаров
    func testTotalItems_CountsCorrectly() {
        let dish2 = Dish(id: 2, name: "Dish 2", description: "", price: 5.0, category: "Суши", imageName: "", restaurantId: 1)
        viewModel.addToCart(dish: testDish)
        viewModel.addToCart(dish: testDish)
        viewModel.addToCart(dish: dish2)
        XCTAssertEqual(viewModel.totalItems, 3)
    }
    
    // 5. Удаление блюда из корзины
    func testRemoveFromCart_RemovesItem() {
        viewModel.addToCart(dish: testDish)
        guard let item = viewModel.items.first else {
            XCTFail("Item should exist")
            return
        }
        viewModel.removeFromCart(item: item)
        XCTAssertTrue(viewModel.items.isEmpty)
    }
    
    // 6. Обновление количества — положительное
    func testUpdateQuantity_ValidQuantity_Updates() {
        viewModel.addToCart(dish: testDish)
        guard let item = viewModel.items.first else {
            XCTFail("Item should exist")
            return
        }
        viewModel.updateQuantity(item: item, quantity: 5)
        XCTAssertEqual(viewModel.items.first?.quantity, 5)
    }
    
    // 7. Обновление количества — ноль удаляет блюдо
    func testUpdateQuantity_Zero_RemovesItem() {
        viewModel.addToCart(dish: testDish)
        guard let item = viewModel.items.first else {
            XCTFail("Item should exist")
            return
        }
        viewModel.updateQuantity(item: item, quantity: 0)
        XCTAssertTrue(viewModel.items.isEmpty)
    }
    
    // 8. Очистка корзины
    func testClearCart_RemovesAllItems() {
        viewModel.addToCart(dish: testDish)
        viewModel.addToCart(dish: testDish)
        viewModel.clearCart()
        XCTAssertTrue(viewModel.items.isEmpty)
        XCTAssertEqual(viewModel.totalAmount, 0.0)
    }
    
    // 9. Пустая корзина — сумма ноль
    func testEmptyCart_TotalAmountIsZero() {
        XCTAssertEqual(viewModel.totalAmount, 0.0)
    }
    
    // 10. Пустая корзина — количество ноль
    func testEmptyCart_TotalItemsIsZero() {
        XCTAssertEqual(viewModel.totalItems, 0)
    }
}