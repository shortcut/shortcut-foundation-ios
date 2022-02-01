//
//  NetworkingClient+NetworkingJSONDecodable.swift
//  ShortcutFoundation
//
//  Created by Gabriel Sabadin, Karl Söderberg on 2021-08-16.
//  Copyright © 2021 Shortcut Scandinavia Apps AB. All rights reserved.
//

import Foundation
import Combine

public typealias NetworkPublisher<Response> = AnyPublisher<Response, NetworkingError>

public extension NetworkingClient {

    func get<ResponsePayload: Decodable, Payload: Encodable>(_ route: String, params: Payload) -> NetworkPublisher<ResponsePayload> {
        return dataRequest(.get, route, params: params)
            .decode(type: ResponsePayload.self, decoder: self.decoder)
            .mapError { NetworkingError(error: $0) }
            .eraseToAnyPublisher()
    }

    func get<ResponsePayload: Decodable>(_ route: String) -> NetworkPublisher<ResponsePayload> {
        return dataRequest(.get, route)
            .decode(type: ResponsePayload.self, decoder: self.decoder)
            .mapError { NetworkingError(error: $0) }
            .eraseToAnyPublisher()
    }

    func post<ResponsePayload: Decodable, Payload: Encodable>(_ route: String, params: Payload) -> NetworkPublisher<ResponsePayload> {
        return dataRequest(.post, route, params: params)
            .decode(type: ResponsePayload.self, decoder: self.decoder)
            .mapError { NetworkingError(error: $0) }
            .eraseToAnyPublisher()
    }

    func post<ResponsePayload: Decodable>(_ route: String) -> NetworkPublisher<ResponsePayload> {
        return dataRequest(.post, route)
            .decode(type: ResponsePayload.self, decoder: self.decoder)
            .mapError { NetworkingError(error: $0) }
            .eraseToAnyPublisher()
    }

    func post(_ route: String) -> AnyPublisher<Void, NetworkingError> {
        return dataRequest(.post, route)
            .map { _ in Void() }
            .mapError { NetworkingError(error: $0) }
            .eraseToAnyPublisher()
    }

    func post<Payload: Encodable>(_ route: String, params: Payload) -> NetworkPublisher<Void> {
        return dataRequest(.post, route, params: params)
            .map { _ in Void() }
            .mapError { NetworkingError(error: $0) }
            .eraseToAnyPublisher()
    }

    func put<ResponsePayload: Decodable, Payload: Encodable>(_ route: String, params: Payload) -> NetworkPublisher<ResponsePayload> {
        return dataRequest(.put, route, params: params)
            .decode(type: ResponsePayload.self, decoder: self.decoder)
            .mapError { NetworkingError(error: $0) }
            .eraseToAnyPublisher()
    }

    func put<ResponsePayload: Decodable>(_ route: String) -> NetworkPublisher<ResponsePayload> {
        return dataRequest(.put, route)
            .decode(type: ResponsePayload.self, decoder: self.decoder)
            .mapError { NetworkingError(error: $0) }
            .eraseToAnyPublisher()
    }

    func patch<ResponsePayload: Decodable, Payload: Encodable>(_ route: String, params: Payload) -> NetworkPublisher<ResponsePayload> {
        return dataRequest(.patch, route, params: params)
            .decode(type: ResponsePayload.self, decoder: self.decoder)
            .mapError { NetworkingError(error: $0) }
            .eraseToAnyPublisher()
    }

    func patch<ResponsePayload: Decodable>(_ route: String) -> NetworkPublisher<ResponsePayload> {
        return dataRequest(.patch, route)
            .decode(type: ResponsePayload.self, decoder: self.decoder)
            .mapError { NetworkingError(error: $0) }
            .eraseToAnyPublisher()
    }

    func delete<ResponsePayload: Decodable, Payload: Encodable>(_ route: String, params: Payload) -> NetworkPublisher<ResponsePayload> {
        return dataRequest(.delete, route, params: params)
            .decode(type: ResponsePayload.self, decoder: self.decoder)
            .mapError { NetworkingError(error: $0) }
            .eraseToAnyPublisher()
    }

    func delete<ResponsePayload: Decodable>(_ route: String) -> NetworkPublisher<ResponsePayload> {
        return dataRequest(.delete, route)
            .decode(type: ResponsePayload.self, decoder: self.decoder)
            .mapError { NetworkingError(error: $0) }
            .eraseToAnyPublisher()
    }

    func delete<Payload: Encodable>(_ route: String, params: Payload) -> NetworkPublisher<Void> {
        request(.delete, route, params: params).voidPublisher()
    }

    func delete(_ route: String) -> AnyPublisher<Void, NetworkingError> {
        request(.delete, route).voidPublisher()
    }

    func dataRequest<Payload: Encodable>(_ httpVerb: HTTPVerb, _ route: String, params: Payload) -> NetworkPublisher<Data> {
        request(httpVerb, route, params: params).publisher()
    }

    func dataRequest(_ httpVerb: HTTPVerb, _ route: String) -> NetworkPublisher<Data> {
        request(httpVerb, route).publisher()
    }

    func postData(_ httpVerb: HTTPVerb, _ route: String) ->NetworkPublisher<Data> {
        request(.post, route).publisher()
    }
}
