//
//  Quiz_ChallengeUITests.swift
//  Quiz ChallengeUITests
//
//  Created by Alan Martins on 29/01/20.
//  Copyright © 2020 Alan Rabelo Martins. All rights reserved.
//

import XCTest
import Quiz_Challenge

class QuizChallengeUITests: XCTestCase {
    
    let app = XCUIApplication()

    override func setUp() {
        
        super.setUp()
        continueAfterFailure = false
        app.launchArguments = ["UITests"]
        app.launch()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInsertCorrectWord() {
    
        app.buttons["Start"].tap()
        typeText("for")
        app/*@START_MENU_TOKEN@*/.buttons["Done"]/*[[".keyboards",".buttons[\"concluído\"]",".buttons[\"Done\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        XCTAssertEqual(app.tables.staticTexts.count, 1)
        app.terminate()
    }
    
    func testInsertWrongWord() {
        
        app.buttons["Start"].tap()
        typeText("fol")
        app.buttons["Done"].tap()
        XCTAssertEqual(app.tables.staticTexts.count, 0)
        app.terminate()
    }
    
    func typeText(_ text: String) {
        app.textFields["Insert Word"].tap()
        
        for char in text {
            let key = app.keys[String(char)]
            key.tap()
        }
    }
}


extension XCUIElement {
    // The following is a workaround for inputting text in the
    //simulator when the keyboard is hidden
    func setText(text: String, application: XCUIApplication) {
        UIPasteboard.general.string = text
        doubleTap()
        application.menuItems["Paste"].tap()
    }
}
