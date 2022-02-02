import XCTest
@testable import ShortcutFoundation

final class ArrayTests: XCTestCase {
    func test_differences_between_two_arrays() {
        let firstArray = [1, 2, 3]
        let secondArray = [1, 3]
        let expectation = [2]
        
        XCTAssertEqual(firstArray.difference(secondArray), expectation)
    }
    
    func test_array_are_equal() {
        let firstArray = [1, 2, 3]
        let secondArray = [1, 2, 3]
        
        XCTAssertTrue(firstArray.elementsEqual(secondArray))
    }

    func test_array_of_doubles_are_equal() {
        let firstArray: [[Double]] = [[1.0, 2.0, 3.0], [3.0, 2.0, 1.0]]
        let secondArray: [[Double]] = [[1.0, 2.0, 3.0], [3.0, 2.0, 1.0]]
        
        XCTAssertTrue(firstArray.elementsEqual(secondArray))
    }

    func test_array_are_equal_ignoring_the_order() {
        let firstArray = [1, 2, 3]
        let secondArray = [1, 3, 2]
        
        XCTAssertTrue(firstArray.elementsEqual(secondArray, ignoreOrder: true))
    }

    func test_array_of_doubles_are_equal_ignoring_the_order() {
        let firstArray: [[Double]] = [[1.0, 2.0, 3.0], [3.0, 2.0, 1.0]]
        let secondArray: [[Double]] = [[3.0, 2.0, 1.0], [1.0, 2.0, 3.0]]

        XCTAssertTrue(firstArray.elementsEqual(secondArray, ignoreOrder: true))
    }
}
