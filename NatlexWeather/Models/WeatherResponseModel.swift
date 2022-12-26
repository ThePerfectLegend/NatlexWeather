//
//  WeatherModel.swift
//  NatlexWeather
//
//  Created by Nizami Tagiyev on 19.12.2022.
//

import Foundation

struct WeatherResponseModel: Codable {
    let coordinate: Coordinate
    let condition: Condition
    let date: Int
    let timezone, id: Int
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case coordinate = "coord"
        case date = "dt"
        case condition = "main"
        case timezone, id, name
    }
}

struct Coordinate: Codable {
    let lon, lat: Double
}

struct Condition: Codable {
    let temperature, feelsLike, minTemperature, maxTemperature: Double
    let pressure, humidity: Int
    
    enum CodingKeys: String, CodingKey {
        case temperature = "temp"
        case humidity, pressure
        case maxTemperature = "temp_max"
        case minTemperature = "temp_min"
        case feelsLike = "feels_like"
    }
}
