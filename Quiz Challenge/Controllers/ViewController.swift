//
//  GameViewController.swift
//  Quiz Challenge
//
//  Created by Alan Martins on 29/01/20.
//  Copyright © 2020 Alan Rabelo Martins. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet weak var labelQuestionTitle: UILabel!
    @IBOutlet weak var textFieldWord: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var labelCorrectNumber: UILabel!
    @IBOutlet weak var labelRemainingTime: UILabel!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var gameManager = GameManager(withPossibleWords: [])
    let notificationCenter = NotificationCenter.default
    let loadingView = LoadingView.instanceFromNib()

    override func viewDidLoad() {
        super.viewDidLoad()
        gameManager.delegate = self
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    override func loadView() {
        super.loadView()

        self.makeTransparent()
        self.showLoadingView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        gameManager.loadQuiz()
    }
    
    func showErrorAlert(_ message: String) {
        let alertController = Alert.getErrorAlertController(message) { (action) in
            self.gameManager.loadQuiz()
        }
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func showLoadingView() {
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(loadingView)
        NSLayoutConstraint.activate([
            loadingView.heightAnchor.constraint(equalTo: self.view.heightAnchor),
            loadingView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            loadingView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
        ])
    }
    
    func hideLoadingView() {
        DispatchQueue.main.async {
            self.loadingView.removeFromSuperview()
        }
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        let keyboardFrame = UIResponder.keyboardFrameEndUserInfoKey
        guard let keyboardValue = notification.userInfo?[keyboardFrame] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            bottomConstraint.constant = 16
        } else {
            bottomConstraint.constant = keyboardViewEndFrame.height + 16
        }
    }
    
    @IBAction func startResetAction(_ sender: UIButton) {
        if gameManager.isRunning {
            gameManager.resetGame()
            sender.setTitle("Start", for: .normal)
        } else {
            gameManager.startGame()
            self.textFieldWord.becomeFirstResponder()
            sender.setTitle("Reset", for: .normal)
        }
    }
    
    func makeTransparent() {
        self.tableView.alpha = 0
        self.textFieldWord.alpha = 0
        self.labelQuestionTitle.alpha = 0
        self.labelCorrectNumber.alpha = 0
        self.labelRemainingTime.alpha = 0
    }
    
    @IBAction func didTapScreen(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func didChangeText(_ sender: UITextField) {
        if let text = sender.text {
            self.gameManager.add(text)
        }
    }
}

extension GameViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.gameManager.wordsFound.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = self.gameManager.wordsFound[indexPath.row]
        return cell
    }
}

extension GameViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return gameManager.isRunning
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return gameManager.isRunning
    }
}

extension GameViewController: GameManagerDelegate {

    func didUpdateCorrectPercentage(_ text: String) {
        self.labelCorrectNumber.text = text
    }
    
    func didUpdateRemainingTime(_ text: String) {
        self.labelRemainingTime.text = text
    }
    
    func gameDidReset() {
        UIView.animate(withDuration: 1, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.1, options: .curveEaseInOut, animations: {
            self.tableView.alpha = 1
            self.textFieldWord.alpha = 1
            self.labelQuestionTitle.alpha = 1
            self.labelCorrectNumber.alpha = 1
            self.labelRemainingTime.alpha = 1
            
        }, completion: nil)
        
        self.tableView.reloadData()
        self.textFieldWord.text = nil
    }
    
    func didInsertText(_ indexPath: IndexPath) {
        self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .left)
    }
    
    func didLostGame(withHitNumber hitNumber: Int, andNumberOfWords numberOfWords: Int) {
        let controller = Alert.getLoseAlertController(withNumberOfHists: hitNumber, andNumberOfWords: numberOfWords) { (action) in
                self.gameManager.startGame()
        }
        
        self.present(controller, animated: true, completion: nil)
    }
    
    func didWinGame() {
        let controller = Alert.getWinAlertController { (action) in
            self.gameManager.startGame()
        }
        self.present(controller, animated: true, completion: nil)
    }
    
    func didupdateQuestionTitle(_ title: String?) {
        self.labelQuestionTitle.text = title
    }
    
    func didHitWord() {
        self.textFieldWord.text = nil
    }
    
    func shouldPresentError(_ message: String) {
        self.showErrorAlert(message)
    }
    
    func gameDidLoad() {
        self.hideLoadingView()
    }
}
