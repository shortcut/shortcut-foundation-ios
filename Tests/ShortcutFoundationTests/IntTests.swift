//
//  IntTests.swift
//  ShortcutFoundation
//
//  Created by Andreas Lif on 2022-01-12.
//  Copyright © 2021 Shortcut Scandinavia Apps AB. All rights reserved.
//

import Foundation
import XCTest
@testable import ShortcutFoundation

final class IntTests: XCTestCase {
    
    func test_odd_ints() {
        let odds = [1, 23, 405, 6897]
        odds.forEach {
            XCTAssert($0.isOdd)
            XCTAssert(!$0.isEven)
        }
    }
    
    func test_even_ints() {
        let evens = [0, 2, 14, 376, 5908]
        evens.forEach {
            XCTAssert($0.isEven)
            XCTAssert(!$0.isOdd)
        }
    }
    
}
