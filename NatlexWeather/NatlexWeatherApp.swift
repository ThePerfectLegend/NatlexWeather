//
//  NatlexWeatherApp.swift
//  NatlexWeather
//
//  Created by Nizami Tagiyev on 19.12.2022.
//

import SwiftUI

@main
struct NatlexWeatherApp: App {
    @StateObject var weatherViewModel = WeatherViewModel()
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(weatherViewModel)
        }
    }
}
