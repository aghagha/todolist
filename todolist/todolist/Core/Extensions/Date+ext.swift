//
//  Date+ext.swift
//  todolist
//
//  Created by Agha Maulana on 06/08/24.
//

import Foundation

public extension Date {
    static func localDate() -> Date {
        return Date().toLocalDate()
    }
    
    func setTime(hour: Int, minute: Int) -> Date {
        return Calendar.current.date(bySettingHour: hour, minute: minute, second: 0, of: self) ?? Date()
    }
    
    var timeFormatted: String {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.locale = .init(identifier: "en_US_POSSIX")
        formatter.timeZone = Calendar.current.timeZone
        return formatter.string(from: self)
    }
    
    func toLocalDate() -> Date {
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
}
