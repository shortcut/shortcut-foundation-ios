import Foundation

public protocol HttpBodyConvertible {
    func buildHttpBodyPart(boundary: String) -> Data
}
