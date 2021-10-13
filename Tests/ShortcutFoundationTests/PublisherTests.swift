import XCTest
@testable import ShortcutFoundation

final class PublisherTests: XCTestCase {
    func test_publisher_receives_proper_string_value() {
        let sut = makeSUT(String.self)
        let expectedValue = "Shortcut"
        let expectation = XCTestExpectation(description: "expect a valid String value")
        
        sut.listen(value: { value in
            XCTAssertEqual(value, expectedValue)
            expectation.fulfill()
        })
        
        sut.listen(error: { error in
            XCTFail("should not have received an error")
        })
        
        sut.send(expectedValue)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_publisher_receives_proper_int_value() {
        let sut = makeSUT(Int.self)
        let expectedValue = 2112
        let expectation = XCTestExpectation(description: "expect a valid Int value")
        
        sut.listen(value: { value in
            XCTAssertEqual(value, expectedValue)
            expectation.fulfill()
        })
        
        sut.listen(error: { error in
            XCTFail("should not have received an error")
        })
        
        sut.send(expectedValue)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_publisher_receives_proper_error() {
        let sut = makeSUT(Int.self)
        let expectation = XCTestExpectation(description: "expect a valid error")
        
        sut.listen(value: { value in
            XCTFail("should not have received a value")
        })
        
        sut.listen(error: { _ in
            expectation.fulfill()
        })
        
        sut.send(error: .network)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    // MARK: Private helpers
    
    private func makeSUT<T>(_ type: T.Type) -> Publisher<T> {
        return Publisher<T>()
    }
}
