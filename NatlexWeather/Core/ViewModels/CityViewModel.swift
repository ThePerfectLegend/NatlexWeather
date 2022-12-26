//
//  CityViewModel.swift
//  NatlexWeather
//
//  Created by Nizami Tagiyev on 21.12.2022.
//

import Foundation
import Combine
import CoreLocation

final class CityViewModel: ObservableObject {
    @Published var cities: [GeocodingResponseModel] = []
    @Published var searchCity: String = ""
    @Published var weatherConditions: [WeatherModel] = []
    
    private let portfolioDataService = PortfolioDataService()
    
    private var citySubscription: AnyCancellable?
    
    private var cancellable = Set<AnyCancellable>()
    
    init() {
        addSubscriber()
    }
    
    private func addSubscriber() {
        $searchCity
            .dropFirst(1)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .filter { !$0.isEmpty }
            .sink(receiveValue: fetchCities)
            .store(in: &cancellable)
        
        portfolioDataService.$savedEntities
            .map(mapSavedDataToWeather)
            .sink { [weak self] (returnedWeather) in
                self?.weatherConditions = returnedWeather
                print(self?.weatherConditions as Any)
            }
            .store(in: &cancellable)
    }
    
    private func fetchCities(_ cityName: String) {
        guard let url = URL(string: "http://api.openweathermap.org/geo/1.0/direct?q=\(cityName)&limit=10&appid=bd3e99cd99a7217364bf6a8c80e59772") else { return }
        
        citySubscription = NetworkingManager.download(url: url)
            .decode(type: [GeocodingResponseModel].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedCities) in
                self?.cities = returnedCities
                self?.citySubscription?.cancel()
            })
    }
    
    public func addWeatherCondition(_ geocodingData: GeocodingResponseModel) {
        let _geocoding = Set(weatherConditions.map { $0.geocoding })
        if !_geocoding.contains(geocodingData) {
            let weather = WeatherModel(geocoding: geocodingData)
            weatherConditions.append(weather)
            portfolioDataService.updatePortfolio(weather: weather)
        }
    }
    
    private func mapSavedDataToWeather(_ data: [WeatherEntity]) -> [WeatherModel] {
        var _weather: [WeatherModel] = []
        data.forEach { weatherEntity in
            let _geocoding = GeocodingResponseModel(name: weatherEntity.geocodingEntity!.name!,
                                                    lat: weatherEntity.geocodingEntity!.lat,
                                                    lon: weatherEntity.geocodingEntity!.lon,
                                                    country: weatherEntity.geocodingEntity!.country!,
                                                    state: weatherEntity.geocodingEntity?.state)
            let _weatherModel = WeatherModel(id: weatherEntity.id!, geocoding: _geocoding)
            _weather.append(_weatherModel)
        }
        return _weather
    }
}
