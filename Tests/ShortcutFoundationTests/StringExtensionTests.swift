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
}
