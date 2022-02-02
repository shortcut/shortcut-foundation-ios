//
//  String+Extension.swift
//  ShortcutFoundation
//
//  Created by Gabriel Sabadin on 2022-08-16.
//  Copyright © 2021 Shortcut Scandinavia Apps AB. All rights reserved.
//

import Foundation

public enum PersonalNumberGender {
    case male
    case female
}

public extension String {
    
    static let empty = ""
    
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
public enum DateFormat {
    case time, day, weekday, month,
         shortMonth, year, dayAndMonth,
         monthAndYear, dayMonthAndYear, weekdayDayMonthYear,
         weekdayDayMonthTime, dayMonthTime, yearMonthDay
}

public extension String {
    static func getDateString(date: Date, format: DateFormat) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = formatString(format: format)
        return formatter.string(from: date)
    }
    
    // swiftlint:disable cyclomatic_complexity
    private static func formatString(format: DateFormat) -> String {
        switch format {
        case .time: return "h:mm a"
        case .day: return "dd"
        case .weekday: return "EEEE"
        case .shortMonth: return "MMM"
        case .month: return "MMMM"
        case .year: return "YYYY"
        case .dayAndMonth: return "dd MMM"
        case .monthAndYear: return "MMM YYYY"
        case .dayMonthAndYear: return "dd MMM YYYY"
        case .yearMonthDay: return "yyyy-MM-dd"
        case .weekdayDayMonthYear: return "EEEE, dd MMM, YYYY"
        case .weekdayDayMonthTime: return "EEEE, dd MMM, h:mm a"
        case .dayMonthTime: return "dd MMM, h:mm a"
        }
    }
}
