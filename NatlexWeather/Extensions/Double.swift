//
//  Double.swift
//  NatlexWeather
//
//  Created by Nizami Tagiyev on 19.12.2022.
//

import Foundation

extension Double {
    func asFahrenheit() -> Double {
        Double(((self - 273.5) * 9.5) + 32).rounded(toPlaces: 0)
    }
    
    func asCelsius() -> Double {
        Double(self - 273.5).rounded(toPlaces: 0)
    }
    
    func asFahrenheitString() -> String {
        String(format: "%0.f", self.asFahrenheit()) + "°F"
        
    }
    
    func asCelsiusString() -> String {
        String(format: "%0.f", self.asCelsius()) + "°C"
    }
    
    func asDegreeString() -> String {
        String(format: "%0.f", self) + "°"
    }
    
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        let value = (self * divisor).rounded() / divisor
        if value == -0 {
            return 0
        } else {
            return value
        }
    }
}
