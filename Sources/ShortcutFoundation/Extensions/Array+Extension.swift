import Foundation

public extension Array where Element: Identifiable {
    func find(_ id: Element.ID) -> Element? {
        self.first { $0.id == id }
    }

    func findIndex(_ id: Element.ID) -> Int? {
        self.firstIndex { $0.id == id }
    }

    mutating func remove(_ id: Element.ID) {
        self.removeAll { $0.id == id }
    }
}

public extension Array where Element: Hashable {
    @inlinable func difference(_ other: [Element]) -> [Element] {
        let thisSet = Set(self)
        let otherSet = Set(other)
        return Array(thisSet.symmetricDifference(otherSet))
    }

    @inlinable func elementsEqual(_ other: [Element],
                                  ignoreOrder: Bool) -> Bool {
        if ignoreOrder {
            return self.difference(other).isEmpty
        } else {
            return self.elementsEqual(other)
        }
    }
}
