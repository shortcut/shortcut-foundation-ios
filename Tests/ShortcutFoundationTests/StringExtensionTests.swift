import XCTest
@testable import ShortcutFoundation

final class StringExtensionTests: XCTestCase {
    func test_age_from_personal_number() {
        let sut = "198504230000"
        let age = sut.ageFromPersonalNumber
        // in 2021
        let expectedAge = 36
        XCTAssertEqual(age, expectedAge)
    }
    
    func test_negative_futute_age_from_personal_number() {
        let sut = "198512230000"
        let age = sut.ageFromPersonalNumber
        // in December 2021
        let expectedAge = 35
        XCTAssertEqual(age, expectedAge)
    }
    
    func test_male_gender_by_personal_number() {
        let sut = "198504231171"
        let gender = sut.genderFromPersonalNumber
        let expectedGender: PersonalNumberGender = .male
        XCTAssertEqual(gender, expectedGender)
    }
    
    func test_female_gender_by_personal_number() {
        let sut = "197911201141"
        let gender = sut.genderFromPersonalNumber
        let expectedGender: PersonalNumberGender = .female
        XCTAssertEqual(gender, expectedGender)
    }
    
    func test_Day() {
        let expectedDay = "19"
        let day = String.getDateString(date: .nineteenthAugust2021, format: .day)
        XCTAssertEqual(day, expectedDay)
    }
    
    func test_month() {
        let expectedMonth = "Aug"
        let month = String.getDateString(date: .nineteenthAugust2021, format: .month)
        XCTAssertEqual(month, expectedMonth)
    }
    
    func test_year() {
        let expectedYear = "2021"
        let year = String.getDateString(date: .nineteenthAugust2021, format: .year)
        XCTAssertEqual(year, expectedYear)
    }
    
    func test_day_and_month() {
        let expectedDayAndMonth = "19 Aug"
        let dayAndMonth = String.getDateString(date: .nineteenthAugust2021, format: .dayAndMonth)
        XCTAssertEqual(dayAndMonth, expectedDayAndMonth)
    }
    
    func test_month_and_year() {
        let expectedMonthAndYear = "Aug 2021"
        let monthAndYear = String.getDateString(date: .nineteenthAugust2021, format: .monthAndYear)
        XCTAssertEqual(monthAndYear, expectedMonthAndYear)
    }
    
    func test_day_month_and_year() {
        let expectedDayMonthYear = "19 Aug 2021"
        let dayMonthAndYear = String.getDateString(date: .nineteenthAugust2021, format: .dayMonthAndYear)
        XCTAssertEqual(dayMonthAndYear, expectedDayMonthYear)
    }
}
