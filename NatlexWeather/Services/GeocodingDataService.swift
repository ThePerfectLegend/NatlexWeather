//
//  GeocodingDataService.swift
//  NatlexWeather
//
//  Created by Nizami Tagiyev on 21.12.2022.
//

import Foundation
import Combine

final class GeocodingDataService {
    
    @Published var cities: [GeocodingResponseModel] = []
    
    private var citySubscription: AnyCancellable?
    
    public func fetchCities(searchCity: String) {
        guard let url = URL(string: "http://api.openweathermap.org/geo/1.0/direct?q=\(searchCity)&limit=10&appid=bd3e99cd99a7217364bf6a8c80e59772") else { return }
        
        citySubscription = NetworkingManager.download(url: url)
            .decode(type: [GeocodingResponseModel].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedCities) in
                self?.cities = returnedCities
                self?.citySubscription?.cancel()
            })
    }
}
