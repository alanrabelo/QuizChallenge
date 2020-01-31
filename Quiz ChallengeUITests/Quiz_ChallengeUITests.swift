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

    func testInsertCorrectWord() {
        app.buttons["Start"].tap()
        typeText("if")
        XCTAssertEqual(app.tables.staticTexts.count, 1)
        app.terminate()
    }
    
    func testInsertWrongWord() {
        app.buttons["Start"].tap()
        typeText("iv")
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
