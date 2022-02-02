import XCTest
@testable import ShortcutFoundation

struct Code {
    @Versioned var content = ""
}

final class VersionedTests: XCTestCase {

    func test_retrieving_a_valid_version() {
        var sut = Code(content: "First")
        sut.content = "Second"
        sut.content = "Third"

        XCTAssertEqual(sut.$content.history().count, 3)
    }
}
