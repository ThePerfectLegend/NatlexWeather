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
            VStack {
                Chart(vm.showConditions) { condition in
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
                    Text("Min Temp: \(vm.showConditions.last?.minTemperature.description ?? "")")
                    Spacer()
                    Text("Max Temp: \(vm.showConditions.last?.maxTemperature.description ?? "")")
                }
                .padding(.horizontal)
                List {
                    DatePicker(selection: $vm.dateFrom, in: vm.dateRange, displayedComponents: .date) {
                        Text("From")
                    }
                    DatePicker(selection: $vm.dateTo, in: vm.dateRange, displayedComponents: .date) {
                        Text("To")
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle(vm.weather.geocoding.name)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
