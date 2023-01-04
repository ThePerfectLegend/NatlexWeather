//
//  WeatherDetailViewModel.swift
//  NatlexWeather
//
//  Created by Nizami Tagiyev on 03.01.2023.
//

import Foundation
import Combine

final class WeatherDetailViewModel: ObservableObject {
    
    let weather: WeatherModel
    let isCelsius: Bool
    @Published var showConditions: [WeatherConditionModel] = []
    @Published private var weatherConditions: [WeatherConditionModel] = []
    @Published var dateFrom = Date()
    @Published var dateTo = Date()
    @Published private(set) var dateRange = Date()...Date()
    
    private var cancellables = Set<AnyCancellable>()
    
    init(weather: WeatherModel, isCelsius: Bool) {
        self.weather = weather
        self.isCelsius = isCelsius
        self.weatherConditions = filterAndMapConditionsByDays(weather.conditions)
        addSubscriber()
    }
    
    private func filterAndMapConditionsByDays(_ condition: [WeatherResponseModel]) -> [WeatherConditionModel] {
        var returnedConditions: [WeatherConditionModel] = []
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
            self.dateRange = minDate...maxDate
        }
        
        returnedConditions = condition
            .filter { latestDates.contains($0.date.asDate()) }
            .map { WeatherConditionModel(from: $0, isCelsius: isCelsius) }
        
        showConditions = returnedConditions
        return returnedConditions
    }
    
    private func addSubscriber() {
        $dateFrom
            .combineLatest($dateTo)
            .dropFirst()
            .map(filterAndSortConditions)
            .sink { [weak self] (returnedConditions) in
                self?.showConditions = returnedConditions
            }
            .store(in: &cancellables)
    }
    
    private func filterAndSortConditions(dateFrom: Date, dateTo: Date) -> [WeatherConditionModel] {
        weatherConditions
            .filter { $0.date >= dateFrom && $0.date <= dateTo }
            .sorted(by: <)
    }
}
