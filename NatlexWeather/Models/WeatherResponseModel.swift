//
//  WeatherModel.swift
//  NatlexWeather
//
//  Created by Nizami Tagiyev on 19.12.2022.
//

import Foundation

struct WeatherResponseModel: Codable, Identifiable {
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
    let temperature: Double
    let feelsLike, minTemperature, maxTemperature: Double
    let pressure, humidity: Int
    
    enum CodingKeys: String, CodingKey {
        case temperature = "temp"
        case humidity, pressure
        case maxTemperature = "temp_max"
        case minTemperature = "temp_min"
        case feelsLike = "feels_like"
    }
}

extension WeatherResponseModel {
    init(_ entity: WeatherResponseEntity) {
        self.id = Int(entity.id)
        self.timezone = Int(entity.timezone)
        self.date = Int(entity.date)
        self.name = entity.name ?? ""
        if let unwrappedCoordinate = entity.coordinateEntity {
            self.coordinate = Coordinate(unwrappedCoordinate)
        } else {
            self.coordinate = Coordinate(lon: 0, lat: 0)
        }
        if let unwrappedCondition = entity.conditionEntity {
            self.condition = Condition(unwrappedCondition)
        } else {
            self.condition = Condition(temperature: 0, feelsLike: 0, minTemperature: 0, maxTemperature: 0, pressure: 0, humidity: 0)
        }
    }
}

extension Coordinate {
    init(_ entity: CoordinateEntity) {
        self.lon = entity.lon
        self.lat = entity.lat
    }
}

extension Condition {
    init(_ entity: ConditionEntity) {
        self.pressure = Int(entity.pressure)
        self.temperature = entity.temperature
        self.minTemperature = entity.minTemperature
        self.maxTemperature = entity.maxTemperature
        self.humidity = Int(entity.humidity)
        self.feelsLike = entity.feelsLike
    }
}
