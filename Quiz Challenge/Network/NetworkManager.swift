//
//  NetworkManager.swift
//  Quiz Challenge
//
//  Created by Alan Martins on 29/01/20.
//  Copyright © 2020 Alan Rabelo Martins. All rights reserved.
//

import Foundation

enum QuizError : Error {
    case noData
    case wrongStatus
    case decodingError
    case urlError
    case requestError
}

class NetworkManager {
    
    static func getQuiz(_ completion: @escaping (Result<Quiz, QuizError>, _ message: String?)->Void) {
        guard let url = URL(string: "https://codechallenge.arctouch.com/quiz/1") else {
            completion(.failure(.urlError), nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                completion(.failure(.requestError), error!.localizedDescription)
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200..<299 ~= statusCode else {
                completion(.failure(.wrongStatus), nil)
                return
            }
            
            guard let quizData = data else {
                completion(.failure(.noData), nil)
                return
            }
            
            do {
                let quiz = try JSONDecoder().decode(Quiz.self, from: quizData)
                completion(.success(quiz), nil)
            } catch {
                completion(.failure(.decodingError), nil)
            }
        }.resume()
    }
}
