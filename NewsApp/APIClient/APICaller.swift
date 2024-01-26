//
//  APICaller.swift
//  NewsApp
//
//  Created by João Vitor Sousa on 26/01/24.
//

import Foundation

final class APICaller {
    
    static let shared = APICaller()
    
    struct Constants {
        static let topHeadlinesURL = URL(string: "https://newsapi.org/v2/top-headlines?language=en&apiKey=74af47625cab4b6ba319dbbd6a2abf14")
        static let searchUrlString = "https://newsapi.org/v2/everything?sortBy=popularity&apiKey=74af47625cab4b6ba319dbbd6a2abf14&q="
    }
        
    public func getTopStories(completion: @escaping (Result<[Articles], Error>) -> Void) {
        guard let url = Constants.topHeadlinesURL else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    completion(.success(result.articles))
                }
                
                catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    public func search(with query: String, completion: @escaping (Result<[Articles], Error>) -> Void) {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        let urlString = Constants.searchUrlString + query
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    completion(.success(result.articles))
                }
                
                catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}
