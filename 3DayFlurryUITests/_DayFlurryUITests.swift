//
//  _DayFlurryUITests.swift
//  3DayFlurryUITests
//
//  Created by Alex de France on 4/6/18.
//  Copyright © 2018 Def Labs. All rights reserved.
//

import XCTest

class _DayFlurryUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
    }
    
    func testNoInfo() {
        app.launch()
        app.buttons["Get Forecast!"].tap()
        sleep(3)
        XCTAssertTrue(app.tables.cells.count == 0)
    }
    
    func testRequestResponse() {
        app.launch()
        app.textFields["stateBox"].tap()
        app.textFields["stateBox"].typeText("MI")
        app.textFields["cityBox"].tap()
        app.textFields["cityBox"].typeText("Ann Arbor")
        app.buttons["Get Forecast!"].tap()
        sleep(3)
        XCTAssertTrue(app.tables.cells.count != 0)
        XCTAssertTrue(app.tables.cells.count == 3)
    }
    
    func testStateTooLong() {
        app.launch()
        app.textFields["cityBox"].tap()
        app.textFields["cityBox"].typeText("Detroit")
        app.textFields["stateBox"].tap()
        app.textFields["stateBox"].typeText("MIA")
        app.buttons["Get Forecast!"].tap()
        sleep(3)
        XCTAssertTrue(app.alerts.count == 1)
        XCTAssertTrue(app.tables.cells.count == 0)
        
    }
    
    func testStateTooShort() {
        app.launch()
        app.textFields["cityBox"].tap()
        app.textFields["cityBox"].typeText("Detroit")
        app.textFields["stateBox"].tap()
        app.textFields["stateBox"].typeText("A")
        app.buttons["Get Forecast!"].tap()
        sleep(3)
        XCTAssertTrue(app.alerts.count == 1)
        XCTAssertTrue(app.tables.cells.count == 0)
        
    }
    
    func testInvalidCity() {
        app.launch()
        app.textFields["cityBox"].tap()
        app.textFields["cityBox"].typeText("Wowee")
        app.textFields["stateBox"].tap()
        app.textFields["stateBox"].typeText("MI")
        app.buttons["Get Forecast!"].tap()
        sleep(3)
        XCTAssertTrue(app.alerts.count == 1)
        XCTAssertTrue(app.tables.cells.count == 0)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
}
