//
//  UrlEncoder.swift
//  
//
//  Created by Hripsime on 2022-04-07.
//

import Foundation

public class UrlEncoder {
    public static func query(parameters: [String: Any], isFormData: Bool = false) -> String {
        var components: [(String, String)] = []

        for key in parameters.keys.sorted(by: <) {
            let value = parameters[key]!
            components += queryComponents(key, value, isFormData: isFormData)
        }

        return (components.map { "\($0)=\($1)" } as [String]).joined(separator: "&")
    }

    /**
     Creates percent-escaped, URL encoded query string components from the given key-value pair using recursion.

     - parameter key:   The key of the query component.
     - parameter value: The value of the query component.

     - returns: The percent-escaped, URL encoded query string components.
     */
    static func queryComponents(_ key: String, _ value: Any, isFormData: Bool = false) -> [(String, String)] {
        var components: [(String, String)] = []

        if let dictionary = value as? [String: Any] {
            for (nestedKey, value) in dictionary {
                components += queryComponents("\(key)[\(nestedKey)]", value)
            }
        } else if let array = value as? [Any] {
            for value in array {
                components += queryComponents("\(key)[]", value)
            }
        } else {
            components.append((escape(string: key), escape(string: "\(value)", plusForSpace: isFormData)))
        }

        return components
    }

    /**
     Returns a percent-escaped string following RFC 3986 for a query string key or value.

     RFC 3986 states that the following characters are "reserved" characters:

     - General Delimiters:
                            # : [ ] @ ? /
     - Sub-Delimiters:
                            ! $ & ' ( ) * + , ; =

     RFC 3986 - Section 3.4 states that the "?" and "/" characters should not be escaped to allow
     query strings to include a URL. Therefore, all "reserved" characters with the exception of "?" and "/"
     should be percent-escaped in the query string.

     - parameter string: The string to be percent-escaped.
     - parameter plusForSpace: if true, space character will be replaced by '+' (also, ';' will be escaped)
     - returns: The percent-escaped string.
     */

    static func escape(string: String, plusForSpace: Bool = false) -> String {
        var allowedCharacters = CharacterSet(charactersIn: " =\"#%/<>?@\\^`{}[]|&+").inverted

        if plusForSpace {
            allowedCharacters = allowedCharacters
                .union(CharacterSet(charactersIn: " "))
                .subtracting(CharacterSet(charactersIn: ";"))
        }

        var encoded = string.addingPercentEncoding(withAllowedCharacters: allowedCharacters)
        if plusForSpace {
            encoded = encoded?.replacingOccurrences(of: " ", with: "+")
        }

        return encoded ?? string
    }
}
