//
//  APIService.swift
//  iOS Concurrency - Stewart Lynch
//
//  Created by Simran Preet Singh Narang on 2022-04-25.
//

import Foundation

struct APIService {
    
    let urlString: String
    
    func getJSON<ResponseType: Decodable>(dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .iso8601,
                                           keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys,
                                           completion: @escaping (Result<ResponseType, APIError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                      completion(.failure(.invalidResponse))
                      return
                  }
            
            guard error == nil else {
                completion(.failure(.dataTaskError))
                return
            }
            guard let data = data else {
                completion(.failure(.corruptData))
                return
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = dateDecodingStrategy
            decoder.keyDecodingStrategy = keyDecodingStrategy
            
            do {
                let decodedData = try decoder.decode(ResponseType.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(.decodingError))
            }
            
        }.resume()
    }
}


enum APIError: Error {
    case invalidURL
    case invalidResponse
    case dataTaskError
    case corruptData
    case decodingError
}
