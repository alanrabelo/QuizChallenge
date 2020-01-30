////
////  Quiz_ChallengeUITests.swift
////  Quiz ChallengeUITests
////
////  Created by Alan Martins on 29/01/20.
////  Copyright © 2020 Alan Rabelo Martins. All rights reserved.
////
//
//import XCTest
//
//class Quiz_ChallengeUITests: XCTestCase {
//
//    override func setUp() {
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//
//        // In UI tests it is usually best to stop immediately when a failure occurs.
//        continueAfterFailure = false
//
//        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
//    }
//
//    override func tearDown() {
//        let app = XCUIApplication()
//        app.terminate()
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//    }
//
//    func testInsertCorrectWord() {
//        
//        let app = XCUIApplication()
//        app.launch()
//        
//        let wordTable = app.tables["Empty list"]
//        app.buttons["Start"].tap()
//        app.textFields["Insert Word"].tap()
//        
//        let fKey = app/*@START_MENU_TOKEN@*/.keys["f"]/*[[".keyboards.keys[\"f\"]",".keys[\"f\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//        fKey.tap()
//        fKey.tap()
//        
//        let oKey = app/*@START_MENU_TOKEN@*/.keys["o"]/*[[".keyboards.keys[\"o\"]",".keys[\"o\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//        oKey.tap()
//        oKey.tap()
//        
//        let rKey = app/*@START_MENU_TOKEN@*/.keys["r"]/*[[".keyboards.keys[\"r\"]",".keys[\"r\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//        rKey.tap()
//        rKey.tap()
//        app/*@START_MENU_TOKEN@*/.buttons["Done"]/*[[".keyboards",".buttons[\"concluído\"]",".buttons[\"Done\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
//        waitForExpectations(timeout: 1) { (error) in
//            XCTAssertEqual(wordTable.cells.count, 1)
//        }
//    }
//    
//    func testInsertWrongWord() {
//        
//        let app = XCUIApplication()
//        app.launch()
//        
//        let wordTable = app.tables["Empty list"]
//        app.buttons["Start"].tap()
//        app.textFields["Insert Word"].tap()
//        
//        let fKey = app.keys["d"]
//        fKey.tap()
//        fKey.tap()
//        
//        let oKey = app/*@START_MENU_TOKEN@*/.keys["o"]/*[[".keyboards.keys[\"o\"]",".keys[\"o\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//        oKey.tap()
//        oKey.tap()
//        
//        let rKey = app/*@START_MENU_TOKEN@*/.keys["r"]/*[[".keyboards.keys[\"r\"]",".keys[\"r\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//        rKey.tap()
//        rKey.tap()
//        app/*@START_MENU_TOKEN@*/.buttons["Done"]/*[[".keyboards",".buttons[\"concluído\"]",".buttons[\"Done\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
//        
//        XCTAssertEqual(wordTable.cells.count, 0)
//    }
//
//    func testLaunchPerformance() {
//        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
//            // This measures how long it takes to launch your application.
//            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
//                XCUIApplication().launch()
//            }
//        }
//    }
//}
//
//
//extension XCUIElement {
//    // The following is a workaround for inputting text in the
//    //simulator when the keyboard is hidden
//    func setText(text: String, application: XCUIApplication) {
//        UIPasteboard.general.string = text
//        doubleTap()
//        application.menuItems["Paste"].tap()
//    }
//}
