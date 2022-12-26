//
//  CityDetailViewModel.swift
//  NatlexWeather
//
//  Created by Nizami Tagiyev on 22.12.2022.
//

import Foundation

final class CityDetailViewModel: ObservableObject {
    
    @Published var weather: WeatherModel
    
    init(weather: WeatherModel) {
        self.weather = weather
    }
    
}
