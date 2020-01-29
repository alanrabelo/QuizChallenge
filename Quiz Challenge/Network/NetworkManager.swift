//
//  NetworkManager.swift
//  Quiz Challenge
//
//  Created by Alan Martins on 29/01/20.
//  Copyright © 2020 Alan Rabelo Martins. All rights reserved.
//

import Foundation
class NetworkManager {
    
    func getQuiz(_ completion: (_ quiz: Quiz?)->Void) {
        
        guard let url = URL(string: "https://exampleapi.com/data.json") else {
            
            completion(nil)
            return
        }
            
        let jsonString = ""
        let jsonData = jsonString.data(using: .utf8)!
        
        do {
            let response = try JSONDecoder().decode(Quiz.self, from: jsonData)
        } catch let error {
            print(error.localizedDescription)
            completion(nil)
        }
    }
}
