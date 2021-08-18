import Foundation

public enum PersonalNumberGender {
    case male
    case female
}

public extension String {
    static var buildString: String {
        let version = Bundle.main.releaseVersionNumber ?? ""
        let build = Bundle.main.buildVersionNumber ?? ""

        return "\(version) (\(build))"
    }

    // swiftlint:disable identifier_name
    static var firebaseFilePath_PRODUCTION: String? {
        return Bundle.main.path(forResource: "GoogleService-Info", ofType: ".plist")
    }

    // swiftlint:disable identifier_name
    static var firebaseFilePath_DEVELOPMENT: String? {
        return Bundle.main.path(forResource: "DEVELOPMENT-GoogleService-Info", ofType: ".plist")
    }

    var ageFromPersonalNumber: Int {
        let date = self.prefix(8).description
        return Date.yearFromString(date)
    }

    var genderFromPersonalNumber: PersonalNumberGender {
        let penultimatePersonalNumberDigit = Int(self.suffix(2).dropLast()) ?? 0 // default odd (female)
        return penultimatePersonalNumberDigit.isMultiple(of: 2) ? .female : .male
    }

    func isValidPhoneNumber() -> Bool {
        let phoneRegex = "^[0-9+]{0,1}+[0-9]{5,16}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: self)
    }

    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
}

// String + Date
public extension String {
    enum DateFormat {
        case day, month, year, dayAndMonth, monthAndYear
    }
    
    static func getDateString(date: Date, format: DateFormat) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = formatString(format: format)
        return formatter.string(from: date)
    }
    
    private static func formatString(format: DateFormat) -> String {
        switch format {
        case .day:
            return "dd"
        case .month:
            return "MMM"
        case .year:
            return "YYYY"
        case .dayAndMonth:
            return "dd MMM"
        case .monthAndYear:
            return "MMM YYYY"
        }
    }
}
