//
//  WeatherViewModel.swift
//  NatlexWeather
//
//  Created by Nizami Tagiyev on 19.12.2022.
//

import Foundation
import Combine
import CoreLocation

final class WeatherViewModel: ObservableObject {
    @Published var currentWeather: WeatherResponseModel?
    @Published private(set) var isLoadingCurrentLocation = false
    @Published private(set) var locationError: LocationError?
    
    @Published var weatherInCities: [WeatherModel] = []
    @Published var cities: [GeocodingResponseModel] = []
    @Published var searchCity: String = ""
    
    @Published var isCelsius = false
    
    private let locationManager = LocationManager()
    let weatherService = WeatherDataService()
    private let geocodingService = GeocodingDataService()
    let portfolioDataService = PortfolioDataService()
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
    
    // MARK: Public
    
    public func fetchLocation() {
        isLoadingCurrentLocation = true
        locationManager.requestWhenInUseAuthorization()
            .flatMap { self.locationManager.requestLocation() }
            .sink { completion in
                if case .failure(let error) = completion {
                    self.locationError = error
                }
                self.isLoadingCurrentLocation = false
            } receiveValue: { [weak self] (location) in
                guard let self = self else { return }
                self.weatherService.getWeather(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                self.weatherService.$weather.receive(on: DispatchQueue.main)
                    .sink(receiveValue: { [weak self] (updatedWeather) in
                        self?.currentWeather = updatedWeather
                    })
                    .store(in: &self.cancellables)
            }
            .store(in: &cancellables)
    }
    
    public func addCity(_ geocodingData: GeocodingResponseModel) {
        let _geocoding = Set(weatherInCities.map { $0.geocoding })
        if !_geocoding.contains(geocodingData) {
            let weather = WeatherModel(geocoding: geocodingData)
            //            print("--- addCity: \(weather.id)  ---")
            weatherInCities.append(weather)
            weatherService.getWeather(latitude: weather.geocoding.lat, longitude: weather.geocoding.lon, id: weather.id)
            self.portfolioDataService.updatePortfolio(weather: weather)
        }
    }
    
    // MARK: Private
    
    private func addSubscribers() {
        $searchCity
            .dropFirst()
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .filter { !$0.isEmpty }
            .sink { [weak self] (cityName) in
                guard let self = self else { return }
                self.geocodingService.fetchCities(searchCity: cityName)
                self.geocodingService.$cities.receive(on: DispatchQueue.main)
                    .sink { [weak self] returnedCities in
                        self?.cities = returnedCities
                    }
                    .store(in: &self.cancellables)
            }
            .store(in: &cancellables)
        
        portfolioDataService.$savedEntities
            .map(mapSavedDataToWeatherInCities)
            .sink { [weak self] (returnedWeather) in
                self?.weatherInCities = returnedWeather
            }
            .store(in: &cancellables)
        
        weatherService.$weatherConditions
            .map(mapWeatherToCity)
            .sink { (index, weatherResponseModel) in
                if let unwrappedIndex = index,
                   let unwrappedWeatherModel = weatherResponseModel {
                    self.weatherInCities[unwrappedIndex].conditions.append(unwrappedWeatherModel)
                    self.portfolioDataService.updatePortfolio(weather: self.weatherInCities[unwrappedIndex])
                }
            }
            .store(in: &cancellables)
    }
    
    private func mapSavedDataToWeatherInCities(_ data: [WeatherEntity]) -> [WeatherModel] {
        var _weather: [WeatherModel] = []
        data.forEach { weatherEntity in
            if let unwrappedGeocoding = weatherEntity.geocodingEntity {
                let _geocoding = GeocodingResponseModel(unwrappedGeocoding)
                let _conditions: [WeatherResponseModel] = (weatherEntity.weatherResponseEntity?.map({ WeatherResponseModel($0 as! WeatherResponseEntity)}))!
                let _weatherModel = WeatherModel(id: weatherEntity.id ?? "", geocoding: _geocoding, conditions: _conditions)
                _weather.append(_weatherModel)
                weatherService.getWeather(latitude: _geocoding.lat, longitude: _geocoding.lon, id: _weatherModel.id)
            }
        }
        return _weather
    }
    
    private func mapWeatherToCity(_ weatherCondition: [String: WeatherResponseModel]) -> (Int?, WeatherResponseModel?) {
        var returnedWeatherResponseModel: WeatherResponseModel?
        var returnedIndex: Int?
        weatherInCities.enumerated().forEach { (index, weatherModel) in
            if let matchedWeatherResponse = weatherCondition[weatherModel.id] {
                returnedWeatherResponseModel = matchedWeatherResponse
                returnedIndex = index
            }
        }
        //        print("\(returnedIndex) \(returnedWeatherResponseModel)")
        return (returnedIndex, returnedWeatherResponseModel)
    }
}
