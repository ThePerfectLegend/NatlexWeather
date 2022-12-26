//
//  WeatherEntity+CoreDataProperties.swift
//  NatlexWeather
//
//  Created by Nizami Tagiyev on 23.12.2022.
//
//

import Foundation
import CoreData


extension WeatherEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WeatherEntity> {
        return NSFetchRequest<WeatherEntity>(entityName: "WeatherEntity")
    }

    @NSManaged public var id: String?
    @NSManaged public var geocodingEntity: GeocodingEntity?

}

extension WeatherEntity : Identifiable {

}
