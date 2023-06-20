import Foundation

extension Date {
    static var nineteenthAugust2021: Date {
        let time: UInt64 = 1629346343143
        return Date(timeIntervalSince1970: TimeInterval(time/1000))
    }
}
