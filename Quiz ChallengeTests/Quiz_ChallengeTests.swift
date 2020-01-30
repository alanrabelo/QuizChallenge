//
//  Quiz_ChallengeTests.swift
//  Quiz ChallengeTests
//
//  Created by Alan Martins on 29/01/20.
//  Copyright © 2020 Alan Rabelo Martins. All rights reserved.
//

import XCTest
@testable import Quiz_Challenge

class QuizChallengeTests: XCTestCase {

    let gameManager = GameManager(withPossibleWords: ["if", "else", "while"])
    
    func testDefaultTimerSeconds() {
        
        XCTAssertEqual(gameManager.totalTime, 300)
        XCTAssertEqual(gameManager.remainingTime, 300)
    }
    
    func testDefaultFoundWords() {
        XCTAssertEqual(gameManager.wordsFound, [])
    }
    
    func testDefaultPossibleWords() {
        
        XCTAssertEqual(gameManager.possibleWords, Set(["if", "else", "while"]))
    }
    
    func testDefaultIsNotRunning() {
        
        XCTAssertFalse(gameManager.isRunning)
    }
    
    func testIsRunningAfterStart() {
        
        gameManager.startGame()
        XCTAssertTrue(gameManager.isRunning)
    }
    
    func testIsStoppedAfterStop() {
        
        gameManager.stopGame()
        XCTAssertFalse(gameManager.isRunning)
    }

    func testAddingWordsWithoutWin() {
        
        gameManager.startGame()
        self.gameManager.add("if")
        self.gameManager.add("else")
        XCTAssertTrue(self.gameManager.isRunning)
        XCTAssertEqual(self.gameManager.correctsText, "02/03")
    }
    
    func testAddingWordsWithWin() {
        
        self.gameManager.add("if")
        self.gameManager.add("else")
        self.gameManager.add("while")
        XCTAssertFalse(self.gameManager.isRunning)
        XCTAssertEqual(self.gameManager.correctsText, "03/03")
    }
    
    func testTimeout() {
        
        self.gameManager.add("if")
        Timer.scheduledTimer(withTimeInterval: 1.1, repeats: false) { (timer) in
            XCTAssertTrue(self.gameManager.isRunning)
            XCTAssertEqual(self.gameManager.correctsText, "01/03")
            print("test")
        }
    }
}
