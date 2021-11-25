//
//  Calendar+Extension.swift
//  ShortcutFoundation
//
//  Created by Andreas Lif on 2021-11-24.
//

import Foundation

public extension Calendar {
    
    func startDateOf(weekNumber: Int, year: Int) -> Date? {
        let components = DateComponents(weekOfYear: weekNumber, yearForWeekOfYear: year)
        let firstDay = self.date(from: components)
        return firstDay
    }
    
    func lastDayOfWeek(for firstDayOfWeek: Date) -> Date {
        return Calendar.current.date(byAdding: DateComponents(day: 6), to: firstDayOfWeek) ?? firstDayOfWeek
    }
    
    func currentYearForWeekOfYear() -> Int {
        return Calendar.current.component(.yearForWeekOfYear, from: Date())
    }
    
    func currentWeek() -> Int {
        return Calendar.current.component(.weekOfYear, from: Date())
    }
    
    func weekNumber(from date: Date) -> Int {
        return Calendar.current.component(.weekOfYear, from: date)
    }
    
    func yearForWeekOfYear(from date: Date) -> Int {
        return Calendar.current.component(.yearForWeekOfYear, from: date)
    }
    
}
