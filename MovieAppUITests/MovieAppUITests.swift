//
//  MovieAppUITests.swift
//  MovieAppUITests
//
//  Created by Ghassan ALMarei on 7/11/17.
//  Copyright © 2017 Hawish Softwares. All rights reserved.
//

import XCTest

class MovieAppUITests: XCTestCase {
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    func testSearchForMovie() {

        let app = XCUIApplication()
        app.launch()

        app.navigationBars["MovieApp.SearchTableView"].searchFields["Search for movie"].tap()
        app.navigationBars["UISearch"].searchFields["Search for movie"].typeText("Batman")
        app.buttons["Search"].tap()

        app.navigationBars["Batman"].children(matching: .button).matching(identifier: "Back").element(boundBy: 1).tap()
        app.navigationBars["UISearch"].searchFields["Search for movie"].tap()

        let batmanStaticText = app.tables.staticTexts["Batman"]
        batmanStaticText.tap()
    }
}
