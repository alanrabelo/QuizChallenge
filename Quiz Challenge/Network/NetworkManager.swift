//
//  NetworkManager.swift
//  Quiz Challenge
//
//  Created by Alan Martins on 29/01/20.
//  Copyright © 2020 Alan Rabelo Martins. All rights reserved.
//

import Foundation
class NetworkManager {
    
    static func getQuiz(_ completion: @escaping (_ quiz: Quiz?)->Void) {
        
        guard let url = URL(string: "https://codechallenge.arctouch.com/quiz/1") else {
            
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { (result) in
           switch result {
                case .success(let (response, data)):
                    guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200..<299 ~= statusCode else {
                        completion(nil)
                        return
                    }
                    do {
                        let quiz = try JSONDecoder().decode(Quiz.self, from: data)
                        completion(quiz)
                    } catch {
                        completion(nil)
                    }
               case .failure(_):
                    completion(nil)
           }
        }.resume()
    }
}

extension URLSession {
    func dataTask(with url: URL, result: @escaping (Result<(URLResponse, Data), Error>) -> Void) -> URLSessionDataTask {
        return dataTask(with: url) { (data, response, error) in
            if let error = error {
                result(.failure(error))
                return
            }
            guard let response = response, let data = data else {
                let error = NSError(domain: "error", code: 0, userInfo: nil)
                result(.failure(error))
                return
            }
            result(.success((response, data)))
        }
    }
}
