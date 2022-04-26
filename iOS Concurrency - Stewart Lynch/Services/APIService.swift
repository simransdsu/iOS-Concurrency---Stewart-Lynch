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
                                          keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys) async throws -> ResponseType {
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                      throw APIError.invalidResponse
                  }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = dateDecodingStrategy
            decoder.keyDecodingStrategy = keyDecodingStrategy
            
            let decodedData = try decoder.decode(ResponseType.self, from: data)
                
            return decodedData
        } catch {
            throw APIError.dataTaskError(error.localizedDescription)
        }
        
    }
    
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
                completion(.failure(.dataTaskError(error!.localizedDescription)))
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
                completion(.failure(.decodingError(error.localizedDescription)))
            }
            
        }.resume()
    }
}


enum APIError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case dataTaskError(String)
    case corruptData
    case decodingError(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return NSLocalizedString("The endpoint URL is invalid", comment: "")
        case .invalidResponse:
            return NSLocalizedString("The API failed to issue a valid response", comment: "")
        case .dataTaskError(let string):
            return string
        case .corruptData:
            return NSLocalizedString("The data provided appears to be corrupt", comment: "")
        case .decodingError(let string):
            return string
        }
    }
}
