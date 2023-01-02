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
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    getLocationButton
                        .disabled(weatherViewModel.isLoadingCurrentLocation)
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Image(systemName: "house")
                        .onTapGesture {
                            print(weatherViewModel.weatherService.weatherConditions)
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
        List(weatherViewModel.weatherInCities) { city in
            VStack(alignment: .leading) {
                Text(city.geocoding.name)
                ForEach(city.conditions) { condition in
                    Text(condition.condition.temperature.description)
                }
            }
        }
        .listStyle(.plain)
    }
    
}
