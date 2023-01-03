//
//  CurrentWeatherView.swift
//  NatlexWeather
//
//  Created by Nizami Tagiyev on 19.12.2022.
//

import SwiftUI

struct CurrentWeatherView: View {

    @EnvironmentObject private var weatherViewModel: WeatherViewModel
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack(alignment: .leading, spacing: 12) {
                currentCityName
                HStack {
                    currentCityTemp
                    Spacer()
                    fahrenheitToggle
                }
            }
            .padding()
        }
        .background(backgroundColor().gradient)
    }
}


extension CurrentWeatherView {
    func backgroundColor() -> Color {
        if let unwrappedTemp = weatherViewModel.currentWeather?.condition.temperature.asCelsius() {
            if unwrappedTemp < 10 {
                return .cyan.opacity(0.9)
            } else if unwrappedTemp > 25 {
                return .red
            } else {
                return .orange
            }
        } else {
            return .secondary.opacity(0.5)
        }
    }
    
    var currentCityName: some View {
        Text(weatherViewModel.currentWeather?.name ?? "Placeholder")
            .font(.largeTitle.weight(.medium))
            .opacity(weatherViewModel.currentWeather?.name == nil ? 0 : 1)
    }
    
    var currentCityTemp: some View {
        Text(weatherViewModel.temperatureString(temperature: weatherViewModel.currentWeather?.condition.temperature, withSymbol: false))
            .font(.title2.weight(.medium))
            .opacity(weatherViewModel.currentWeather?.condition.temperature == nil ? 0 : 1)
    }
        
    var fahrenheitToggle: some View {
        HStack {
            Text("F")
            Toggle("", isOn: $weatherViewModel.isCelsius)
                .labelsHidden()
            Text("C")
        }
        .font(.title2.weight(.medium))
    }
}
