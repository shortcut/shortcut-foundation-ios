//
//  Calendar+Extension.swift
//  ShortcutFoundation
//
//  Created by Andreas Lif on 2021-11-24.
//

import Foundation

public extension Calendar {
    
    func firstDayOf(week: Int, year: Int) -> Date? {
        let components = DateComponents(weekOfYear: week, yearForWeekOfYear: year)
        let firstDay = self.date(from: components)
        return firstDay
    }
    
    func lastDayOfWeek(for date: Date) -> Date? {
        let week = self.week(from: date)
        let year = self.yearForWeekOfYear(from: date)
        guard let firstDayOfWeek = self.firstDayOf(week: week, year: year) else { return nil }
        return self.date(byAdding: DateComponents(day: 6), to: firstDayOfWeek)
    }
    
    func currentYearForWeekOfYear() -> Int {
        return self.component(.yearForWeekOfYear, from: Date())
    }
    
    func currentWeek() -> Int {
        return self.component(.weekOfYear, from: Date())
    }
    
    func week(from date: Date) -> Int {
        return self.component(.weekOfYear, from: date)
    }
    
    func yearForWeekOfYear(from date: Date) -> Int {
        return Calendar.current.component(.yearForWeekOfYear, from: date)
    }
    
}
