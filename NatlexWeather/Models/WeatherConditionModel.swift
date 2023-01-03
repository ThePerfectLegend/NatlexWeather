//
//  WeatherConditionModel.swift
//  NatlexWeather
//
//  Created by Nizami Tagiyev on 03.01.2023.
//

import Foundation

struct WeatherConditionModel: Identifiable {
    var id = UUID().uuidString
    let date: Date
    let temperature: Double
    let maxTemperature: Double
    let minTemperature: Double
}

extension WeatherConditionModel {
    init(from weatherResponse: WeatherResponseModel, isCelsius: Bool) {
        date = weatherResponse.date.asDate()
        if isCelsius {
            temperature = weatherResponse.condition.temperature.asCelsius()
            maxTemperature = weatherResponse.condition.maxTemperature.asCelsius()
            minTemperature = weatherResponse.condition.minTemperature.asCelsius()
        } else {
            temperature = weatherResponse.condition.temperature.asFahrenheit()
            maxTemperature = weatherResponse.condition.maxTemperature.asFahrenheit()
            minTemperature = weatherResponse.condition.minTemperature.asFahrenheit()
        }
    }
}
