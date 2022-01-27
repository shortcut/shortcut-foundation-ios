//
//  NetworkingClient+JSON.swift
//  ShortcutFoundation
//
//  Created by Gabriel Sabadin, Karl Söderberg on 2021-08-16.
//  Copyright © 2021 Shortcut Scandinavia Apps AB. All rights reserved.
//

import Foundation
import Combine

//public extension NetworkingClient {
//
//    func get<Payload: Params>(_ route: String, params: Payload? = nil) -> AnyPublisher<Any, Error> {
//        get(route, params: params).toJSON()
//    }
//
//    func post<Payload: Params>(_ route: String, params: Payload? = nil) -> AnyPublisher<Any, Error> {
//        post(route, params: params).toJSON()
//    }
//
//    func put<Payload: Params>(_ route: String, params: Payload? = nil) -> AnyPublisher<Any, Error> {
//        put(route, params: params).toJSON()
//    }
//
//    func patch<Payload: Params>(_ route: String, params: Payload? = nil) -> AnyPublisher<Any, Error> {
//        patch(route, params: params).toJSON()
//    }
//
//    func delete<Payload: Params>(_ route: String, params: Payload? = nil) -> AnyPublisher<Any, Error> {
//        delete(route, params: params).toJSON()
//    }
//}

// Data to JSON
extension AnyPublisher where Output == Data {
    public func toJSON() -> AnyPublisher<Any, Error> {
         tryMap { data -> Any in
            return try JSONSerialization.jsonObject(with: data, options: [])
        }.eraseToAnyPublisher()
    }
}
