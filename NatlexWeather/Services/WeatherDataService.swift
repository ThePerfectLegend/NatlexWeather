//
//  WeatherService.swift
//  NatlexWeather
//
//  Created by Nizami Tagiyev on 19.12.2022.
//

import Foundation
import Combine

final class WeatherDataService {
    @Published var weather: WeatherResponseModel?
    private var weatherSubscription: AnyCancellable?
    
    public func getWeather(latitude: Double, longitude: Double) {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=bd3e99cd99a7217364bf6a8c80e59772") else { return }
        
        weatherSubscription = NetworkingManager.download(url: url)
            .decode(type: WeatherResponseModel.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedWeather) in
                self?.weather = returnedWeather
                self?.weatherSubscription?.cancel()
            })
    }
}
