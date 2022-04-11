//
//  Encodable+HttpBodyConvertible.swift
//  ShortcutFoundation
//
//  Created by Gabriel Sabadin, Karl Söderberg on 2021-08-16.
//  Copyright © 2021 Shortcut Scandinavia Apps AB. All rights reserved.
//

import Foundation

extension Encodable {
    func toParams(using encoder: JSONEncoder) throws -> [String: CustomStringConvertible] {

        do {
            guard let params = try toParamsRaw(using: encoder) as? [String: CustomStringConvertible] else {
                throw NetworkingError(status: .unableToParseRequest)
            }
            return params

        } catch {
            throw NetworkingError(error: error, status: .unableToParseRequest)
        }
    }

    private func toParamsRaw(using encoder: JSONEncoder) throws -> Any {
        let data = try encoder.encode(self)
        return try JSONSerialization.jsonObject(with: data, options: [])
    }
    
    func toDictionary(using encoder: JSONEncoder) throws -> [String: Any]? {
        let data = try encoder.encode(self)
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] else { return nil }
        return json
    }
}

extension Dictionary: HttpBodyConvertible where Key == String, Value == CustomStringConvertible {
    public func buildHttpBodyPart(boundary: String) -> Data {
        let httpBody = NSMutableData()
        forEach { (name, value) in
            httpBody.appendString("--\(boundary)\r\n")
            httpBody.appendString("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n")
            httpBody.appendString(value.description)
            httpBody.appendString("\r\n")
        }
        return httpBody as Data
    }
}

