//
//  NetworkManager.swift
//  NatlexWeather
//
//  Created by Nizami Tagiyev on 21.12.2022.
//

import Foundation

class NetworkManager {
    
    static let instance = NetworkManager()
    
    private init() { }
        
    func download(url: URL) async throws -> Data {
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let outputResponse = response as? HTTPURLResponse,
              outputResponse.statusCode >= 200 && outputResponse.statusCode < 300
        else {
            throw URLError(.badServerResponse)
        }
        return data
    }
}
