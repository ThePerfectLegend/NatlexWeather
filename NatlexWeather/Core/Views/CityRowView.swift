//
//  CityRowView.swift
//  NatlexWeather
//
//  Created by Nizami Tagiyev on 19.12.2022.
//

import SwiftUI

struct CityRowView: View {
    
    @EnvironmentObject private var weatherViewModel: WeatherViewModel
    let city: WeatherModel
        
    var body: some View {
        VStack {
            Text(city.geocoding.name)
        }
    }
}
