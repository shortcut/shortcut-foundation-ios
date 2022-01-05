//
//  CollectionExtensionTests.swift
//  ShortcutFoundation
//
//  Created by Andreas Lif on 2021-11-15.
//

import XCTest
@testable import ShortcutFoundation

final class CollectionExtensionTests: XCTestCase {
    func test_safe_array_indexing_success() {
        let array = [1, 2, 3, 4]
        let indexOfNumberTwo = 1
        guard let numberTwo = array[safe: indexOfNumberTwo] else {
            XCTFail()
            return
        }
        XCTAssert(numberTwo == array[indexOfNumberTwo])
    }
    
    func test_safe_array_indexing_failure() {
        let array = [1, 2, 3, 4]
        let indexOutOfRange = 5
        guard let _ = array[safe: indexOutOfRange] else { return }
        XCTFail()
    }
}
