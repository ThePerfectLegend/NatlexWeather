//
//  WeatherDetailViewModel.swift
//  NatlexWeather
//
//  Created by Nizami Tagiyev on 03.01.2023.
//

import Foundation

final class WeatherDetailViewModel: ObservableObject {
    
    let weather: WeatherModel
    let isCelsius: Bool
    @Published var weatherConditions: [WeatherConditionModel] = []
    @Published var dateFrom = Date()
    @Published var dateTo = Date()
    
    init(weather: WeatherModel, isCelsius: Bool) {
        self.weather = weather
        self.isCelsius = isCelsius
        self.weatherConditions = filterAndMapConditionsByDays(weather.conditions)
    }
    
    private func filterAndMapConditionsByDays(_ condition: [WeatherResponseModel]) -> [WeatherConditionModel] {
        var returnedCondition: [WeatherConditionModel] = []
        let dates: [Date] = condition.map { $0.date.asDate() }
        
        var latestDatePerDay: [Date: Date] = [:]
        
        for date in dates {
            let day = Calendar.current.startOfDay(for: date)
            let currentLatest = latestDatePerDay[day]
            if currentLatest == nil || date > currentLatest! {
                latestDatePerDay[day] = date
            }
        }
        
        let latestDates = latestDatePerDay
            .map { $0.value }
            .sorted(by: <)
        
        print(latestDates)
        
        if let maxDate = latestDates.max(),
           let minDate = latestDates.min() {
            dateFrom = minDate
            dateTo = maxDate
        }
        
        returnedCondition = condition
            .filter { latestDates.contains($0.date.asDate()) }
            .map { WeatherConditionModel(from: $0, isCelsius: isCelsius) }
        
        return returnedCondition
    }
}
