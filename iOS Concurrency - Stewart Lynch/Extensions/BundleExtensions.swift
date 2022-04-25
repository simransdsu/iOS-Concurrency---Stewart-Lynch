//
//  BundleExtensions.swift
//  iOS Concurrency - Stewart Lynch
//
//  Created by Simran Preet Singh Narang on 2022-04-26.
//

import Foundation

extension Bundle {
    
    public func decode<ResponseType: Decodable> (_ type: ResponseType.Type,
                                                 from file: String,
                                                 dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .iso8601,
                                                 keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys) -> ResponseType {
        
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Fauked to load \(file) in bundle")
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = keyDecodingStrategy
        decoder.dateDecodingStrategy = dateDecodingStrategy
        
        guard let decodedData = try? decoder.decode(type, from: data) else {
            fatalError("Failed to decode \(file) in bundle")
        }
        return decodedData
                
    }
}
