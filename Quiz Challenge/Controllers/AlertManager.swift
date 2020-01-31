//
//  AlertManager.swift
//  Quiz Challenge
//
//  Created by Alan Martins on 29/01/20.
//  Copyright © 2020 Alan Rabelo Martins. All rights reserved.
//

import Foundation
import UIKit

class Alert {
    static func getWinAlertController(_ completion : ((UIAlertAction) -> Void)?) -> UIAlertController {
        return Alert.getSimpleAlertController(WithTitle: "Congratulations", andMessage: "Good job! You found all the answers on time. Keep up with the great work.", AndButtonTitle: "Play Again", completion)
    }
    
    static func getLoseAlertController(withNumberOfHists numberOfHits: Int, andNumberOfWords numberOfWords: Int, _ completion : ((UIAlertAction) -> Void)?) -> UIAlertController {
        return Alert.getSimpleAlertController(WithTitle: "Time Finished", andMessage: "Sorry, time is up! You got \(numberOfHits) of \(numberOfWords) answers.", AndButtonTitle: "Try Again", completion)
    }
    
    static func getSimpleAlertController(WithTitle title: String, andMessage message: String, AndButtonTitle buttonTitle: String, _ completion : ((UIAlertAction) -> Void)?) -> UIAlertController {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: buttonTitle, style: .default, handler: completion)
        controller.addAction(action)
        return controller
    }
}
