import XCTest
@testable import ShortcutFoundation

struct KeychainTestData: Codable, Equatable {
    var name = "Kalle"
    var createdAt = Date()
}

final class KeychainTests: XCTestCase {
    @Keychain(service: "test-string") private var stringSUT: String?
    @Keychain(service: "test-codable") private var codableSUT: KeychainTestData?
    
    func test_saving_reading_and_deleting_string() {
        let expectedValue = "new value"
        stringSUT = expectedValue
        
        XCTAssertNotNil(stringSUT)
        XCTAssertEqual(stringSUT, expectedValue)
        
        stringSUT = nil
        XCTAssertNil(stringSUT)
    }
    
    func test_saving_reading_and_deleting_codable() {
        let expectedValue = KeychainTestData(name: "Gabriel", createdAt: .now)
        codableSUT = expectedValue
        
        XCTAssertNotNil(codableSUT)
        XCTAssertEqual(codableSUT, expectedValue)
        
        codableSUT = nil
        XCTAssertNil(codableSUT)
    }
}
