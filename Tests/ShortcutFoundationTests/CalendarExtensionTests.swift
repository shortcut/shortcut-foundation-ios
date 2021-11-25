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
        let date = calendar.startDateOf(weekNumber: 1, year: 2020)!
        let result = calendar.component(.day, from: date)
        XCTAssert(result == expectedResult)
    }
    
    func testStartDateOfWeekYearFailure() {
        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 1
        let expectedResult = 30
        let date = calendar.startDateOf(weekNumber: 1, year: 2020)!
        let result = calendar.component(.day, from: date)
        XCTAssert(result != expectedResult)
    }
    
}
