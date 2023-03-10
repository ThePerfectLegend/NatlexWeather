//
//  ContentView.swift
//  NatlexWeather
//
//  Created by Nizami Tagiyev on 19.12.2022.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject private var weatherViewModel: WeatherViewModel
    @FocusState private var focusedTextField: Bool
    @State var isCelsius = false
    @State var selectedWeather: WeatherModel?
    
    var body: some View {
        NavigationView {
            VStack {
                searchBar
                    .padding(.horizontal)
                if focusedTextField {
                    searchCityList
                } else {
                    CurrentWeatherView()
                    addedCityList
                }
            }
            .navigationTitle("Weather")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(item: $selectedWeather) {
                WeatherDetailView(isCelsius: weatherViewModel.isCelsius, weather: $0)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    getLocationButton
                        .disabled(weatherViewModel.isLoadingCurrentLocation)
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Image(systemName: "house")
                        .onTapGesture {
                            print(weatherViewModel.weatherInCities)
                        }
                }
            }
        }
    }
}
extension HomeView {
    var getLocationButton: some View {
        Button {
            weatherViewModel.fetchLocation()
        } label: {
            if weatherViewModel.isLoadingCurrentLocation {
                ProgressView()
            } else {
                Image(systemName: "location.north.circle")
            }
        }
    }
    
    var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
                .font(.callout)
            TextField(text: $weatherViewModel.searchCity) {
                Text("City name")
                    .foregroundColor(.secondary)
            }
            .focused($focusedTextField)
        }
        .padding(6)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(.quaternary.opacity(0.75))
        )
    }
    
    @ViewBuilder var searchCityList: some View {
        if !weatherViewModel.searchCity.isEmpty && weatherViewModel.cities.isEmpty {
            VStack(spacing: 12) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                    .font(.largeTitle)
                    .padding(.top)
                Text("Nothing found")
                    .font(.title2.bold())
                Spacer()
            }
        } else {
            List(weatherViewModel.cities, id: \.hashValue) { geocodingResponse in
                VStack(alignment: .leading) {
                    Text("\(geocodingResponse.name) \(geocodingResponse.country)")
                    Text(geocodingResponse.state ?? "")
                        .font(.callout.weight(.medium))
                        .foregroundColor(.secondary)
                }
                .containerShape(Rectangle())
                .onTapGesture {
                    weatherViewModel.addCity(geocodingResponse)
                    focusedTextField = false
                    weatherViewModel.searchCity = ""
                    weatherViewModel.cities.removeAll()
                }
            }
            .listStyle(.plain)
        }
    }
    
    var addedCityList: some View {
        ScrollView {
            ForEach(weatherViewModel.weatherInCities) { weather in
                VStack {
                    HStack {
                        VStack(alignment: .leading, spacing: 10) {
                            Text(cityNameAndTemp(city: weather.geocoding.name, temperature: weather.conditions.last?.condition.temperature))
                            Text(getTime(timeStamp: weather.conditions.last?.date, timezone: weather.conditions.last?.timezone))
                        }
                        Spacer()
                        Button {
                            selectedWeather = weather
                        } label: {
                            Image(systemName: "doc.text.magnifyingglass")
                                .foregroundColor(.accentColor)
                        }
                        .disabled(weather.conditions.count < 1)
                        .opacity(weather.conditions.count > 1 ? 1 : 0)
                    }
                    .padding(.horizontal)
                    Divider()
                        .padding(.leading)
                }
            }
        }
    }
    
    private func cityNameAndTemp(city: String, temperature: Double?) -> String {
        if let unwrappedTemperature = temperature {
            return String("\(city), \(weatherViewModel.temperatureString(temperature: unwrappedTemperature, withSymbol: true))")
        } else {
            return city
        }
    }
    
    private func getTime(timeStamp: Int?, timezone: Int?) -> String {
        if let unwrappedTimeStamp = timeStamp,
           let unwrappedTimezone = timezone {
            return unwrappedTimeStamp.asStringDate(timezone: unwrappedTimezone)
        } else {
            return ""
        }
    }
}

