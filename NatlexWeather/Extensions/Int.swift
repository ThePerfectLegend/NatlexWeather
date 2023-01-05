//
//  Int.swift
//  NatlexWeather
//
//  Created by Nizami Tagiyev on 03.01.2023.
//

import Foundation

extension Int {
    func asDate() -> Date {
        let timeInterval = TimeInterval(self)
        return Date(timeIntervalSince1970: timeInterval)
    }
    
    func asStringDate(timezone: Int) -> String {
        let currentTimezoneOffset = Calendar.current.timeZone.secondsFromGMT()
        let timeInterval = TimeInterval(self + (timezone - currentTimezoneOffset))
        let date = Date(timeIntervalSince1970: timeInterval)
        
        var displayDate: String {
            date.formatted(.dateTime
                .year(.defaultDigits)
                .month(.twoDigits)
                .day(.twoDigits)
            )
        }
        var displayTime: String {
            date.formatted(.dateTime
                .hour(.twoDigits(amPM: .omitted))
                .minute(.twoDigits)
                .second(.twoDigits)
            )
        }
        return String("\(displayDate) \(displayTime)")
    }
}
