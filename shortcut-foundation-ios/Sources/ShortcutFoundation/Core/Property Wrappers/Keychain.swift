//
//  Keychain.swift
//  ShortcutFoundation
//
//  Created by Gabriel Sabadin on 2021-09-13.
//  Copyright © 2021 Shortcut Scandinavia Apps AB. All rights reserved.
//

import Foundation
import Security

// MARK: Error

enum KeychainError: Error {
    case nonSupportedData
}

@propertyWrapper
public struct Keychain<T: Codable,
                       Encoder: KeychainEncoder,
                       Decoder: KeychainDecoder> where Encoder.Output == Data, Decoder.Input == Data {
    private let securityClass = kSecClassGenericPassword

    public let service: String

    public var wrappedValue: T? {
        didSet {
            store(wrappedValue)
        }
    }

    private let encoder: Encoder
    private let decoder: Decoder

    public init(service: String,
                encoder: Encoder,
                decoder: Decoder) {
        self.service = service
        self.encoder = encoder
        self.decoder = decoder

        self.wrappedValue = load()
    }

    private var searchQuery: [String: Any] {
        [
            kSecClass as String: securityClass,
            kSecAttrService as String: service
        ]
    }

    private func load() -> T? {
        var searchQuery = self.searchQuery
        searchQuery[kSecReturnAttributes as String] = true
        searchQuery[kSecReturnData as String] = true

        var unknownItem: CFTypeRef?
        let status = SecItemCopyMatching(searchQuery as CFDictionary, &unknownItem)

        guard status != errSecItemNotFound else {
            return nil
        }

        guard status == errSecSuccess else {
            return nil
        }

        guard let item = unknownItem as? [String: Any], let data = item[kSecValueData as String] as? Data else {
            return nil
        }

        return decode(from: data)
    }

    private func decode(from data: Data) -> T? {
        if T.self == String.self {
            return String(data: data, encoding: .utf8) as? T? ?? nil
        } else {
            do {
                return try self.decoder.decode(T.self, from: data)
            } catch {
                return nil
            }
        }
    }

    private func store(_ value: T?) {
        guard let encoded = encode(value) else {
            delete()
            return
        }

        let attributes: [String: Any] = [
            kSecValueData as String: encoded
        ]

        var status = SecItemUpdate(
            searchQuery as CFDictionary,
            attributes as CFDictionary
        )

        if status == errSecItemNotFound {
            let addQuery = searchQuery.merging(attributes, uniquingKeysWith: { (_, new) in new })
            status = SecItemAdd(addQuery as CFDictionary, nil)
        }

        guard status == errSecSuccess else {
            return
        }
    }

    private func encode(_ value: T?) -> Data? {
        guard let value = value else {
            return nil
        }

        if T.self == String.self {
            let string = value as? String ?? ""
            return Data(string.utf8)
        } else {
            do {
                return try encoder.encode(value)
            } catch {
                return nil
            }
        }
    }

    private func delete() {
        let status = SecItemDelete(self.searchQuery as CFDictionary)

        guard status == errSecSuccess || status == errSecItemNotFound else {
            return
        }
    }
}

// MARK: Extensions
extension Keychain where Encoder == JSONEncoder, Decoder == JSONDecoder {
    public init(service: String,
                jsonEncoder encoder: Encoder = .init(),
                jsonDecoder decoder: Decoder = .init()) {
        self.init(service: service, encoder: encoder, decoder: decoder)
    }
}

extension Keychain: Equatable where T: Equatable {
    public static func == (lhs: Keychain<T, Encoder, Decoder>,
                           rhs: Keychain<T, Encoder, Decoder>) -> Bool {
        lhs.service == rhs.service && lhs.wrappedValue == rhs.wrappedValue
    }
}

extension Keychain: Hashable where T: Hashable {
    public func hash(into hasher: inout Hasher) {
        service.hash(into: &hasher)
        wrappedValue?.hash(into: &hasher)
    }
}

// MARK: Decoder

public protocol KeychainDecoder {
    associatedtype Input

    func decode<T>(_ type: T.Type, from: Self.Input) throws -> T where T: Decodable
}

extension JSONDecoder: KeychainDecoder {}
extension PropertyListDecoder: KeychainDecoder {}

// MARK: Encoder

public protocol KeychainEncoder {
    associatedtype Output

    func encode<T>(_ value: T) throws -> Self.Output where T: Encodable
}

extension JSONEncoder: KeychainEncoder {}
extension PropertyListEncoder: KeychainEncoder {}
