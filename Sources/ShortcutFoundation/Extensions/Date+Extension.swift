//
//  Date+Extension.swift
//  ShortcutFoundation
//
//  Created by Gabriel Sabadin on 2021-08-16.
//  Copyright © 2021 Shortcut Scandinavia Apps AB. All rights reserved.
//

import Foundation

public extension Date {
    var isFuture: Bool { self > Date() }
    var isPast: Bool { !isFuture }

    var isToday: Bool { Calendar.current.isDateInToday(self) }
    var wasYesterday: Bool { Calendar.current.isDateInYesterday(self) }
    var isTomorrow: Bool { Calendar.current.isDateInTomorrow(self) }
    var isThisHour: Bool { Calendar.current.isDate(self, equalTo: Date(), toGranularity: .hour) }
    var isFutureDay: Bool { isFuture && !isToday }
    var isPastDay: Bool { isPast && !isToday }

    static func convertToDate(inputDate: String, format: DateFormat = .yearMonthDay) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = String.formatString(format: format)
        let formattedDate = formatter.date(from: inputDate)
        return formattedDate ?? Date()
    }

    static func fromString(_ date: String, format: String = "YYYYMMdd") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: date)
    }

    var daysInMonth: Int {
       let calendar = Calendar.current

       let dateComponents = DateComponents(year: calendar.component(.year, from: self),
                                           month: calendar.component(.month, from: self))
       let date = calendar.date(from: dateComponents)!

       let range = calendar.range(of: .day, in: .month, for: date)!
       let numDays = range.count

       return numDays
    }

    func toArgumentString(format: String = "YYYY.MM.dd HH:mm") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }

    static func yearFromString(_ date: String, format: String = "YYYYMMdd") -> Int {
        let invalid = 0
        guard let date = fromString(date) else {
            return invalid
        }

        let components = Calendar.current.dateComponents([.day, .month, .year], from: date, to: Date())

        guard let year = components.year else {
            return invalid
        }

        return year
    }

    func hasPassed(seconds: Int) -> Bool {
        let currentTime = Date()
        guard let ellapsedTime = Calendar.current.dateComponents([.second], from: self, to: currentTime).second else { return false }

        return ellapsedTime > seconds
    }

    func hasPassed(minutes: Int) -> Bool {
        let currentTime = Date()
        guard let ellapsedTime = Calendar.current.dateComponents([.minute], from: self, to: currentTime).minute else { return false }

        return ellapsedTime > minutes
    }

    func hasPassed(hours: Int) -> Bool {
        let currentTime = Date()
        guard let ellapsedTime = Calendar.current.dateComponents([.hour], from: self, to: currentTime).hour else { return false }

        return ellapsedTime > hours
    }

    func hasPassed(days: Int) -> Bool {
        let currentTime = Date()
        guard let ellapsedTime = Calendar.current.dateComponents([.day], from: self, to: currentTime).day else { return false }

        return ellapsedTime > days
    }

    func isEqual(to date: Date, toGranularity component: Calendar.Component, in calendar: Calendar = .current) -> Bool {
        calendar.isDate(self, equalTo: date, toGranularity: component)
    }

    func isInCurrentMonth() -> Bool { isEqual(to: Date(), toGranularity: .month) }
    func isInLastMonth() -> Bool {
        guard let previousMonth = Calendar.current.date(byAdding: DateComponents(month: -1), to: Date()) else {
            return false
        }
        return Calendar.current.isDate(self, equalTo: previousMonth, toGranularity: .month)
    }

    func isInCurrentOrLastMonth() -> Bool {
        self.isInCurrentMonth() || self.isInLastMonth()
    }

    func startDateOfMonth() -> Date {
        Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }

    func endDateOfMonth() -> Date {
        Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startDateOfMonth())!
    }
}
