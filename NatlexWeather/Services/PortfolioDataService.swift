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
    
    func updatePortfolio(weather: WeatherModel) {
        if let entity = savedEntities.first(where: { $0.id == weather.id }) {
            // логика на обновление данных о погоде
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
    
    private func update(entity: WeatherEntity, weather: WeatherResponseModel) {
        // Добавляем новый массив с погодой
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
