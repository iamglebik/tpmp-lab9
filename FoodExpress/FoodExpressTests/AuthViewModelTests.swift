import XCTest
@testable import FoodExpress

final class AuthViewModelTests: XCTestCase {
    
    var viewModel: AuthViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = AuthViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    // 1. Проверка валидации email — правильный email
    func testValidEmail_ReturnsTrue() {
        viewModel.email = "test@example.com"
        XCTAssertTrue(viewModel.isValidEmail(viewModel.email))
    }
    
    // 2. Проверка валидации email — без символа @
    func testInvalidEmail_MissingAt_ReturnsFalse() {
        viewModel.email = "testexample.com"
        XCTAssertFalse(viewModel.isValidEmail(viewModel.email))
    }
    
    // 3. Проверка валидации email — без домена
    func testInvalidEmail_MissingDomain_ReturnsFalse() {
        viewModel.email = "test@"
        XCTAssertFalse(viewModel.isValidEmail(viewModel.email))
    }
    
    // 4. Проверка валидации email — пустая строка
    func testInvalidEmail_EmptyString_ReturnsFalse() {
        viewModel.email = ""
        XCTAssertFalse(viewModel.isValidEmail(viewModel.email))
    }
    
    // 5. Проверка валидации пароля — достаточная длина
    func testValidPassword_ReturnsTrue() {
        viewModel.password = "123456"
        XCTAssertTrue(viewModel.isValidPassword(viewModel.password))
    }
    
    // 6. Проверка валидации пароля — короткий пароль
    func testInvalidPassword_TooShort_ReturnsFalse() {
        viewModel.password = "12345"
        XCTAssertFalse(viewModel.isValidPassword(viewModel.password))
    }
    
    // 7. Проверка валидации пароля — пустой пароль
    func testInvalidPassword_Empty_ReturnsFalse() {
        viewModel.password = ""
        XCTAssertFalse(viewModel.isValidPassword(viewModel.password))
    }
    
    // 8. Проверка логина с пустым email
    func testLogin_EmptyEmail_SetsErrorMessage() {
        viewModel.email = ""
        viewModel.password = "123456"
        viewModel.login()
        XCTAssertNotNil(viewModel.errorMessage)
    }
    
    // 9. Проверка логина с пустым паролем
    func testLogin_EmptyPassword_SetsErrorMessage() {
        viewModel.email = "test@example.com"
        viewModel.password = ""
        viewModel.login()
        XCTAssertNotNil(viewModel.errorMessage)
    }
    
    // 10. Проверка регистрации с пустым именем
    func testRegister_EmptyName_SetsErrorMessage() {
        viewModel.email = "test@example.com"
        viewModel.password = "123456"
        viewModel.name = ""
        viewModel.phone = "+375291234567"
        viewModel.register()
        XCTAssertNotNil(viewModel.errorMessage)
    }
    
    // 11. Проверка регистрации с пустым телефоном
    func testRegister_EmptyPhone_SetsErrorMessage() {
        viewModel.email = "test@example.com"
        viewModel.password = "123456"
        viewModel.name = "Test User"
        viewModel.phone = ""
        viewModel.register()
        XCTAssertNotNil(viewModel.errorMessage)
    }
    
    // 12. Проверка logout — сброс полей
    func testLogout_ResetsAllFields() {
        viewModel.email = "test@example.com"
        viewModel.password = "123456"
        viewModel.name = "Test"
        viewModel.phone = "12345"
        viewModel.isLoggedIn = true
        
        viewModel.logout()
        
        XCTAssertFalse(viewModel.isLoggedIn)
        XCTAssertEqual(viewModel.email, "")
        XCTAssertEqual(viewModel.password, "")
        XCTAssertEqual(viewModel.name, "")
        XCTAssertEqual(viewModel.phone, "")
    }
}