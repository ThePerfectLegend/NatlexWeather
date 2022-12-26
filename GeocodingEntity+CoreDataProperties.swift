//
//  GeocodingEntity+CoreDataProperties.swift
//  NatlexWeather
//
//  Created by Nizami Tagiyev on 23.12.2022.
//
//

import Foundation
import CoreData


extension GeocodingEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GeocodingEntity> {
        return NSFetchRequest<GeocodingEntity>(entityName: "GeocodingEntity")
    }

    @NSManaged public var country: String?
    @NSManaged public var lat: Double
    @NSManaged public var lon: Double
    @NSManaged public var name: String?
    @NSManaged public var state: String?
    @NSManaged public var weatherEntity: WeatherEntity?

}

extension GeocodingEntity : Identifiable {

}
