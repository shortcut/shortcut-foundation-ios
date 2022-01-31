//
//  Params+HttpBodyConvertible.swift
//  ShortcutFoundation
//
//  Created by Gabriel Sabadin, Karl Söderberg on 2021-08-16.
//  Copyright © 2021 Shortcut Scandinavia Apps AB. All rights reserved.
//

import Foundation

enum ParamsEncodingError: Error {
    case failedToDecodeParams
}

extension Encodable {
    
    func toParams(using encoder: JSONEncoder) throws -> [String: CustomStringConvertible] {
        guard let params = try toParamsRaw(using: encoder) as? [String: CustomStringConvertible] else {
            throw ParamsEncodingError.failedToDecodeParams
        }
        return params
    }
    
    private func toParamsRaw(using encoder: JSONEncoder) throws -> Any {
        let data = try encoder.encode(self)
        return try JSONSerialization.jsonObject(with: data, options: [])
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
