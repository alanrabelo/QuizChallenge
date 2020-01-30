//
//  ViewController.swift
//  Quiz Challenge
//
//  Created by Alan Martins on 29/01/20.
//  Copyright © 2020 Alan Rabelo Martins. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var questionTitle: UILabel!
    @IBOutlet weak var textFieldWord: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var labelCorrectNumber: UILabel!
    @IBOutlet weak var labelRemainingTime: UILabel!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    let gameManager = GameManager(withPossibleWords: ["for", "do", "while"], andRemainingTime: 10)
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

        loadingView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(loadingView)
        NSLayoutConstraint.activate([
            loadingView.heightAnchor.constraint(equalTo: self.view.heightAnchor),
            loadingView.widthAnchor.constraint(equalTo: self.view.heightAnchor),
            loadingView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        NetworkManager.getQuiz { (quiz) in
            if let quiz = quiz {
                self.gameManager.quiz = quiz
            }
            DispatchQueue.main.async {
                
                self.loadingView.removeFromSuperview()
            }
        }
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            bottomConstraint.constant = 16
        } else {
            bottomConstraint.constant = keyboardViewEndFrame.height
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
    
    @IBAction func didTapScreen(_ sender: Any) {
        
        self.view.endEditing(true)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
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

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        return gameManager.isRunning
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return gameManager.isRunning
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        guard let text = textField.text else { return false }
        gameManager.add(text)
        textField.text = nil
        return true
    }
}

extension ViewController : GameManagerDelegate {
    
    func didUpdateCorrectPercentage(_ text: String) {
        
        self.labelCorrectNumber.text = text
    }
    
    func didUpdateRemainingTime(_ text: String) {

        self.labelRemainingTime.text = text
    }
    
    func gameDidReset() {
        
        self.tableView.reloadData()
        self.textFieldWord.text = nil
    }
    
    func didInsertText(_ indexPath: IndexPath) {
        
        self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .left)
    }
    
    func didLostGame(withHitNumber hitNumber: Int, andNumberOfWords numberOfWords: Int) {
        
        let controller = Alert.getLoseAlertController(hitNumber, numberOfWords: numberOfWords) { (action) in
            
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
            self.questionTitle.text = title
    }
}
