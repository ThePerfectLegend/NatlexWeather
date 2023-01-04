//
//  PortfolioDataService.swift
//  NatlexWeather
//
//  Created by Nizami Tagiyev on 23.12.2022.
//

import Foundation
import CoreData

class PortfolioDataService {
    
    private let container: NSPersistentContainer
    private let containerName = "WeatherContainer"
    private let entityName = "WeatherEntity"
    
    @Published var savedEntities: [WeatherEntity] = []
    
    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { (_, error) in
            if let error = error {
                print("Error loading CoreData: \(error)")
            }
        }
        self.getPortfolio()
    }
    
    // MARK: Public
    
    func addCity(weather: WeatherModel) {
        add(weather: weather)
    }
    
    func updatePortfolio(weather: WeatherModel) {
        if let entity = savedEntities.first(where: { $0.id == weather.id }) {
            update(entity: entity, weather: weather)
        } else {
            add(weather: weather)
        }
    }
    
    // MARK: Private
    
    private func getPortfolio() {
        let request = NSFetchRequest<WeatherEntity>(entityName: entityName)
        do {
            savedEntities = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching portfolio: \(error)")
        }
    }
    
    private func add(weather: WeatherModel) {
        let entity = WeatherEntity(context: container.viewContext)
        entity.id = weather.id
        
        let geocoding = GeocodingEntity(context: container.viewContext)
        geocoding.name = weather.geocoding.name
        geocoding.country = weather.geocoding.country
        geocoding.state = weather.geocoding.state
        geocoding.lat = weather.geocoding.lat
        geocoding.lon = weather.geocoding.lon
        
        entity.geocodingEntity = geocoding
        applyChanges()
    }
    
    private func update(entity: WeatherEntity, weather: WeatherModel) {
        if let lastUpdatedWeatherCondition = weather.conditions.last {
            let weatherResponse = WeatherResponseEntity(context: container.viewContext)
            weatherResponse.weatherEntity = entity
            
            weatherResponse.id = Int32(lastUpdatedWeatherCondition.id)
            weatherResponse.name = lastUpdatedWeatherCondition.name
            weatherResponse.date = Int32(lastUpdatedWeatherCondition.date)
            weatherResponse.timezone = Int32(lastUpdatedWeatherCondition.timezone)
            
            let coordinate = CoordinateEntity(context: container.viewContext)
            coordinate.lat = lastUpdatedWeatherCondition.coordinate.lat
            coordinate.lon = lastUpdatedWeatherCondition.coordinate.lon
            weatherResponse.coordinateEntity = coordinate
            
            let condition = ConditionEntity(context: container.viewContext)
            condition.temperature = lastUpdatedWeatherCondition.condition.temperature
            condition.feelsLike = lastUpdatedWeatherCondition.condition.feelsLike
            condition.humidity = Int32(lastUpdatedWeatherCondition.condition.humidity)
            condition.pressure = Int32(lastUpdatedWeatherCondition.condition.pressure)
            condition.maxTemperature = lastUpdatedWeatherCondition.condition.maxTemperature
            condition.minTemperature = lastUpdatedWeatherCondition.condition.minTemperature
            weatherResponse.conditionEntity = condition
            
            entity.weatherResponseEntity?.adding(weatherResponse)
            
        }
        
        applyChanges()
    }
    
    private func save() {
        do {
            try container.viewContext.save()
        } catch let error {
         print("Error saving to CoreData: \(error)")
        }
    }
    
    private func applyChanges() {
        save()
        getPortfolio()
    }
}
