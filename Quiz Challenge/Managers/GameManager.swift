//
//  GameManager.swift
//  Quiz Challenge
//
//  Created by Alan Martins on 29/01/20.
//  Copyright © 2020 Alan Rabelo Martins. All rights reserved.
//

import Foundation

class GameManager {
    weak var delegate: GameManagerDelegate?
    let totalTime: TimeInterval
    var remainingTime: TimeInterval
    var timer: Timer?
    var isRunning = false
    var possibleWords = Set<String>()
    var wordsFound = [String]()
    
    var quiz: Quiz? {
        didSet {
            self.setupInitialLayout()
        }
    }

    var correctsText: String {
        return String(format: "%02d/%02d", wordsFound.count, possibleWords.count)
    }
    
    var remainingTimeText: String {
        let minutes = Int(remainingTime / 60)
        let seconds = Int(remainingTime.truncatingRemainder(dividingBy: 60))
        return String(format: "%02d:%02d", minutes, seconds)
    }

    init(withPossibleWords possibleWords: [String], andRemainingTime totalTime: TimeInterval) {
        self.possibleWords = Set(possibleWords)
        self.totalTime = totalTime
        self.remainingTime = totalTime
    }
    
    init(withPossibleWords possibleWords: [String]) {
        self.possibleWords = Set(possibleWords)
        self.totalTime = 300
        self.remainingTime = self.totalTime
    }
    
    func add(_ word: String) {
        if possibleWords.contains(word) && !wordsFound.contains(word) {
            let lastIndexPath = IndexPath(row: wordsFound.count, section: 0)
            wordsFound.insert(word, at: 0)
            self.delegate?.didUpdateCorrectPercentage(self.correctsText)
            self.delegate?.didInsertText(lastIndexPath)
            self.delegate?.didHitWord()
            
            if Set(wordsFound).count == possibleWords.count {
                self.timer?.invalidate()
                self.isRunning = false
                self.delegate?.didWinGame()
            }
        }
    }
    
    func startGame() {
        self.isRunning = true
        self.timer?.invalidate()
        self.setupInitialLayout()
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
            if self.remainingTime <= 0 {
                timer.invalidate()
                self.delegate?.didLostGame(withHitNumber: self.wordsFound.count, andNumberOfWords: self.possibleWords.count)
                self.remainingTime = self.totalTime
            } else {
                self.remainingTime -= 1
                self.delegate?.didUpdateRemainingTime(self.remainingTimeText)
            }
        })
    }
    
    func setupInitialLayout() {
        self.remainingTime = self.totalTime
        if let possibleWords = self.quiz?.answer {
            self.possibleWords = Set(possibleWords)
        }
        
        DispatchQueue.main.async {
            self.delegate?.didupdateQuestionTitle(self.quiz?.question)
            self.wordsFound = []
            self.delegate?.gameDidReset()
            self.delegate?.didUpdateRemainingTime(self.remainingTimeText)
            self.delegate?.didUpdateCorrectPercentage(self.correctsText)
        }
    }
    
    func resetGame() {
        self.isRunning = false
        self.timer?.invalidate()
        self.timer = nil
        self.remainingTime = self.totalTime
        self.wordsFound = []
        self.delegate?.gameDidReset()
        self.delegate?.didUpdateRemainingTime(self.remainingTimeText)
        self.delegate?.didUpdateCorrectPercentage(self.correctsText)
    }
    
    func stopGame() {
        self.resetGame()
    }
    
    func loadQuiz() {
        NetworkManager.getQuiz { (result, message) in
            switch result {
            case .success(let quiz):
                self.quiz = quiz
                self.delegate?.gameDidLoad()
            case .failure(_):
                self.delegate?.shouldPresentError(message ?? "Error Loading Quiz")
            }
        }
    }
}

protocol GameManagerDelegate: class {
    func didUpdateRemainingTime(_ text: String)
    func didUpdateCorrectPercentage(_ text: String)
    func gameDidReset()
    func didInsertText(_ indexPath: IndexPath)
    func didWinGame()
    func didLostGame(withHitNumber hitNumber: Int, andNumberOfWords numberOfWords: Int)
    func didupdateQuestionTitle(_ title: String?)
    func didHitWord()
    func shouldPresentError(_ message: String)
    func gameDidLoad()
}
