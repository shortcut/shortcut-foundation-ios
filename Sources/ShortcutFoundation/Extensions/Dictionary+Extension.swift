import Foundation

public extension Dictionary {
    func has(_ key: Key) -> Bool {
        return index(forKey: key) != nil
    }
}
