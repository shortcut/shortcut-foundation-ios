import Foundation

public extension Locale {
    static var currentLanguageCode: String {
        let localeID = Locale.preferredLanguages.first ?? ""
        let languageCode = Locale(identifier: localeID).languageCode
        // Locale.current.languageCode (is returning "en")
        return languageCode ?? "en"
    }
}
