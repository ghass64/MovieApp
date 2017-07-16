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
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.

    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSearchForMovie()
    {
        
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
