//
//  Webservice.swift
//  GoodWeather
//
//  Created by Mohammad Azam on 12/1/18.
//  Copyright © 2018 Mohammad Azam. All rights reserved.
//

import Foundation

typealias new = (Result<Any, WebServiceError>)
enum WebServiceError: Error {
    case badURL
    case decodeError
    case apiError
}


struct Resource<T> {
    let url: URL
    let parse: (Data) -> T?
}

final class WebService {
    
    func load<T>(resource: Resource<T>, completion: @escaping (T?) -> ()) {
        
        URLSession.shared.dataTask(with: resource.url) { data, response, error in
            
            if let data = data {
                DispatchQueue.main.async {
                     completion(resource.parse(data))
                }
            } else {
                completion(nil)
            }
            
        }.resume()
        
    }
    
    func getNews<T: Decodable>(with type: T.Type, completion: @escaping (new) -> Void) {
        
        guard let url = URL(string: "https://island-bramble.glitch.me/top-news") else {
            completion(.failure(.badURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let data = data, error == nil else {
                completion(.failure(.apiError))
                return
            }
            
            if let stocks = try? JSONDecoder().decode(T.self, from: data) {
                completion(.success(stocks))
            } else {
                completion(.failure(.decodeError))
            }
            
        }.resume()
        
    }
    
    @available(iOS 13.0.0, *)
    func getPosts<T: Decodable>(with type: T.Type) async throws -> Any {
        return try await withCheckedThrowingContinuation { continuation in
            getNews(with: type) { result in
                switch result {
                case .success(let posts):
                    continuation.resume(returning: posts)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
        
    }
    
    
}
