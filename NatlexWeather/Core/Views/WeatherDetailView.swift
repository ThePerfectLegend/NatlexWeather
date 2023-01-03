//
//  CityDetailView.swift
//  NatlexWeather
//
//  Created by Nizami Tagiyev on 19.12.2022.
//

import SwiftUI
import Charts

struct WeatherDetailView: View {
        
    var isCelsius: Bool
    @State var weather: WeatherModel
    
    init(isCelsius: Bool, weather: WeatherModel) {
        self.isCelsius = isCelsius
        _weather = State(initialValue: weather)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                ForEach(weather.conditions, id: \.date) { condition in
                    Text(condition.condition.temperature.description)
                }
            }
            .navigationTitle(weather.geocoding.name)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
