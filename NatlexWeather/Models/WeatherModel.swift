//
//  WeatherModel.swift
//  NatlexWeather
//
//  Created by Nizami Tagiyev on 22.12.2022.
//

import Foundation

struct WeatherModel: Identifiable, Comparable {
    var id = UUID().uuidString
    let geocoding: GeocodingResponseModel
    var conditions: [WeatherResponseModel] = []
    
    static func < (lhs: WeatherModel, rhs: WeatherModel) -> Bool {
        return lhs.geocoding.name < rhs.geocoding.name
    }
    
    static func == (lhs: WeatherModel, rhs: WeatherModel) -> Bool {
        return lhs.id == rhs.id
    }
}
