//
//  NetworkingService.swift
//  ShortcutFoundation
//
//  Created by Gabriel Sabadin, Karl Söderberg on 2021-08-16.
//  Copyright © 2021 Shortcut Scandinavia Apps AB. All rights reserved.
//

import Foundation
import Combine

public protocol NetworkingService {
    var network: NetworkingClient { get }
}

public extension NetworkingClient {
    func get<Payload: Encodable>(_ route: String, params: Payload) -> NetworkPublisher<Data> {
        request(.get, route, params: params).publisher()
    }

    func get(_ route: String) -> AnyPublisher<Data, NetworkingError> {
        request(.get, route).publisher()
    }

    func get<Payload: Encodable>(_ route: String, params: Payload) -> NetworkPublisher<Void> {
        request(.get, route, params: params).voidPublisher()
    }

    func get(_ route: String) -> AnyPublisher<Void, NetworkingError> {
        request(.get, route).voidPublisher()
    }

    func post<Payload: Encodable>(_ route: String, params: Payload? = nil) -> NetworkPublisher<Data> {
        request(.post, route, params: params).publisher()
    }

    func put<Payload: Encodable>(_ route: String, params: Payload? = nil) -> NetworkPublisher<Data> {
        request(.put, route, params: params).publisher()
    }

    func patch<Payload: Encodable>(_ route: String, params: Payload? = nil) -> NetworkPublisher<Data> {
        request(.patch, route, params: params).publisher()
    }

    func delete<Payload: Encodable>(_ route: String, params: Payload? = nil) -> NetworkPublisher<Data> {
        request(.delete, route, params: params).publisher()
    }

    func put<Payload: Encodable>(_ route: String, params: Payload? = nil) -> NetworkPublisher<Void> {
        request(.put, route, params: params).voidPublisher()
    }

    func patch<Payload: Encodable>(_ route: String, params: Payload? = nil) -> NetworkPublisher<Void> {
        request(.patch, route, params: params).voidPublisher()
    }

    func delete<Payload: Encodable>(_ route: String, params: Payload? = nil) -> NetworkPublisher<Void> {
        request(.delete, route, params: params).voidPublisher()
    }
}
