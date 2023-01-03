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
}

extension Optional where Wrapped == Int {
    func asStringDate() -> String {
        switch self {
        case .none:
            return ""
        case .some(let unwrappedInt):
            let timeInterval = TimeInterval(unwrappedInt)
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
}
