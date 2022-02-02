//
//  Sequence+IndexedArray.swift
//  ShortcutFoundation
//
//  Created by Gabriel Sabadin on 2021-08-16.
//  Copyright © 2021 Shortcut Scandinavia Apps AB. All rights reserved.
//

import Foundation

// Use this to get an indexed array that is usable in a SwiftUI ForEach loop
public extension Sequence where Element: Hashable {
    func indexedArray() -> [IndexedObject<Element>] {
        return self.enumerated().map {
            return IndexedObject(element: $0.element, index: $0.offset, position: ListPosition.createSet(sequence: Array(self), index: $0.offset))
        }
    }
}

public struct IndexedObject<Element>: Hashable where Element: Hashable {
    public let element: Element
    public let index: Int
    public let position: Set<ListPosition>
}

public extension Set where Element == ListPosition {
    var isFirst: Bool {
        self.contains(.first)
    }
    var isLast: Bool {
        self.contains(.last)
    }
}

public enum ListPosition: Int, Hashable {
    case first
    case middle
    case last

    static func createSet<T>(sequence: [T], index: Int) -> Set<ListPosition> {

        var set = Set<ListPosition>()
        if index == 0 {
            set.insert(.first)
        }
        if index == sequence.endIndex - 1 {
            set.insert(.last)
        }

        if set.isEmpty {
            set.insert(.middle)
        }

        return set
    }
}
