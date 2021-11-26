//
//  CalendarExtensionTests.swift
//  ShortcutFOundation
//
//  Created by Andreas Lif on 2021-11-25.
//

import Foundation
import XCTest
@testable import ShortcutFoundation

final class CalendarExtensionTests: XCTestCase {
 
    func testStartDateOfWeekYearSuccess() {
        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 1
        let expectedResult = 29
        let date = calendar.firstDayOf(week: 1, year: 2020)!
        let result = calendar.component(.day, from: date)
        XCTAssert(result == expectedResult)
    }
    
    func testStartDateOfWeekYearFailure() {
        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 1
        let expectedResult = 30
        let date = calendar.firstDayOf(week: 1, year: 2020)!
        let result = calendar.component(.day, from: date)
        XCTAssert(result != expectedResult)
    }
    
    func testLastDayOfTheWeekSuccess() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dayInWeek = dateFormatter.date(from: "2021-11-26")
        
        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 1
        let expectedResult = 27
        let lastDay = calendar.lastDayOfWeek(for: dayInWeek!)
        let result = calendar.component(.day, from: lastDay!)
        print(result)
        XCTAssert(result == expectedResult)
    }
    
    func testLastDayOfTheWeekFailure() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dayInWeek = dateFormatter.date(from: "2021-11-26")
        
        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 1
        let expectedResult = 26
        let lastDay = calendar.lastDayOfWeek(for: dayInWeek!)
        let result = calendar.component(.day, from: lastDay!)
        print(result)
        XCTAssert(result != expectedResult)
    }
    
}
