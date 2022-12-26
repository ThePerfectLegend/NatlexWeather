//
//  CityModel.swift
//  NatlexWeather
//
//  Created by Nizami Tagiyev on 20.12.2022.
//

import Foundation

struct GeocodingResponseModel: Codable, Hashable {
    let name: String
    let lat, lon: Double
    let country: String
    let state: String?
}

extension GeocodingResponseModel {
    init(_ entity: GeocodingEntity) {
        self.name = entity.name ?? ""
        self.lat = entity.lat
        self.lon = entity.lon
        self.country = entity.country ?? ""
        self.state = entity.state
    }
}
