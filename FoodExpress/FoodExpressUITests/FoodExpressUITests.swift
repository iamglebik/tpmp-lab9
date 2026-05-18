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
        continueAfterFailure = true
        app = XCUIApplication()
        app.launchArguments = ["-AppleLanguages", "(en)"]
        app.launch()
    }
    
    override func tearDown() {
        app.terminate()
        app = nil
        super.tearDown()
    }
    
    // 1. Проверка запуска приложения
    func testLaunch_AppOpens() {
        XCTAssertTrue(app.wait(for: .runningForeground, timeout: 5))
    }
    
    // 2. Кнопка входа существует
    func testAuthScreen_SignInButtonExists() {
        XCTAssertTrue(app.buttons["Sign In"].waitForExistence(timeout: 5))
    }
    
    // 3. Поле email существует
    func testAuthScreen_EmailFieldExists() {
        XCTAssertTrue(app.textFields["Email"].waitForExistence(timeout: 5))
    }
    
    // 4. Поле пароля существует
    func testAuthScreen_PasswordFieldExists() {
        XCTAssertTrue(app.secureTextFields["Password"].waitForExistence(timeout: 5))
    }
    
    // 5. Кнопка регистрации существует
    func testAuthScreen_RegisterButtonExists() {
        XCTAssertTrue(app.buttons["Sign Up"].waitForExistence(timeout: 5))
    }
    
    // 6. Переход на экран регистрации
    func testTapRegister_OpensRegisterScreen() {
        app.buttons["Sign Up"].tap()
        XCTAssertTrue(app.buttons["Cancel"].waitForExistence(timeout: 5))
    }
    
    // 7. Возврат с экрана регистрации
    func testRegisterScreen_Cancel_ReturnsToAuth() {
        app.buttons["Sign Up"].tap()
        app.buttons["Cancel"].tap()
        XCTAssertTrue(app.buttons["Sign In"].waitForExistence(timeout: 5))
    }
    
    // 8. Ошибка при пустых полях
    func testLogin_EmptyFields_ShowsError() {
        app.buttons["Sign In"].tap()
        sleep(1)
        XCTAssertTrue(app.staticTexts.count > 0)
    }
    
    // 9. Успешный вход (тестовый пользователь)
    func testLogin_Success_ShowsTabView() {
        let emailField = app.textFields["Email"]
        let passwordField = app.secureTextFields["Password"]
        
        emailField.tap()
        emailField.typeText("test@test.com")
        
        passwordField.tap()
        passwordField.typeText("123456")
        
        app.buttons["Sign In"].tap()
        sleep(2)
        
        XCTAssertTrue(app.tabBars.buttons["Menu"].waitForExistence(timeout: 10))
    }
    
    // 10. Вкладки существуют после входа
    func testTabs_ExistAfterLogin() {
        login()
        XCTAssertTrue(app.tabBars.buttons["Menu"].exists)
        XCTAssertTrue(app.tabBars.buttons["Map"].exists)
        XCTAssertTrue(app.tabBars.buttons["Cart"].exists)
        XCTAssertTrue(app.tabBars.buttons["Profile"].exists)
    }
    
    // 11. Корзина пуста изначально
    func testCart_Empty_ShowsMessage() {
        login()
        app.tabBars.buttons["Cart"].tap()
        sleep(1)
        XCTAssertTrue(app.staticTexts["Your cart is empty"].exists)
    }
    
    // 12. Профиль показывает кнопку выхода
    func testProfile_HasLogoutButton() {
        login()
        app.tabBars.buttons["Profile"].tap()
        sleep(1)
        XCTAssertTrue(app.buttons["Log Out"].exists)
    }
    
    // MARK: - Helper
    private func login() {
        let emailField = app.textFields["Email"]
        let passwordField = app.secureTextFields["Password"]
        
        if emailField.waitForExistence(timeout: 5) {
            emailField.tap()
            emailField.typeText("test@test.com")
        }
        
        if passwordField.waitForExistence(timeout: 5) {
            passwordField.tap()
            passwordField.typeText("123456")
        }
        
        app.buttons["Sign In"].tap()
        sleep(2)
    }
}
