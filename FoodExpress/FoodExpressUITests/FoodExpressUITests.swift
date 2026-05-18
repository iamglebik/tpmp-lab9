//
//  FoodExpressUITests.swift
//  FoodExpressUITests
//
//  Created by Глеб Синяков on 16.05.26.
//

import XCTest

final class FoodExpressUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDown() {
        app = nil
        super.tearDown()
    }
    
    // 1. Проверка отображения экрана авторизации при запуске
    func testLaunch_ShowsAuthScreen() {
        XCTAssertTrue(app.buttons["Sign In"].exists)
    }
    
    // 2. Проверка наличия полей ввода на экране авторизации
    func testAuthScreen_HasEmailField() {
        XCTAssertTrue(app.textFields["Email"].exists)
    }
    
    // 3. Проверка наличия кнопки регистрации
    func testAuthScreen_HasRegisterButton() {
        XCTAssertTrue(app.buttons["Sign Up"].exists)
    }
    
    // 4. Проверка перехода на экран регистрации
    func testTapRegister_OpensRegisterScreen() {
        app.buttons["Sign Up"].tap()
        XCTAssertTrue(app.navigationBars["Sign Up"].exists)
    }
    
    // 5. Проверка закрытия экрана регистрации
    func testRegisterScreen_CancelButton_Dismisses() {
        app.buttons["Sign Up"].tap()
        app.buttons["Cancel"].tap()
        XCTAssertTrue(app.buttons["Sign In"].exists)
    }
    
    // 6. Проверка появления ошибки при пустом логине
    func testLogin_EmptyFields_ShowsError() {
        app.buttons["Sign In"].tap()
        XCTAssertTrue(app.staticTexts["Please enter a valid email"].exists)
    }
    
    // 7. Проверка навигации по вкладкам после входа
    func testMainTabs_ExistAfterLogin() {
        login()
        XCTAssertTrue(app.tabBars.buttons["Menu"].exists)
        XCTAssertTrue(app.tabBars.buttons["Map"].exists)
        XCTAssertTrue(app.tabBars.buttons["Cart"].exists)
        XCTAssertTrue(app.tabBars.buttons["Profile"].exists)
    }
    
    // 8. Проверка отображения списка блюд в меню
    func testMenu_ShowsDishes() {
        login()
        sleep(1)
        XCTAssertTrue(app.cells.count > 0)
    }
    
    // 9. Проверка пустой корзины
    func testCart_Empty_ShowsMessage() {
        login()
        app.tabBars.buttons["Cart"].tap()
        XCTAssertTrue(app.staticTexts["Your cart is empty"].exists)
    }
    
    // 10. Проверка добавления блюда в корзину
    func testAddToCart_IncreasesCounter() {
        login()
        sleep(1)
        app.buttons["plus.circle.fill"].firstMatch.tap()
        XCTAssertTrue(app.staticTexts["1"].exists)
    }
    
    // 11. Проверка перехода в корзину после добавления
    func testCart_ShowsItems_AfterAdding() {
        login()
        sleep(1)
        app.buttons["plus.circle.fill"].firstMatch.tap()
        app.tabBars.buttons["Cart"].tap()
        XCTAssertTrue(app.cells.count > 0)
    }
    
    // 12. Проверка профиля и кнопки выхода
    func testProfile_HasLogoutButton() {
        login()
        app.tabBars.buttons["Profile"].tap()
        XCTAssertTrue(app.buttons["Log Out"].exists)
    }
    
    // 13. Проверка выхода из системы
    func testLogout_ReturnsToAuthScreen() {
        login()
        app.tabBars.buttons["Profile"].tap()
        app.buttons["Log Out"].tap()
        XCTAssertTrue(app.buttons["Sign In"].exists)
    }
    
    // 14. Проверка вкладки карты
    func testMapTab_Exists() {
        login()
        app.tabBars.buttons["Map"].tap()
        XCTAssertTrue(app.navigationBars["Map"].exists)
    }
    
    // MARK: - Helper
    private func login() {
        app.textFields["Email"].tap()
        app.textFields["Email"].typeText("test@test.com")
        
        app.secureTextFields["Password"].tap()
        app.secureTextFields["Password"].typeText("123456")
        
        app.buttons["Sign In"].tap()
        sleep(1)
    }
}
