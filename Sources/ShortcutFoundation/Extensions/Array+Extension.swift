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
