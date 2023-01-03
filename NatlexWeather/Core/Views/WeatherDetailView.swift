//
//  CityDetailView.swift
//  NatlexWeather
//
//  Created by Nizami Tagiyev on 19.12.2022.
//

import SwiftUI
import Charts

struct WeatherDetailView: View {
    
    @ObservedObject var vm: WeatherDetailViewModel
    
    init(isCelsius: Bool, weather: WeatherModel) {
        self.vm = WeatherDetailViewModel(weather: weather, isCelsius: isCelsius)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                Chart(vm.weatherConditions) { condition in
                    PointMark (
                        x: .value("Date", condition.date, unit: .day),
                        y: .value("Temperature", condition.temperature)
                    )
                    LineMark(
                        x: .value("Date", condition.date, unit: .day),
                        y: .value("Temperature", condition.temperature)
                    )
                    .interpolationMethod(.catmullRom)
                }
                .frame(height: 250)
                HStack {
                    Text("Min Temp: \(vm.weatherConditions.last?.minTemperature.description ?? "")")
                    Spacer()
                    Text("Max Temp: \(vm.weatherConditions.last?.maxTemperature.description ?? "")")
                }
                .padding(.horizontal)
            }
            .navigationTitle(vm.weather.geocoding.name)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
