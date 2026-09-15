import XCTest

final class OtInternetUITests: XCTestCase {
    func testMainTabsAreVisible() {
        let app = XCUIApplication()
        app.launchArguments.append("UI_TESTING")
        app.launch()
        XCTAssertTrue(app.tabBars.buttons["Home"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.tabBars.buttons["Games"].exists)
        XCTAssertTrue(app.tabBars.buttons["Maps"].exists)
        XCTAssertTrue(app.tabBars.buttons["Notes"].exists)
        XCTAssertTrue(app.tabBars.buttons["More"].exists)
    }
}
