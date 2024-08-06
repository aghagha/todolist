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
    
    func getFutureDay(amount: Int) -> Date {
        var dateComponent: DateComponents = DateComponents()
        dateComponent.day = amount
        return Calendar.current.date(byAdding: dateComponent, to: self) ?? self
    }
    
    func setTime(hour: Int, minute: Int) -> Date {
        return Calendar.current.date(bySettingHour: hour, minute: minute, second: 0, of: self) ?? Date()
    }
    
    var formattedDateForDisplay: String {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "(dd MMMM yyyy)"
        formatter.locale = .init(identifier: "en_US_POSSIX")
        formatter.timeZone = Calendar.current.timeZone
        var formattedDate: String = formatter.string(from: self)
        if Calendar.current.isDateInToday(self) {
            formattedDate = "Today " + formattedDate
        } else if Calendar.current.isDateInTomorrow(self) {
            formattedDate = "Tomorrow " + formattedDate
        } else {
            formatter.dateFormat = "EE"
            formattedDate = formatter.string(from: self) + " " + formattedDate
        }
        
        return formattedDate
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
